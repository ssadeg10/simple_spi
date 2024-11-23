/*
Simple SPI Device Implementation

This module reads an 8-bit value when the select wire is pulled
low, after which it's then outputted to the register data_out
*/

module spi_device (
	input wire clk, // PIN_V10
	input wire rst,
	input wire cs, // PIN_V7
	input wire mosi, // PIN_V8
	output wire miso, // PIN_V9
	output reg [7:0] data_out
	);
	
	reg [7:0] shift;
	reg [3:0] bit_count; // count starts at 1, so need to count to 8 instead of 7
	wire cs_n = ~cs;
	
	// bit shifts on falling clock edge to capture stabalized 
	// MOSI value after changes on the rising clock edge
	always @(negedge clk) begin
		if (cs_n) begin
			shift <= {mosi, shift[7:1]};
			bit_count <= bit_count + 1;
		end
		else begin
			shift <= 8'd0;
			bit_count <= 4'd0;
		end
	end
	
	always @(posedge clk) begin
		// output data when select wire pulled up and counter = 8
		if (bit_count == 4'd8 && cs)
			data_out <= shift;
	end
	
	assign miso = (cs_n) ? clk : 1'bz; // arbitrary assignment
	
endmodule