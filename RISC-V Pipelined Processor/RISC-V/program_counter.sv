module program_counter(
  input [63:0] PC_in,
  input clk,
  input reset,
  input stall, 
  output reg [63:0] PC_out);
  
  always @(posedge clk or posedge reset)
    begin
      if (reset==1'b1)
        begin        
          PC_out = 64'd0;
        end
      else if (stall == 1'b0) 
        begin 
          PC_out = PC_in;
        end
    end
endmodule

