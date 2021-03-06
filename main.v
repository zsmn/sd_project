module main(clk, a1, b1, c1, d1, e1, f1, g1, a2, b2, c2, d2, e2, f2, g2, a3, b3, c3, d3, e3, f3, g3, a4, b4, c4, d4, e4, f4, g4, sel, 
	pause, cfg, reseta, in, out, salve, tim1, tim2);
	
	/* inputs */
	input [3:0]in;
	input clk;
	input sel;
	input cfg;
	input pause;
	input reseta;
	/* inputs */
	
	/* outputs */
	output a1, b1, c1, d1, e1, f1, g1;
	output a2, b2, c2, d2, e2, f2, g2;
	output a3, b3, c3, d3, e3, f3, g3;
	output a4, b4, c4, d4, e4, f4, g4;
	output [3:0] out;
	output salve;
	output tim1, tim2;
	/* outputs */
	
	/* registradores */
	reg pp;
	reg rr;
	reg[15:0] registrador_w_aa;
	reg[15:0] registrador_final;
	reg[15:0] GAMB;
	/* registradores */
	
	/* fios */
	wire[15:0] registrador_w;
	wire[15:0] registrador_aux_w;
	wire[15:0] resposta;
	wire[15:0] registradorin;
	wire[15:0] registrador_dec_w;
	wire[15:0] registrador_fantasia_final;
	wire[15:0] reole;
	wire[15:0] hell;
	wire deg_clk;
	/* fios */
	
	initial begin
		pp <= 1'b0;
		rr <= 1'b0;
		registrador_final <=  16'b0000000000000000;
		GAMB <=  16'b0000000000000000;
	end
	
	always @(negedge pause) begin
		pp = ~pp;
	end
	
	always @(negedge reseta) begin
		rr = ~rr;
	end
	
	deg_clk(clk, deg_clk);
	teclado2 keyboard(deg_clk, in, out, registrador_w, salve);
	assign registradorin = registrador_w;
	conversaobin_dec cbd(deg_clk, registradorin, registrador_dec_w);
	
	always @(*) begin
		if(salve == 1)begin
			registrador_final <= registrador_dec_w;
		end
	end
	
	assign registrador_fantasia_final = registrador_final;
	
	contador cnt(clk, sel, registrador_fantasia_final, registrador_aux_w, pp, rr, cfg, salve, tim1, tim2);
	conversaodec_bin cdb(clk, registrador_aux_w, resposta);
	bcd a(clk,resposta, a1, b1, c1, d1, e1, f1, g1, a2, b2, c2, d2, e2, f2, g2,
	a3, b3, c3, d3, e3, f3, g3, a4, b4, c4, d4, e4, f4, g4);
	
endmodule
