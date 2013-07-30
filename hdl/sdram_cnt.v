`include "../hdl/sdram_defs.v"

module sdram_cnt (clk, rst, en, we, addr_in, data_out, rdy, data_in, valid, Dq_out, Dq_in, Dq_oe, Addr, Ba, Cke, Cs_n, Ras_n, Cas_n, We_n, Dqm);

  parameter addr_bits =      11;
  parameter data_bits =      32;
  parameter t_cl      =       3; /* cycles */
  parameter t_rfc     =       7; /* cycles */

  // Global signals
  input wire clk;
  input wire rst;

  // Internal interface
  input wire                   en;
  input wire                   we;
  input wire [addr_bits    :0] addr_in;
  input wire [data_bits - 1:0] data_in;
  output wire                  rdy;
  output reg [data_bits - 1:0] data_out;
  output reg                   valid;

  // Bidir signals
  output reg [data_bits - 1:0] Dq_out;
  output reg [data_bits - 1:0] Dq_oe;
  input wire [data_bits - 1:0] Dq_in;

  // Address signals
  output reg [addr_bits - 1:0] Addr;
  output reg             [1:0] Ba;

  // Control signals
  output reg       Cke;
  output wire      Cs_n;
  output wire      Ras_n;
  output wire      Cas_n;
  output wire      We_n;
  output reg [3:0] Dqm;

  integer i;

  reg [3:0]  state, next_state;
  reg [13:0] ref_cnt;
  reg [3:0]  clk_cnt;

  wire dly_full = (ref_cnt == `DLY_FULL);

  reg [3:0] cmd;
  reg [2:0] init_step;
  assign {Cs_n, Ras_n, Cas_n, We_n} = cmd;

  wire ref_dly  = (ref_cnt == `REF_REQ);
  wire ref_full = (ref_cnt == `REF_FULL);

  reg ref_req, ref_err, idle;

  assign rdy = (idle & !ref_req & !ref_dly);

  always @(posedge clk)
  begin
    if(rst)
    begin
      state <= `STATE_S0;

      // Bidir signals
      for(i = 0; i < data_bits; i = i + 1)
      begin
        Dq_oe[i] <= 1'b0;
      end

      Ba <= 2'd0;

      // Control signals
      Cke <= 1'b0;
      cmd <= `COM_INHIBIT;
      Dqm <= 4'b1111;
    end // if(rst)
    else
    begin
      // Default assignments
      idle <= 1'b0;
      valid <= 1'b0;
      state <= state;
      next_state <= next_state;

      // Always increment counters
      ref_cnt <= ref_cnt + 1;
      clk_cnt <= clk_cnt + 1;

      // Bidir signals
      Dq_out <= Dq_out;
      Dq_oe <= Dq_oe;

      // Address signals
      Addr <= Addr;
      Ba <= Ba;

      // Control signals
      Cke <= Cke;
      cmd <= `COM_NOP;
      Dqm <= Dqm;

      ref_req <= ref_req;
      ref_err <= ref_err;

      if(ref_dly)
        ref_req <= 1'b1;
      else if(ref_full)
        ref_err <= 1'b1;

      case(state)
        `STATE_S0:
        begin
          if(en)
          begin
            state <= `STATE_WAIT;
            Cke <= 1'b0;
            ref_cnt <= 14'd0; // Misuse refresh counter
          end
        end

        `STATE_WAIT:
        begin
          if(dly_full)
          begin
            state <= `STATE_INIT;
            clk_cnt <= 4'd0;
            Cke <= 1'b1;
            init_step <= 3'd0;
          end
        end

       `STATE_INIT:
        begin
          clk_cnt <= 4'd0;
          init_step <= init_step + 1;

          case(init_step)
            3'd0:
            begin
              state <= `STATE_PRECHARGE;
              next_state <= `STATE_INIT;
            end

            3'd1:
            begin
              state <= `STATE_REFRESH;
              next_state <= `STATE_INIT;
            end

            3'd2:
            begin
              state <= `STATE_REFRESH;
              next_state <= `STATE_INIT;
            end

            3'd3:
            begin
              ref_err <= 1'b0; // There is no error yet
              state <= `STATE_LMR;
              next_state <= `STATE_IDLE;
            end
          endcase
        end

        `STATE_PRECHARGE:
        begin
          Addr[10] <= 1'b1; // Precharge all

          case(clk_cnt)
            4'd0:
              cmd <= `COM_PRECHARGE;
            4'd1:
            begin
              clk_cnt <= 4'd0;
              state <= next_state;
            end
          endcase
        end

        `STATE_REFRESH:
        begin
          case(clk_cnt)
            4'd0:
            begin
              cmd <= `COM_REFRESH;
              Ba <= 2'b11;
              ref_req <= 1'b0;
              ref_cnt <= 14'd0;
            end
            t_rfc:
              state <= next_state;
          endcase
        end

        `STATE_LMR:
        begin
          case(clk_cnt)
            4'd0:
            begin
              cmd <= `COM_LMR;
              Ba <= 2'd0;
              Addr <= {2'd0, `WR_BURST_PROG, `OPMODE_STD, `CAS_3, `BURST_SEQUENTIAL, `BURST_1};
            end
            4'd1:
              state <= next_state;
          endcase
        end

        `STATE_IDLE:
        begin
          idle <= 1'b1;

          if(ref_req)
          begin
            state <= `STATE_REFRESH;
            next_state <= `STATE_IDLE;
          end
          else if(en)
          begin
            idle <= 1'b0;
            clk_cnt <= 4'd0;
            Addr[10] <= 1'b0; // Disable Autoprecharge

            {Ba, Addr[9:0]} <= addr_in;

            Dqm <= 4'd0;
            Dq_out <= data_in;

            state <= `STATE_ACTIVATE;

            if(we)
              next_state <= `STATE_WRITE;
            else
              next_state <= `STATE_READ;
          end
        end

        `STATE_ACTIVATE:
        begin
          case(clk_cnt)
            4'd0:
              cmd <= `COM_ACTIVATE;
            4'd1:
            begin
              clk_cnt <= 4'd0;
              state <= next_state;
            end
          endcase
        end

        `STATE_WRITE:
        begin
          case(clk_cnt)
            4'd0:
            begin
              Dq_oe <= 32'hffffffff;
              cmd <= `COM_WRITE;
            end

            t_cl:
            begin
              clk_cnt <= 4'd0;
              state <= `STATE_PRECHARGE;
              next_state <= `STATE_IDLE;
            end
          endcase
        end

        `STATE_READ:
        begin
          case(clk_cnt)
            4'd0:
            begin
              Dq_oe <= 32'd0;
              cmd <= `COM_READ;
            end

            t_cl:
            begin
              data_out <= Dq_in;
              valid <= 1'b1;

              clk_cnt <= 4'd0;
              state <= `STATE_PRECHARGE;
              next_state <= `STATE_IDLE;
            end
          endcase
        end

      endcase
    end // if(!rst)
  end // always@(posedge clk)
endmodule
