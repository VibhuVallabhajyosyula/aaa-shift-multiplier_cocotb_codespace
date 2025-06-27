
module adder(a,b,sign,c);
  parameter N = 5, M = 6;
  input [N+M:M] a,b;
  input sign;
  output [N+M:M] c;
  
  assign c = a + (({(N+1){sign}}^(b)) + sign);
endmodule

module shift(a,b);
  parameter N = 5, M = 6;
  input [N+M:0] a;
  output [N+M:0] b;
  
  assign b = {a[N+M],a[N+M:1]};
endmodule

module asm(clk,rst,A,B,acc,done);
  parameter N = 5, M = 6;
  input clk, rst;
  input [N-1:0] A;
  input [M-1:0] B;
  output reg [N+M:0] acc;
  output reg done;
  
  reg [M-1:0] i;
  reg [N+M:0] temp;
  reg sign;
  reg [N:0] signed_a;
  
  wire [N:0] c0;
  wire [N+M:0] c3;
  
  assign signed_a = {A[N-1], A};
  adder a0(.a(acc[N+M:M]), .b(signed_a), .sign(sign), .c(c0));
  shift s1(.a(temp[N+M:0]), .b(c3));
  
  always @(*) begin
    temp = acc;
    if (B[i] == 1) begin
      sign = (i == M-1);
      temp[N+M:M] = c0;
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      i <= 0;
      acc <= 0;
      done <= 0;
    end else begin
      acc <= c3;
      if (i == M-1)
        done <= 1;
      else begin
        i <= i + 1;
        done <= 0;
      end
    end
  end
endmodule
