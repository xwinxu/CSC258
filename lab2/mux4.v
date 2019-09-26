module mux(LEDR, SW);
    input [9:0] SW;
    output [9:0] LEDR;

    wire ConnectUV;
    wire ConnectWX;

    mux2to1 u0(
        .x(SW[0]),
	.y(SW[1]),
	.s(SW[9]),
	.m(ConnectUV)
        );


    mux2to1 u1(
        .x(SW[2]),
	.y(SW[3]),
	.s(SW[9]),
	.m(ConnectWX)
        );


    mux2to1 u2(
        .x(ConnectUV),
	.y(ConnectWX),
	.s(SW[8]),
	.m(LEDR[0])
        );
endmodule

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output

    assign m = s & y | ~s & x;

endmodule
