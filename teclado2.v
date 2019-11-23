module teclado2(clk, in, out, registrador_w, salve);

	input clk;
	input [3:0] in;
	
	output reg [3:0] out;
	output reg [15:0] registrador_w;
	output reg salve;
	
	/* parametros usados no case */
	parameter[2:0] coluna0 = 3'b000, coluna1 = 3'b001, coluna2 = 3'b010, debouncing = 3'b011, debouncing2 = 3'b100;
	parameter[3:0] tecla_1 = 4'b1110, tecla_4 = 4'b1101, tecla_7 = 4'b1011,
				   tecla_esp = 4'b0111, tecla_9 = 4'b1011, tecla_6 = 4'b1101, tecla_3 = 4'b1110,
				   tecla_0 = 4'b0111, tecla_8 = 4'b1011, tecla_5 = 4'b1101, tecla_2 = 4'b1110;
	/* parametros usados no case */
	
	/* registradores */
	reg [15:0] registrador_armazenamento_aux;
	reg [26:0] count;
	reg [26:0] count_aux;
	reg [3:0] numero;
	reg [2:0] state_anterior;
	reg [1:0] state_soma;
	reg [15:0] decimal_aux;
	reg [2:0] state;
	/* registradores */
	
	initial begin
		salve <= 0;
		count <= 0;
		state <= 0;
		count_aux <= 0;
	end

	always @(posedge clk) begin
		case(state)
			coluna0: begin
				out <= 4'b0111;
				state_anterior <= coluna0;
				state <= coluna1;
				registrador_w[15:12] <= registrador_armazenamento_aux[15:12];
				registrador_w[11:8] <= registrador_armazenamento_aux[11:8];
				registrador_w[7:4] <= registrador_armazenamento_aux[7:4];
				registrador_w[3:0] <= registrador_armazenamento_aux[3:0];
				case(in)
					tecla_1: begin
						numero <= 4'b0001;
						state <= debouncing;
					end
					tecla_4: begin
						numero <= 4'b0100;
						state <= debouncing;
					end
					tecla_7: begin
						numero <= 4'b0111;
						state <= debouncing;
					end
				endcase
			end
			coluna1: begin
				out <= 4'b1011;
				state_anterior <= coluna1;
				state <= coluna2;
				registrador_w[15:12] <= registrador_armazenamento_aux[15:12];
				registrador_w[11:8] <= registrador_armazenamento_aux[11:8];
				registrador_w[7:4] <= registrador_armazenamento_aux[7:4];
				registrador_w[3:0] <= registrador_armazenamento_aux[3:0];
				case(in)
					tecla_esp: begin
						salve <= 1;
						state <= debouncing2;
					end
					tecla_9: begin
						numero <= 4'b1001;
						state <= debouncing;
					end
					tecla_6: begin
						numero <= 4'b0110;
						state <= debouncing;
					end
					tecla_3: begin
						numero <= 4'b0011;
						state <= debouncing;
					end
				endcase
			end
			coluna2: begin
				out <= 4'b1101;
				state_anterior <= coluna2;
				state <= coluna0;
				registrador_w[15:12] <= registrador_armazenamento_aux[15:12];
				registrador_w[11:8] <= registrador_armazenamento_aux[11:8];
				registrador_w[7:4] <= registrador_armazenamento_aux[7:4];
				registrador_w[3:0] <= registrador_armazenamento_aux[3:0];
				case(in)
					tecla_0: begin
						numero <= 4'b0000;
						state <= debouncing;
					end
					tecla_8: begin
						numero <= 4'b1000;
						state <= debouncing;
					end
					tecla_5: begin
						numero <= 4'b0101;
						state <= debouncing;
					end
					tecla_2: begin
						numero <= 4'b0010;
						state <= debouncing;
					end
				endcase
			end
			debouncing: begin
				if(count < 27'd1) begin
					count <= count_aux + 1;
					count_aux <= count;
					registrador_armazenamento_aux[15:12] <= registrador_w[11:8];
					registrador_armazenamento_aux[11:8] <= registrador_w[7:4];
					registrador_armazenamento_aux[7:4] <= registrador_w[3:0];
					registrador_armazenamento_aux[3:0] <= numero;
				end
				else begin
					if(in == 4'b1111) begin
						state <= state_anterior;
						registrador_w[15:12] <= registrador_armazenamento_aux[15:12];
						registrador_w[11:8] <= registrador_armazenamento_aux[11:8];
						registrador_w[7:4] <= registrador_armazenamento_aux[7:4];
						registrador_w[3:0] <= registrador_armazenamento_aux[3:0];
						count <= 0;
						count_aux <= 0;
					end
					else begin
						state <= state_anterior;
						count <= 0;
						count_aux <= 0;
					end
				end
			end
			
			debouncing2:begin
				if(count < 27'd1) begin
					count <= count_aux + 1;
					count_aux <= count;
				end
				else begin
					if(in == 4'b1111) begin
						state <= state_anterior;
						count <= 0;
						salve <= 0;
						count_aux <= 0;
						registrador_armazenamento_aux[15:12] <= 0;
						registrador_armazenamento_aux[11:8] <= 0;
						registrador_armazenamento_aux[7:4] <= 0;
						registrador_armazenamento_aux[3:0] <= 0;
					end
					else begin
						state <= state_anterior;
						count <= 0;
						count_aux <= 0;
					end
				end
			end
		endcase
	end

endmodule
