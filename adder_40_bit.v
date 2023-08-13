module and_gate
(
    input  A, B,
    output Aout
);

    assign Aout = A & B;
    
endmodule

module gLogic
(
    input A, B, C,
    output Gout
);

    assign Gout = A | (B & C);
endmodule

module PnG_Genrtn
#(
    parameter d_width = 40
)
(
    input  [d_width-1:0]   A, B,
    output [d_width-1:0]   P1, G1,
    output [d_width/2-1:0] P2, G2,
    output [d_width/4-1:0] P3, G3,
    output [d_width/8-1:0] P4, G4,
    output [1:0]           P5, G5,
	 output                 P6, G6 
);

    genvar i;
    generate
        for (i = 0; i < d_width; i = i + 1) begin :LOOP_P1G1
            xor_gate XOR1(.A(A[i]), .B(B[i]), .Xout(P1[i]));
            and_gate AND1(.A(A[i]), .B(B[i]), .Aout(G1[i]));
        end
    endgenerate
            
    generate
        for (i = 0; i < d_width/2; i = i + 1) begin :LOOP_P2G2
            and_gate AND2(.A(P1[2*i]),   .B(P1[2*i+1]), .Aout(P2[i]));
            gLogic   GLC1(.A(G1[2*i+1]), .B(P1[2*i+1]), .C(G1[2*i]), .Gout(G2[i]));
        end
    endgenerate

    generate
        for (i = 0; i < d_width/4; i = i + 1) begin :LOOP_P3G3
            and_gate AND3(.A(P2[2*i]),   .B(P2[2*i+1]), .Aout(P3[i]));
            gLogic   GLC2(.A(G2[2*i+1]), .B(P2[2*i+1]), .C(G2[2*i]), .Gout(G3[i]));
        end
    endgenerate

    generate
        for (i = 0; i < d_width/8; i = i + 1) begin :LOOP_P4G4
            and_gate AND4(.A(P3[2*i]),   .B(P3[2*i+1]), .Aout(P4[i]));
            gLogic   GLC3(.A(G3[2*i+1]), .B(P3[2*i+1]), .C(G3[2*i]), .Gout(G4[i]));
        end
    endgenerate
	 
	 generate
        for (i = 0; i < 2; i = i + 1) begin :LOOP_P5G5
            and_gate AND5(.A(P4[2*i]),   .B(P4[2*i+1]), .Aout(P5[i]));
            gLogic   GLC4(.A(G4[2*i+1]), .B(P4[2*i+1]), .C(G4[2*i]), .Gout(G5[i]));
        end
    endgenerate

    and_gate AND6(.A(P5[0]), .B(P5[1]), .Aout(P6));
    gLogic   GLC5(.A(G5[1]), .B(P5[1]), .C(G5[0]), .Gout(G6));
endmodule

module xor_gate 
(
	input A, B,
	output Xout
);
	
	assign Xout = A ^ B;
	
endmodule


module adder_40_bit
#(
    parameter d_width = 40
)
(
    input  [d_width-1:0] A, B,
    input                Cin,
    output [d_width-1:0] Sout,
    output               Cout
);

    wire [d_width:1]     Co;
    wire [d_width-1:0]   P1, G1;
    wire [d_width/2-1:0] P2, G2;
    wire [d_width/4-1:0] P3, G3;
    wire [d_width/8-1:0] P4, G4;
    wire  [1:0]          P5, G5;
	 wire                 P6, G6;
	 
    genvar i;

    PnG_Genrtn #(d_width) PnG1 (.A(A),   .B(B),   .P1(P1), .G1(G1), .P2(P2), .G2(G2), .P3(P3), .G3(G3),
                                .P4(P4), .G4(G4), .P5(P5), .G5(G5), .P6(P6), .G6(G6) );

    gLogic GLC0 (.A(G1[0]), .B(P1[0]), .C(Cin), .Gout(Co[1]));
    gLogic GLC1 (.A(G2[0]), .B(P2[0]), .C(Cin), .Gout(Co[2]));
    gLogic GLC2 (.A(G3[0]), .B(P3[0]), .C(Cin), .Gout(Co[4]));
    gLogic GLC3 (.A(G4[0]), .B(P4[0]), .C(Cin), .Gout(Co[8]));
    gLogic GLC4 (.A(G5[0]), .B(P5[0]), .C(Cin), .Gout(Co[16]));
	 gLogic GLC5 (.A(G6),    .B(P6),    .C(Cin), .Gout(Co[32]));
	 
	 generate
        for (i = 1; i < 3; i = i + 1) begin :LOOP1
           gLogic GLC5 (.A(G4[2*i]), .B(P4[2*i]), .C(Co[16*i]), .Gout(Co[16*i+8]));  
        end
    endgenerate

    generate
        for (i = 1; i < 5; i = i + 1) begin :LOOP2
           gLogic GLC6 (.A(G3[2*i]), .B(P3[2*i]), .C(Co[8*i]), .Gout(Co[8*i+4]));  
        end
    endgenerate

    generate
        for (i = 1; i < 10; i = i + 1) begin :LOOP3
           gLogic GLC7 (.A(G2[2*i]), .B(P2[2*i]), .C(Co[4*i]), .Gout(Co[4*i+2])); // 6, 10, 14, 18
        end                                                                       //22, 26, 30, 34
    endgenerate

    generate
        for (i = 1; i < 20; i = i + 1) begin :LOOP4
           gLogic GLC8 (.A(G1[2*i]), .B(P1[2*i]), .C(Co[2*i]), .Gout(Co[2*i+1])); // 3, 5, 7, 9, 11, 13 15, 17, 19
        end                                                                       //21,23,25,27,29,31,33,35,37,39
    endgenerate

    xor_gate XOR1(.A(P1[0]), .B(Cin), .Xout(Sout[0]));
    
	 generate
        for (i = 1; i < d_width; i = i + 1) begin :LOOP_P4G4
            xor_gate XOR2(.A(P1[i]), .B(Co[i]), .Xout(Sout[i]));
        end
    endgenerate

    assign Cout = Co[40];
endmodule