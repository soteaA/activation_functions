/*
 *** Piecewise Linear Approximation ***
 * 
 * fixed_point data precision
 *	[31:0]
 * 		[31]:		sign
 *		[30:24]:	integer
 *		[23:0] :	decimal
 *
 *	[15:0]
 *		[15]:		sign
 *		[14:12]:	integer
 *		[11:0] :	decimal
 */

module sigmoid(clk, rst_n, plan_in, plan_out);
	input wire clk, rst_n;
	input wire [31:0] plan_in;
	output reg [15:0] plan_out;

	reg [31:0] abs_in;
	wire [2:0] sel;

	wire [31:0] abs_lshift_5;
	wire [31:0] abs_lshift_3;
	wire [31:0] abs_lshift_2;
	wire [15:0] in_lshift_5;
	wire [15:0] in_lshift_3;
	wire [15:0] in_lshift_2;

	reg [15:0] add_0, add_1;

assign sel[0] = (abs_in >= 32'h0500_0000) ? 1'b1 : 1'b0;
assign sel[1] = (abs_in >= 32'h0260_0000) ? 1'b1 : 1'b0;
assign sel[2] = (abs_in >= 32'h0100_0000) ? 1'b1 : 1'b0;

assign abs_lshift_5 = abs_in >> 5;
assign abs_lshift_3 = abs_in >> 3;
assign abs_lshift_2 = abs_in >> 2;
assign in_lshift_5 = {1'b0, abs_lshift_5[26:12]};
assign in_lshift_3 = {1'b0, abs_lshift_3[26:12]};
assign in_lshift_2 = {1'b0, abs_lshift_2[26:12]};

always @(plan_in) begin
	// if plan_in is a negative number
	if (plan_in[31]) begin
		/* Exception: 32'h80000000 */
		abs_in = (&(~plan_in[30:0])) ? ~(plan_in+32'h1) + 32'h1 : ~plan_in + 32'h1;
	// if plan_in is a positive number
	end else begin
		abs_in = plan_in;
	end
end

always @(*) begin
	add_0 = 16'h0;
	add_1 = 16'h0;
	case (sel)
		3'b000: begin
			add_0 = 16'h0800;	//Fixed 16'h0800 = 0.5
			add_1 = in_lshift_2;	//abs_in * 0.25
		end
		3'b100: begin
			add_0 = 16'h0a00;	//Fixed 16'h0a00 = 0.625
			add_1 = in_lshift_3;
		end
		3'b110: begin
			add_0 = 16'h0d80;	//Fixed 16'h0d80 = 0.84375
			add_1 = in_lshift_5;
		end
		3'b111: begin
			add_0 = 16'h0;
			add_1 = 16'h1000;
		end
		default: begin
			add_0 = 16'h0;
			add_1 = 16'h1000;
		end
	endcase
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		plan_out <= 16'h0;
	end else begin
		plan_out <= (!plan_in[31]) ? add_0 + add_1 : 16'h1000 - (add_0 + add_1);
	end
end

endmodule
