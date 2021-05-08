module hazard_detection_unit
  (
    input Memread,
    input [31:0] inst,
    input [4:0] Rd,
    output reg stall
  );
  
  initial
    begin
      stall = 1'b0;
    end
  
  always @(*)
    begin
      if (Memread == 1'b1 && ((Rd == inst[19:15]) || (Rd == inst[24:20])))
        stall = 1'b1;
      else
        stall = 1'b0;
    end
endmodule