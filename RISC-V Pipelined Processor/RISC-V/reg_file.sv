module registerFile(
  input clk,
  input reset,
  input [4:0] rs1,
  input [4:0] rs2,
  input [4:0] rd,
  input [63:0] writedata,
  input reg_write,
  output reg [63:0] readdata1,
  output reg[63:0] readdata2,
  output [63:0] r8,
  output [63:0] r19,
  output [63:0] r20,
  output [63:0] r21,
  output [63:0] r22
);
  integer i;
  reg [63:0] registers [31:0];
  initial
    begin
      registers[0] = 64'd0;
      registers[1] = 64'd0;
      registers[2] = 64'd0;
      registers[3] = 64'd0;
      registers[4] = 64'd0;
      registers[5] = 64'd0;
      registers[6] = 64'd0;
      registers[7] = 64'd0;
      registers[8] = 64'd0;
      registers[9] = 64'd0;
      registers[10] = 64'd0;
      registers[11] = 64'd8;
      registers[12] = 64'd0;
      registers[13] = 64'd0;
      registers[14] = 64'd0;
      registers[15] = 64'd0;
      registers[16] = 64'd0;
      registers[17] = 64'd0;
      registers[18] = 64'd0;
      registers[19] = 64'd0;
      registers[20] = 64'd0;
      registers[21] = 64'd0;
      registers[22] = 64'd0;
      registers[23] = 64'd0;
      registers[24] = 64'd0;
      registers[25] = 64'd0;
      registers[26] = 64'd0;
      registers[27] = 64'd0;
      registers[28] = 64'd0;
      registers[29] = 64'd0;
      registers[30] = 64'd0;
      registers[31] = 64'd0;
    end
  assign r8 = registers[8];
  assign r19 = registers[19];
  assign r20 = registers[20];
  assign r21 = registers[26];
  assign r22 = registers[27];
 
  always @ (*)
    begin
      if (reset == 1'b1)
        begin
          readdata1 = 64'd0;
          readdata2 = 64'd0;
        end
      else
        begin
          readdata1 = registers[rs1];
          readdata2 = registers[rs2];
        end
    end
  always@(negedge clk)
    begin
      if (reg_write == 1)
        registers[rd] = writedata;
    end
endmodule