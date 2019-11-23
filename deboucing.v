module deboucing(clk, botao, botao_debouce);

	input clk;
	input botao;
	output reg botao_debouce;
	
	reg[1:0]state;
	reg[18:0]cont;
	
	parameter [1:0]wait_for_it=2'b00, contando=2'b01, botao_valido=2'b10;
	
	initial begin
		cont<=19'b0000000000000000000;
		state <= 2'b00;
		botao_debouce <= 1'b0;
	end
	
	always@(posedge clk)begin
		case(state)
		wait_for_it:
			begin
				if(botao==1) state <= contando;
				else state <= wait_for_it;
			end
		contando:
			begin
				cont <= cont + 1;
				if(cont==19'b1111010000100100000 && botao) state <= botao_valido;
				else if(cont==19'b1111010000100100000 && !botao) state <= wait_for_it;
			end
		botao_valido:
			begin
				botao_debouce <=1;
				if(botao==0) state <= wait_for_it;
			end
		endcase
	end


endmodule 