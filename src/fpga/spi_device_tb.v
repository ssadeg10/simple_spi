`timescale 1ns / 1ps

module spi_device_tb;

reg clk, rst, cs, mosi;
wire miso;
wire [7:0] data_out;
integer i;

spi_device dut(clk, rst, cs, mosi, miso, data_out);

initial begin
	$dumpfile("spi_device.vcd");
	$dumpvars(0, spi_device_tb);

	clk = 0;
	rst = 1;
	cs = 1;
	mosi = 0;
	
	#10 @(posedge clk);
	rst = 0;
	cs = 0;
	
	// send decimal number 189 (1011 1101)
	for (i = 7; i >= 0; i = i - 1) begin
		mosi = (8'd189 >> i);
		@(posedge clk);
	end
	
	cs = 1;
	#20 $finish;
end

always #5 clk = ~clk;

endmodule

