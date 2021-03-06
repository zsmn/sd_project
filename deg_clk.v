module deg_clk(clk, d_clk);

	/* inputs */
	input clk;
	/* inputs */
	
	/* outputs */
	output reg d_clk;
	/* outputs */

	/* registradores */
	reg [26:0] cont;
	reg [26:0] cont_aux;
	/* registradores */

	always @(posedge clk) begin
		if(cont == 27'd500000) begin
			cont <= 0;
			cont_aux <= 0;
			d_clk <= ~d_clk;
		end
		else begin
			cont <= cont_aux + 1;
			cont_aux <= cont;
		end
	end

endmodule
