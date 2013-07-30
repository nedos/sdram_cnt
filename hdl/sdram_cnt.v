module sdram_cnt (clk, rst, en, we, addr_in, data_out, rdy, data_in, valid, Dq_out, Dq_in, Dq_oe, Addr, Ba, Cke, Cs_n, Ras_n, Cas_n, We_n, Dqm);

  parameter addr_bits =      11;
  parameter data_bits =      32;
  parameter col_bits  =       8;
  parameter mem_sizes =  524287;

  // Global signals
  input wire clk;
  input wire rst;

  // Internal interface
  input wire                   en;
  input wire                   we;
  input wire [11:0]            addr_in;
  input wire [data_bits - 1:0] data_in;
  output reg                   rdy;
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
  output reg       Cs_n;
  output reg       Ras_n;
  output reg       Cas_n;
  output reg       We_n;
  output reg [3:0] Dqm;

  integer i;

  // mode[2:0]
  `define BURST_1           3'b000
  `define BURST_2           3'b001
  `define BURST_4           3'b010
  `define BURST_8           3'b011

  // mode[3]
  `define BURST_FULL        3'b111
  `define BURST_SEQUENTIAL  1'b0
  `define BURST_INTERLEAVED 1'b1

  // mode[6:4]
  `define CAS_1             3'b001
  `define CAS_2             3'b010
  `define CAS_3             3'b011

  // mode[8:7]
  `define OPMODE_STD        2'b00

  // mode[9]
  `define WR_BURST_PROG     1'b0
  `define WR_BURST_SINGLE   1'b1

  reg [3:0] state, next_state;

  `define STATE_S0        0
  `define STATE_WAIT      1
  `define STATE_INIT      2
  `define STATE_PRECHARGE 3
  `define STATE_REFRESH   4
  `define STATE_LMR       5
  `define STATE_IDLE      6
  `define STATE_ACTIVATE  7
  `define STATE_WRITE     8
  `define STATE_READ      9

  reg [13:0] clk_cnt;

  `define CLK_FULL (100000/10)
  wire clk_full = (clk_cnt == `CLK_FULL);

  wire [3:0] command = {Cs_n, Ras_n, Cas_n, We_n};

  //CS# RAS# CAS# WE#
  `define COM_INHIBIT   4'b1111
  `define COM_NOP       4'b0111
  `define COM_PRECHARGE 4'b0010
  `define COM_REFRESH   4'b0001
  `define COM_LMR       4'b0000
  `define COM_ACTIVATE  4'b0011
  `define COM_WRITE     4'b0100
  `define COM_READ      4'b0101

  reg [2:0] cmd_cnt;

  always @(posedge clk)
  begin
    if(rst)
    begin
      state <= `STATE_S0;

      // Bidir signals
      for(i = 0; i < data_bits; i = i + 1)
      begin
        Dq_out[i] <= 1'b0;
        Dq_oe[i] <= 1'b0;
      end

      // Address signals
      for(i = 0; i < addr_bits; i = i + 1)
      begin
        Addr[i] <= 1'b0;
      end

      Ba <= 2'd0;

      // Control signals
      Cke <= 1'b0;
      {Cs_n, Ras_n, Cas_n, We_n} <= `COM_INHIBIT;
      Dqm <= 4'hf;
    end // if(rst)
    else
    begin
      // Default assignments
      rdy <= 1'b0;
      valid <= 1'b0;
      state <= state;
      next_state <= next_state;
      clk_cnt <= clk_cnt + 1;

      // Bidir signals
      for(i = 0; i < data_bits; i = i + 1)
      begin
        Dq_out[i] <= Dq_out[i];
        Dq_oe[i] <= Dq_oe[i];
      end

      // Address signals
      for(i = 0; i < addr_bits; i = i + 1)
      begin
        Addr[i] <= Addr[i];
      end

      Ba <= Ba;

      // Control signals
      Cke <= Cke;
      {Cs_n, Ras_n, Cas_n, We_n} <= `COM_NOP;
      Dqm <= Dqm;

      case(state)
        `STATE_S0:
        begin
          if(en)
          begin
            state <= `STATE_WAIT;
            Cke <= 1'b0;
            clk_cnt <= 14'd0;
          end
        end

        `STATE_WAIT:
        begin
          if(clk_full)
          begin
            state <= `STATE_INIT;
            clk_cnt <= 14'd0;
            Cke <= 1'b1;
            cmd_cnt <= 3'd0;
          end
        end

       `STATE_INIT:
        begin
          clk_cnt <= 14'd0;
          cmd_cnt <= cmd_cnt + 1;

          case(cmd_cnt)
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
              state <= `STATE_LMR;
              next_state <= `STATE_IDLE;
            end
          endcase
        end

        `STATE_PRECHARGE:
        begin
          Addr[10] <= 1'b1; // Precharge all

          case(clk_cnt)
            14'd0:
              {Cs_n, Ras_n, Cas_n, We_n} <= `COM_PRECHARGE;
            14'd1:
            begin
              clk_cnt <= 14'd0;
              state <= next_state;
            end
          endcase
        end

        `STATE_REFRESH:
        begin
          case(clk_cnt)
            14'd0:
            begin
              {Cs_n, Ras_n, Cas_n, We_n} <= `COM_REFRESH;
              Ba <= 2'b11;
            end
            14'd6:
              state <= next_state;
          endcase
        end

        `STATE_LMR:
        begin
          case(clk_cnt)
            14'd0:
            begin
              {Cs_n, Ras_n, Cas_n, We_n} <= `COM_LMR;
              Ba <= 2'd0;
              Addr <= {2'd0, `WR_BURST_PROG, `OPMODE_STD, `CAS_3, `BURST_SEQUENTIAL, `BURST_1};
            end
            14'd1:
              state <= next_state;
          endcase
        end

        `STATE_IDLE:
        begin
          rdy <= 1'b1;

          if(en)
          begin
            rdy <= 1'b0;
            clk_cnt <= 14'd0;
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
            14'd0:
              {Cs_n, Ras_n, Cas_n, We_n} <= `COM_ACTIVATE;
            14'd1:
            begin
              clk_cnt <= 14'd0;
              state <= next_state;
            end
          endcase
        end

        `STATE_WRITE:
        begin
          case(clk_cnt)
            14'd0:
            begin
              Dq_oe <= 32'hffffffff;
              {Cs_n, Ras_n, Cas_n, We_n} <= `COM_WRITE;
            end
            14'd3:
            begin
              clk_cnt <= 14'd0;
              state <= `STATE_PRECHARGE;
              next_state <= `STATE_IDLE;
            end
          endcase
        end

        `STATE_READ:
        begin
          case(clk_cnt)
            14'd0:
            begin
              Dq_oe <= 32'd0;
              {Cs_n, Ras_n, Cas_n, We_n} <= `COM_READ;
            end

            14'd3:
            begin
              data_out <= Dq_in;
              valid <= 1'b1;

              clk_cnt <= 14'd0;
              state <= `STATE_PRECHARGE;
              next_state <= `STATE_IDLE;
            end
          endcase
        end

      endcase
    end // if(!rst)
  end // always@(posedge clk)
endmodule
