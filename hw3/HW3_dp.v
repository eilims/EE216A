module HW3_dp
(
	i_clk,
	i_rst_n,
	i_data,
	o_find
);

input i_clk;
input i_rst_n;
input i_data;
output o_find;

reg isPatternMatch;
reg[2:0] state;

assign o_find = isPatternMatch;

always @(posedge i_clk)
begin
	isPatternMatch = (state == 6 && i_data == 1'b1) ? 1'b1 : 1'b0;
	case(state)
		0: state = (i_data == 1'b1) ? 1 : 0;
		1: state = (i_data == 1'b1) ? 2 : 0;
		2: state = (i_data == 1'b1) ? 2 : 3;
		3: state = (i_data == 1'b1) ? 4 : 0;
		4: state = (i_data == 1'b1) ? 5 : 0;
		5: state = (i_data == 1'b1) ? 2 : 6;
		6: state = (i_data == 1'b1) ? 7 : 0;
		7: state = (i_data == 1'b1) ? 5 : 0;
		default: state = 0;
	endcase
end

always @(negedge i_rst_n)
begin
	isPatternMatch = 0;
	state = 0;
end

endmodule