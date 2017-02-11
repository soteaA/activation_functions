module test;
	reg clk, rst_n;
	reg [31:0] plan_in;
	wire [15:0] plan_out;

parameter STEP = 10;

always #(STEP/2) clk =~ clk;

sigmoid s0(clk, rst_n, plan_in, plan_out);

initial begin
	$dumpfile("test4sigmoid.vcd");
	$dumpvars(0, s0);
	$dumplimit(100000);

	clk <= 0;
	rst_n <= 0;
#STEP
	rst_n <= 1;
#(STEP/2)
	plan_in <= 32'hff_800000;	//-0.5 -> 0.375
#STEP
	plan_in <= 32'h01_400000;	//+1.25 -> 0.78125
#STEP
	plan_in <= 32'h02_800000;	//+2.5 -> 0.921875
#STEP
	plan_in <= 32'hfa_c00000;	//-5.25 -> 0.0
#STEP
	plan_in <= 32'h00_800000;	//+0.5 -> 0.625
#STEP
	plan_in <= 32'hfe_c00000;	//-1.25 -> 0.21875
#STEP
	plan_in <= 32'hfd_800000;	//-2.5 -> 0.078125
#STEP
	plan_in <= 32'h05_400000;	//+5.25 -> 1.0
#STEP
#(STEP*10)
$finish;
end

endmodule
