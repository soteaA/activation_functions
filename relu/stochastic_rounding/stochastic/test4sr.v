module test;
	reg clk;
	reg rst_n;
	reg [31:0] sr_in;
	wire [15:0] sr_out;

parameter STEP = 10;

always #(STEP/2) clk =~ clk;

stochastic_rounding sr0(clk, rst_n, sr_in, sr_out);

initial begin
	$dumpfile("sr.vcd");
	$dumpvars(0, sr0);
	$dumplimit(1000000);

	clk <= 0;
	rst_n <= 1'b0;
#STEP
	rst_n <= 1'b1;
#(STEP/2)
	sr_in <= 32'h00_000_800;
#(STEP*10)
	sr_in <= 32'hff_fff_800;
#(STEP*10)
$finish;
end

endmodule
