//full adder module
module FA (a,b,Cin,sum,Cout);
input  a,b,Cin;
output wire sum,Cout;

assign sum = a^b^Cin;
assign Cout = (a&b) + (a&Cin) + (b&Cin);

endmodule