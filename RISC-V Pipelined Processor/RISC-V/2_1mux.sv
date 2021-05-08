
module twox1Mux(
  input [63:0] A,B,
  input SEL,
  output reg[63:0] Y);
  always @ (A or B or SEL)
    begin 
      if (SEL==0)
        Y=A;
      else
        Y=B;
    end
endmodule