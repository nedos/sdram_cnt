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

reg [12:0] tb_addr;
reg [31:0] tb_data;
reg        tb_we;

wire rdy;
wire valid;
wire [31:0] data_out;

wire [31:0] Dq_out;
wire [10:0] Addr;
wire [1:0]  Ba;
wire        Cke;
wire        Cs_n;
wire        Ras_n;
wire        Cas_n;
wire        We_n;
wire [3:0]  Dqm;

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
  //.Dq_in,
  //.Dq_oe,
  .Addr(Addr),
  .Ba(Ba),
  .Cke(Cke),
  .Cs_n(Cs_n),
  .Ras_n(Ras_n),
  .Cas_n(Cas_n),
  .We_n(We_n),
  .Dqm(Dqm));

mt48lc2m32b2 sdrami (
  .Dq(Dq_out),
  .Addr(Addr),
  .Ba(Ba),
  .Clk(~tb_clk),
  .Cke(Cke),
  .Cs_n(Cs_n),
  .Ras_n(Ras_n),
  .Cas_n(Cas_n),
  .We_n(We_n),
  .Dqm(Dqm));

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
input [12:0] addr;
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
input [12:0] addr;
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




// Task for reading via UART
// task tb_read;
// 
// input [7:0] data;
// 
// begin
//   tb_timeout_cnt <= 24'd0; // Reset watchdog
// 
//   wait(rx_valid || tb_timeout);
// 
//   if(tb_timeout)
//   begin
//     $display("READ Timeout");
//     $stop;
//   end
//   else
//   begin
//     if(rx_data != data)
//     begin
//       $display("WRITE failed: Expected 0x%02H, Got 0x%02H", data, rx_data);
//       $stop;
//     end
//   end
// end
// 
// endtask



always @(posedge tb_rst)
begin
  tb_data <= 32'd0;
  tb_addr <= 11'd0;
end

reg [31:0] result;

initial
begin
  wait(tb_en); // wait until fully reset
  @(posedge tb_clk);
  tb_en <= 1'b0;

  wait(rdy);
  tb_write(13'd0,32'hFFFFFFFF);
  tb_write(13'd1,32'h55555555);
  tb_write({2'b11,11'd1},32'hAAAAAAAA);
  tb_read(13'd0, result);
  tb_read(13'd1, result);
  tb_read({2'b11,11'd1},result);
  //repeat(256)
  //begin
  //  del = ({$random} % 100);
  //  value = ({$random} % 256);
  //  $display ("Delay = %d, Value = 0x%2X", del, value);
  //  #(del) tb_write(value);
  //end

  $display("Testbench completed successfully!");
  $stop;
end
endmodule
