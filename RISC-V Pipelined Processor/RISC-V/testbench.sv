module tb();
  reg clk, reset;
  wire [63:0] element1;
  wire [63:0] element2;
  wire [63:0] element3;
  wire [63:0] element4;
  wire [63:0] element5;
  wire [63:0] element6;
  wire [63:0] element7;
  wire [63:0] element8;
  wire stall;
  wire flush;
  
  RISC_V_Processor r1
  (
    .clk(clk),
    .reset(reset),
    .element1(element1),
    .element2(element2),
    .element3(element3),
    .element4(element4),
    .element5(element5),
    .element6(element6),
    .element7(element7),
    .element8(element8),
    .stall(stall),
    .flush(flush)
  );
  
  initial 
    begin
      
      $dumpfile("dump.vcd");
      $dumpvars(1, tb);
		
      clk = 1'b0;
      reset = 1'b1;
      
      #7 
      reset = 1'b0;
      #7000
      $finish;
      
    end
  
  always
    begin
      #5
      clk = ~clk;
    end
endmodule
