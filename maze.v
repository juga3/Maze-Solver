`timescale 1ns / 1ps

module maze(
input 		clk,
input[5:0] 	starting_col, starting_row, 		// indicii punctului de start
input 		maze_in, 							// oferă informații despre punctul de coordonate [row, col]
output reg[5:0] row, col, 							// selectează un rând si o coloană din labirint
output reg		maze_oe,							// output enable (activează citirea din labirint la rândul și coloana date) - semnal sincron	
output reg 		maze_we, 							// write enable (activează scrierea în labirint la rândul și coloana  date) - semnal sincron
output reg		done);		 						// ieșirea din labirint a fost gasită; semnalul rămane activ 

`define initialize 10
`define direction 15
`define check_right 20
`define check_forward 25
`define final_check 30


`define north 0
`define south 1
`define east 2
`define west 3

reg[5 : 0] last_row, last_col;		//variabile ce retin coordonatele unui punct, inainte de verificarea campurilor adiacente
									//cu ajutorul acestora se revine la coordonatele precedente in cazul atingerii unui zid
reg[4 : 0] state = `initialize, next_state;
reg[1 : 0] dir = `north;		//variabila ce retine directia de deplasare in labirint

always @(posedge clk) begin
	state <= next_state;
end

always @(*) begin
	maze_oe = 0;
	maze_we = 0;
	done = 0;
	
	case(state)
		`initialize: begin
			row = starting_row;
			col = starting_col;
			maze_we = 1;
			
			next_state = `direction;
		end
		
		`direction: begin		//se stabileste directia initiala de deplasare
			last_row = row;
			last_col = col;
			case(dir)
				`north: begin
					row = row - 1;
				end
				
				`south: begin
					row = row + 1;
				end
				
				`east: begin
					col = col + 1;
				end
				
				`west: begin
					col = col - 1;
				end
			endcase
			maze_oe = 1;
			next_state = `direction + 1;
		end
		
		`direction + 'd1: begin		//se verifica valabilitatea directiei
			if(maze_in == 1) begin		//in cazul atingerii unui zid se revine la coordonatele precedente si se alege o alta directie de deplasare
				row = last_row;	
				col = last_col;
				dir = dir + 1;
				next_state = `direction;
			end
			else begin
				maze_we = 1;
				next_state = `check_right;
			end
		end
			
		`check_right: begin		//se verifica posibilitatea deplasarii la dreapta
			last_row = row;
			last_col = col;
			case(dir)
				`north: begin
					col = col + 1;
				end
				
				`south: begin
					col = col - 1;
				end
				
				`east: begin
					row = row + 1;
				end
				
				`west: begin
					row = row - 1;
				end
			endcase
			maze_oe = 1;
			next_state = `check_right + 1;
		end
		
		`check_right + 'd1: begin		//daca deplasarea la dreapta este posibila, se modifica directia
			if(maze_in == 1) begin
				row = last_row;
				col = last_col;
				next_state = `check_forward;
			end
			else begin
				case(dir)
					`north: begin
						dir = `east;
					end
					
					`south: begin
						dir = `west;
					end
					`east: begin
						dir = `south;
					end
					`west: begin
						dir = `north;
					end
				endcase
				maze_we = 1;
				next_state = `final_check;
			end
		end
		
		`check_forward: begin		//se verifica posibilitatea deplasarii inainte
			last_row = row;
			last_col = col;
			case(dir)
				`north: begin
					row = row - 1;
				end
				
				`south: begin
					row = row + 1;
				end

				`east: begin
					col = col + 1;
				end
			
				`west: begin
					col = col - 1;
				end
			endcase
			maze_oe = 1;
			next_state = `check_forward + 'd1;
		end
		
		`check_forward + 'd1: begin		//daca deplasarea nu este posibila, se schimba directia
			if(maze_in == 1) begin
				row = last_row;
				col = last_col;
				case(dir)
					`north: begin
						dir = `west;
					end
					
					`south: begin
						dir = `east;
					end
					`east: begin
						dir = `north;
					end
					`west: begin
						dir = `south;
					end
				endcase
			end
			else begin
				maze_we = 1;
			end
			next_state = `final_check;
		end
		
		`final_check: begin		//se verifica atingerea sfarsitului labirintului
			if(maze_in == 0 &&(row == 0 || row == 63 || col == 0 || col == 63)) begin
				done = 1;
				maze_we = 1;
			end
			else begin
				next_state = `check_right;
			end
		end
	endcase
end
endmodule
