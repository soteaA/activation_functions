module test;
	reg clk, rst_n;
	reg [15:0] in;
	wire [11:0] out;

parameter STEP = 10;

always #(STEP/2) clk =~ clk;

lfsr lfsr0(clk, rst_n, in, out);

initial begin
	$dumpfile("test4lfsr.vcd");
	$dumpvars(0, lfsr0);
	$dumplimit(100000);

	clk <= 0;
	rst_n <= 0;
#STEP
	rst_n <= 1;
#(STEP/2)
	in <= 16'b0_000_000000001000;
#(STEP*30)
$finish;
end

endmodule
