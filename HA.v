module HA (a,b,sum,Cout);
input a,b;
output wire sum,Cout;

assign sum = a^b;
assign Cout = a&b;

endmodule