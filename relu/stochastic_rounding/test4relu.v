module test;
	reg clk, rst_n;
	reg [31:0] in;
	wire [15:0] out;

parameter STEP = 10;

always #(STEP/2) clk =~ clk;

relu relu0(clk, rst_n, in, out);

initial begin
	$dumpfile("test4relu.vcd");
	$dumpvars(0, relu0);
	$dumplimit(100000);

	clk <= 0;
	rst_n <= 0;
#STEP
	rst_n <= 1;
#(STEP/2)
	in <= 32'h00_000_800;
#(STEP*30)
$finish;
end

endmodule
