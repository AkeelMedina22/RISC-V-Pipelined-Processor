module IDEX(
  input clk,reset,
  input [3:0] funct4_in,//funct4 of instruction from instruction memory
  input [63:0] A_in,//adder input, ouput of IFID carried forward
  input [63:0] readdata1_in, //from regwrite
  input [63:0] readdata2_in,//from regwrite
  input [63:0] imm_data_in,//from data extractor
  input [4:0] rs1_in,//from instruction parser
  input [4:0] rs2_in, //from instruction parser
  input [4:0] rd_in, //from instruction parser
  input branch_in,memread_in,memtoreg_in,memwrite_in,aluSrc_in,regwrite_in, //from control unit
  input [1:0] Aluop_in,
  input flush, 
  output reg [63:0] a,
  output reg [4:0] rs1,
  output reg [4:0] rs2,
  output reg [4:0] rd,
  output reg [63:0] imm_data,
  output reg [63:0] readdata1, //2bit mux
  output reg [63:0] readdata2, //2bit mux
  output reg [3:0] funct4_out,
  output reg Branch,Memread,Memtoreg, Memwrite, Regwrite,Alusrc, 
  output reg [1:0] aluop
);
  
  always @ (posedge clk)
    begin
      if (reset == 1'b1 || flush == 1'b1)
        begin
          a = 64'b0;
          rs1 = 5'b0;
          rs2 = 5'b0;
          rd = 5'b0;
          imm_data = 64'b0;
          readdata1 = 64'b0;
          readdata2 = 64'b0;
          funct4_out = 4'b0;
          Branch = 1'b0;
          Memread = 1'b0;
          Memtoreg =1'b0;
          Memwrite = 1'b0;
          Regwrite = 1'b0;
          Alusrc = 1'b0;
          aluop = 2'b0;
        end
      else
        begin
          a = A_in;
          rs1 = rs1_in;
          rs2 = rs2_in;
          rd = rd_in;
          imm_data = imm_data_in;
          readdata1 = readdata1_in;
          readdata2 = readdata2_in;
          funct4_out = funct4_in; //when connecting in top module Funct4 is wire containing this section of 31 bit instruction {instruction[30],instruction[14:12]}
          Branch = branch_in;
          Memread = memread_in;
          Memtoreg = memtoreg_in;
          Memwrite = memwrite_in;
          Regwrite = regwrite_in;
          Alusrc = aluSrc_in;
          aluop = Aluop_in;
          
        end
    end
endmodule