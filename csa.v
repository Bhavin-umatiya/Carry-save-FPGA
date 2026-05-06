module csa #(parameter WIDTH = 64) (
    input  [WIDTH-1:0] A,
    input  [WIDTH-1:0] B,
    input  [WIDTH-1:0] C,
    output [WIDTH:0]   Final_Sum
);

    wire [WIDTH-1:0] S;
    wire [WIDTH-1:0] C_out;

    // Stage 1: Carry Save Adders (Parallel Full Adders)
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : fa_stage
            Full_Adder FA (
                .A(A[i]), 
                .B(B[i]), 
                .Cin(C[i]), 
                .Sum(S[i]), 
                .Carry(C_out[i])
            );
        end
    endgenerate

    // Stage 2: Shift Carry Left
    wire [WIDTH:0] C_shifted;
    assign C_shifted = {C_out, 1'b0};

    // Stage 3: Final Addition using RCA (or CPA in synthesis)
    Ripple_Carry_Adder #(.WIDTH(WIDTH+1)) RCA (
        .X({1'b0, S}), 
        .Y(C_shifted), 
        .Sum(Final_Sum)
    );

endmodule

// Full Adder Submodule
module Full_Adder (
    input  A, B, Cin,
    output Sum, Carry
);
    assign Sum = A ^ B ^ Cin;
    assign Carry = (A & B) | (B & Cin) | (Cin & A);
endmodule

// Parameterized Ripple Carry Adder
module Ripple_Carry_Adder #(parameter WIDTH = 65) (
    input  [WIDTH-1:0] X, Y,
    output [WIDTH-1:0] Sum
);
    assign Sum = X + Y; // Synthesizes to optimized CPA on FPGA
endmodule
