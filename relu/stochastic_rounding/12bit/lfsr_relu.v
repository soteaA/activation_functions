module relu(clk, rst_n, in, out);
	input wire clk, rst_n;
	/*
	 * [31:31]: sign
	 * [30:30]: resv
	 * [29:24]: decimal
	 * [23:0] : fractional
	 */
	input wire [31:0] in;
	/*
	 * [15:15]: sign
	 * [14:12]: decimal
	 * [11:0] : fractional
	 */
	output reg [15:0] out;

	reg [15:0] lsfr;
	wire [31:0] add;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		lsfr <= 16'h9fc7;
		out <= 16'h0;
	end else begin
		lsfr[0] <= lsfr[1];
		lsfr[1] <= lsfr[2];
		lsfr[2] <= lsfr[3];
		lsfr[3] <= lsfr[4];
		lsfr[4] <= lsfr[5];
		lsfr[5] <= lsfr[6];
		lsfr[6] <= lsfr[7];
		lsfr[7] <= lsfr[8];
		lsfr[8] <= lsfr[9];
		lsfr[9] <= lsfr[10];
		lsfr[10] <= lsfr[11];
		lsfr[11] <= lsfr[0] ^ lsfr[12];
		lsfr[12] <= lsfr[13];
		lsfr[13] <= lsfr[0] ^ lsfr[14];
		lsfr[14] <= lsfr[0] ^ lsfr[15];
		lsfr[15] <= lsfr[0];
		if (!add[31]) begin
			out <= (&(!add[30:27])) ? {add[31],add[26:12]} : 16'h7fff;
		end else begin
			out <= 16'h0;
		end
	end
end

assign add = in + {20'h0, lsfr[11:0]};

endmodule

