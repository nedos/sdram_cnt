/*
 * Copyright (c) 2013, The DDK Project
 *    Dmitry Nedospasov <dmitry at nedos dot net>
 *
 * All rights reserved.
 *
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <dmitry at nedos dot net> and wrote this file. As long as you retain this
 * notice you can do whatever you want with this stuff. If we meet some day,
 * and you think this stuff is worth it, you can buy us a beer in return.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE DDK PROJECT BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

`timescale 1 ns/1 ps

module sdram_cnt_tb();

reg tb_clk;
reg tb_rst;
reg tb_en;
reg tb_dl_clk;

reg [11:0] tb_addr;
reg [31:0] tb_data;
reg        tb_we;

wire rdy;
wire valid;
wire [31:0] data_out;

wire [31:0] Dq_out;
wire [31:0] Dq_oe;
wire [31:0] Dq_in;
wire [10:0] Addr;
wire [1:0]  Ba;
wire        Cke;
wire        Cs_n;
wire        Ras_n;
wire        Cas_n;
wire        We_n;
wire [3:0]  Dqm;

wire [31:0] Dq;

sdram_cnt cnti (
  .clk(tb_clk),
  .rst(tb_rst),
  .en(tb_en),
  .we(tb_we),
  .addr_in(tb_addr),
  .data_in(tb_data),
  .rdy(rdy),
  .data_out(data_out),
  .valid(valid),
  .Dq_out(Dq_out),
  .Dq_oe(Dq_oe),
  .Dq_in(Dq),
  .Addr(Addr),
  .Ba(Ba),
  .Cke(Cke),
  .Cs_n(Cs_n),
  .Ras_n(Ras_n),
  .Cas_n(Cas_n),
  .We_n(We_n),
  .Dqm(Dqm));

mt48lc2m32b2 sdrami (
  .Dq(Dq),
  .Addr(Addr),
  .Ba(Ba),
  .Clk(~tb_clk),
  .Cke(Cke),
  .Cs_n(Cs_n),
  .Ras_n(Ras_n),
  .Cas_n(Cas_n),
  .We_n(We_n),
  .Dqm(Dqm));

assign Dq[0] = Dq_oe[0] ? Dq_out[0] : 1'bz;
assign Dq[1] = Dq_oe[1] ? Dq_out[1] : 1'bz;
assign Dq[2] = Dq_oe[2] ? Dq_out[2] : 1'bz;
assign Dq[3] = Dq_oe[3] ? Dq_out[3] : 1'bz;
assign Dq[4] = Dq_oe[4] ? Dq_out[4] : 1'bz;
assign Dq[5] = Dq_oe[5] ? Dq_out[5] : 1'bz;
assign Dq[6] = Dq_oe[6] ? Dq_out[6] : 1'bz;
assign Dq[7] = Dq_oe[7] ? Dq_out[7] : 1'bz;
assign Dq[8] = Dq_oe[8] ? Dq_out[8] : 1'bz;
assign Dq[9] = Dq_oe[9] ? Dq_out[9] : 1'bz;
assign Dq[10] = Dq_oe[10] ? Dq_out[10] : 1'bz;
assign Dq[11] = Dq_oe[11] ? Dq_out[11] : 1'bz;
assign Dq[12] = Dq_oe[12] ? Dq_out[12] : 1'bz;
assign Dq[13] = Dq_oe[13] ? Dq_out[13] : 1'bz;
assign Dq[14] = Dq_oe[14] ? Dq_out[14] : 1'bz;
assign Dq[15] = Dq_oe[15] ? Dq_out[15] : 1'bz;
assign Dq[16] = Dq_oe[16] ? Dq_out[16] : 1'bz;
assign Dq[17] = Dq_oe[17] ? Dq_out[17] : 1'bz;
assign Dq[18] = Dq_oe[18] ? Dq_out[18] : 1'bz;
assign Dq[19] = Dq_oe[19] ? Dq_out[19] : 1'bz;
assign Dq[20] = Dq_oe[20] ? Dq_out[20] : 1'bz;
assign Dq[21] = Dq_oe[21] ? Dq_out[21] : 1'bz;
assign Dq[22] = Dq_oe[22] ? Dq_out[22] : 1'bz;
assign Dq[23] = Dq_oe[23] ? Dq_out[23] : 1'bz;
assign Dq[24] = Dq_oe[24] ? Dq_out[24] : 1'bz;
assign Dq[25] = Dq_oe[25] ? Dq_out[25] : 1'bz;
assign Dq[26] = Dq_oe[26] ? Dq_out[26] : 1'bz;
assign Dq[27] = Dq_oe[27] ? Dq_out[27] : 1'bz;
assign Dq[28] = Dq_oe[28] ? Dq_out[28] : 1'bz;
assign Dq[29] = Dq_oe[29] ? Dq_out[29] : 1'bz;
assign Dq[30] = Dq_oe[30] ? Dq_out[30] : 1'bz;
assign Dq[31] = Dq_oe[31] ? Dq_out[31] : 1'bz;

initial
begin
  tb_clk <= 1'b0;
  tb_dl_clk <= 1'b0;
  tb_rst <= 1'b0;
  #50 tb_rst <= 1'b1;
  #150 tb_rst <= 1'b0;
  tb_en <= 1'b1;
end

// Generate a system clock (50MHz)
always
begin
  #5 tb_clk <= ~tb_clk;
end

always @ (posedge tb_clk or negedge tb_clk)
begin
  #1 tb_dl_clk <= ~tb_dl_clk;
end

// Create a watchdog counter
reg        tb_timeout;
reg [23:0] tb_timeout_cnt;

always @(posedge tb_clk)
begin
  tb_timeout <= 1'b0;
  tb_timeout_cnt <= tb_timeout_cnt + 1;
  if(tb_timeout_cnt == 24'd10000)
    tb_timeout <= 1'b1;
end



// Task for writing data
task tb_write;
input [11:0] addr;
input [31:0] data;

begin
  tb_timeout_cnt <= 24'd0; // Reset watchdog

  wait(rdy || tb_timeout);
  if(tb_timeout)
  begin
    $display("Write Timeout");
    $stop;
  end

  @(posedge tb_clk);
  // write data
  tb_en <= 1'b1;
  tb_we <= 1'b1;
  tb_addr <= addr;
  tb_data <= data;

  @(posedge tb_clk);
  tb_en <= 1'b0;

  wait(!rdy || tb_timeout);
  if(tb_timeout)
  begin
    $display("Write Timeout");
    $stop;
  end

  wait(rdy || tb_timeout);
  if(tb_timeout)
  begin
    $display("Write Timeout");
    $stop;
  end
end

endtask

// Task for reading data
task tb_read;
input [11:0] addr;
output [31:0] data;

begin
  tb_timeout_cnt <= 24'd0; // Reset watchdog

  wait(rdy || tb_timeout);
  if(tb_timeout)
  begin
    $display("Read Timeout");
    $stop;
  end

  @(posedge tb_clk);
  // write data
  tb_en <= 1'b1;
  tb_we <= 1'b0;
  tb_addr <= addr;

  @(posedge tb_clk);
  tb_en <= 1'b0;

  wait(valid || tb_timeout);
  if(tb_timeout)
  begin
    $display("Read Timeout");
    $stop;
  end

  data <= data_out;
end

endtask



always @(posedge tb_rst)
begin
  tb_data <= 32'd0;
  tb_addr <= 12'd0;
end

reg [31:0] result;

reg [11:0] addr1;
reg [11:0] addr2;
reg [31:0] write1;
reg [31:0] write2;

integer dly;

initial
begin
  wait(tb_en); // wait until fully reset
  @(posedge tb_clk);
  tb_en <= 1'b0;

  wait(rdy);

  repeat(256)
  begin
    addr1 = ({$random} % 12'hFFF);
    addr2 = ({$random} % 12'hFFF);
    write1 = ({$random} % 32'hFFFFFFFF);
    write2 = ({$random} % 32'hFFFFFFFF);

    dly = {$random} % 10;
    repeat(dly) @(posedge tb_clk);
    tb_write(addr1,write1);

    dly = {$random} % 10;
    repeat(dly) @(posedge tb_clk);
    tb_write(addr2,write2);

    dly = {$random} % 10;
    repeat(dly) @(posedge tb_clk);
    tb_read(addr1,result);

    if(result != write1)
    begin
      $display("WRITE failed: Expected 0x%08H, Got 0x%08H", write1, result);
      $stop;
    end

    dly = {$random} % 10;
    repeat(dly) @(posedge tb_clk);
    tb_read(addr2,result);

    if(result != write2)
    begin
      $display("WRITE failed: Expected 0x%08H, Got 0x%08H", write1, result);
      $stop;
    end
  end

  $display("Testbench completed successfully!");
  $stop;
end
endmodule
