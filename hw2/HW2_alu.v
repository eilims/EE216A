////////////////////////////////////////////////////////////////
//
// Module: HW2_alu.v
// Author: EEM216A Student
//         ee216a@gmail.com
//
// Description:
//      ALU for HW2
//
// Parameters:
//      (List parameters and their descriptions here)
//
// Inputs:
//      (List inputs and their descriptions here)
//
// Outputs:
//      (List outputs and their descriptions here)
//
////////////////////////////////////////////////////////////////

module HW2_alu (
    clk_p_i,
    reset_n_i,
    data_a_i,
    data_b_i,
    inst_i,
    data_o
    );

////////////////////////////////////////////////////////////////
//  Inputs & Outputs
input           clk_p_i;
input           reset_n_i;
input   [7:0]   data_a_i;
input   [7:0]   data_b_i;
input   [2:0]   inst_i;
output  [15:0]  data_o;

////////////////////////////////////////////////////////////////
//  reg & wire declarations
// Output data register
reg     [15 :0]   ALU_out_inst;

// Input instruction register
reg     [2 :0]   Inst_o_r;

// Input data registers
reg     [7:0]   Data_A_o_r;
reg     [7:0]   Data_B_o_r;

// Combinational Logic
assign data_o = ALU_out_inst;

// The output MUX
always @(posedge clk_p_i) begin
    ALU_out_inst = 0;
    case(Inst_o_r)
        3'b000:     ALU_out_inst = Data_A_o_r +  Data_B_o_r;
        3'b001:     ALU_out_inst = Data_B_o_r - Data_A_o_r;
        3'b010:     ALU_out_inst = Data_A_o_r * Data_B_o_r;
        3'b011:     ALU_out_inst = Data_A_o_r & Data_B_o_r;
        3'b100:     ALU_out_inst = Data_A_o_r ^ Data_B_o_r;
        3'b101:     ALU_out_inst = (Data_A_o_r[7] ? {1'b0,~Data_A_o_r} + 1: Data_A_o_r); // If the 8th bit is 1 we consider the value negative. Invert the value and add one to get the positive complement.
        3'b110:     ALU_out_inst = (Data_B_o_r - Data_A_o_r) << 2; // Shifting to the left by 2 is the same as multiply by 4
        3'b111:     ALU_out_inst = 0;
        default:    ALU_out_inst = 0;
    endcase
end

////////////////////////////////////////////////////////////////
//  Registers
always @(posedge clk_p_i or negedge reset_n_i) begin
    if (reset_n_i == 1'b0) begin
        Data_A_o_r  <= 0;
        Data_B_o_r  <= 0;
        ALU_out_inst <= 0;
        Inst_o_r    <= 3'b111;
    end
    else begin
        Data_A_o_r  <= data_a_i;
        Data_B_o_r  <= data_b_i;
        Inst_o_r    <= inst_i;
    end
end

endmodule
