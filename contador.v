module contador(clk, sel, tempo, aux, pause, reseta, cfg, salve, tim1, tim2);
	
	/* inputs */
	input reseta;
	input clk;
	input sel;
	input [15:0] tempo;
	input pause;
	input cfg;
	input salve;
	/* inputs */
	
	/* outputs */
	output reg [15:0] aux;
	output reg tim1, tim2;
	
	/* cabos */
	wire cfg;
	wire reseta;
	/* cabos */
	
	/* registradores */
	reg[25:0] cont;
	reg [15:0] segundos;
	reg [25:0] cont_aux;
	reg [15:0] segundim;
	reg flag;
	reg flag_aux;
	reg flag2;	
	reg reseta_aux;
	/* registradores */

	initial begin
		tim1 <= 0;
		tim2 <= 0;
		flag2 <= 0;
		flag <= 0;
		flag_aux <= 1;
	end

	always @ (posedge clk) begin
		case(cfg) // aqui analisamos se estamos no modo de 'config' ou 'contador'
			1:begin
				if(salve == 1) flag2 = 0; // ao apertar o '#', permite que setemos inicialmente o valor no BCD
				if(flag2 == 0) begin
					flag2 = 1;
					cont <= 0;
					segundos <= 0;
					aux <= 0;
				end
				else begin
					if(!sel) segundos <= 0; // aqui setamos o numero que iremos trabalhar inicialmente, cronometro é inicializado com 0, temporizador com o valor maximo.
					else segundos <= tempo;
					aux <= tempo;
				end
				tim1 <= 0;
				tim2 <= 0;
			end		
			0: begin
				if(salve == 1) flag = 0;	
				if(reseta == flag_aux) begin
					case(sel)
						0:begin
							segundos <= 16'b000000000000000;
							cont <= 0;
						end	
						1:begin
							segundos <= tempo;
							cont <= 0;
						end
					endcase
					if(flag_aux == 1) flag_aux <= 0;
					if(flag_aux == 0) flag_aux <= 1;
				end
				
				if(!flag) begin 
					if(sel) segundos <= tempo;
					else segundos <= 0;
					flag <= 1;
				end
				

				/* aqui faz a parte da contagem */
				cont_aux <= cont;
				segundim <= segundos;
				cont <= cont_aux + 1;
			
				if(!pause) aux <= segundos; // caso o usuario não pressione o botão de pause, mantem aux atualizado

				if(cont == 26'b01011111010111100001000000) begin
					case(sel)
						0: begin
							if(segundos < tempo) segundos <= segundim + 1; // cronometro soma +1
							else begin tim1 <= ~tim1; tim2 <= ~tim2; end
						end
						1:begin
							if(segundos > 0) segundos <= segundim - 1; // temporizador subtrai -1
							else begin tim1 <= ~tim1; tim2 <= ~tim2; end
						end
					endcase
					cont <= 0;
				end
				flag2 <= 1;
			end
		endcase
	end

endmodule
