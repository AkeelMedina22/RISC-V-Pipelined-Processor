`include "2_1mux.sv"
`include "imm_data_extractor.sv"
`include "instruction_parser.sv"
`include "reg_file.sv"
`include "alu_64bit.sv"
`include "data_memory.sv"
`include "instruction_memory.sv"
`include "program_counter.sv"
`include "adder.sv"
`include "control_unit.sv"
`include "alu_control.sv"
`include "pipeline_flush.sv"
`include "hazard_detection_unit.sv"
`include "ThreebyOneMux.sv"
`include "IFID.sv"
`include "IDEX.sv"
`include "EXMEM.sv"
`include "MEMWB.sv"
`include "branching_unit.sv"
`include "ForwardingUnit.sv"

module RISC_V_Processor(
  input clk,
  input reset,
  input wire[63:0] element1,
  input wire[63:0] element2,
  input wire[63:0] element3,
  input wire[63:0] element4,
  input wire[63:0] element5,
  input wire[63:0] element6,
  input wire[63:0] element7,
  input wire[63:0] element8,
  input stall, flush);
  
  // CU wires
  wire branch;
  wire memread;
  wire memtoreg;
  wire memwrite;
  wire ALUsrc;
  wire regwrite;
  wire [1:0] ALUop;
  
  //regfile
  wire regwrite_memwb_out;
  wire [63:0] readdata1, readdata2;
  wire [63:0] r8, r19, r20, r21, r22;
  wire [63:0] write_data;
  
   //PC wires
  wire [63:0] pc_in;
  wire [63:0] pc_out;
  
  // adders
  wire [63:0] adderout1;
  wire [63:0] adderout2;
  
  // inst mem wire
  wire [31:0] instruction;
  wire[31:0] inst_ifid_out;
  
  //Parser
  wire [6:0] opcode;
  wire [4:0] rd, rs1, rs2;
  wire [2:0] funct3;
  wire [6:0] funct7;
  
  
  // Immediate Data Extractor
  wire [63:0] imm_data;
  
  //ifid wires
 
  wire [63:0] random;
  
  //id ex wires
 
  wire [63:0] a1;
  wire [4:0] RS1;
  wire [4:0] RS2;
  wire [4:0] RD;
  wire [63:0] d, M1, M2;
  wire Branch;
  wire Memread;
  wire Memtoreg;
  wire Memwrite;
  wire Regwrite;
  wire Alusrc;
  wire [1:0] aluop;
  wire [3:0] funct4_out;
  
  //mux wires
  wire [63:0] threeby1_out1;
  wire[63:0] threeby1_out2;
  wire[63:0]  alu_64_b;
  
   //ex mem wires
  wire [63:0] write_Data;
  wire [63:0] exmem_out_adder;
  wire exmem_out_zero;
  wire [63:0] exmem_out_result;
  wire [4:0] exmemrd;
  wire BRANCH,MEMREAD,MEMTOREG,MEMEWRITE,REGWRITE;   
  
   // ALU 64
  wire [63:0] AluResult;
  wire zero;
  
  
  // ALU Control
  wire [3:0] operation;
  
  // Data Memory
  wire [63:0] readdata;
 
  
  
  
  //memwb wires
  wire[63:0] muxin1,muxin2;
  wire [4:0] memwbrd;
  wire memwb_memtoreg;
  wire memwb_regwrite;
  
  //forwarding unit wires
  wire [1:0] forwardA;
  wire [1:0] forwardB;
  
  // Branch
  wire addermuxselect;
  wire branch_final;
  
  
  pipeline_flush p_flush
  (
    .branch(branch_final & BRANCH),
    .flush(flush)
  );
  
  
  hazard_detection_unit hu
  (
    .Memread(Memread),
    .inst(inst_ifid_out),
    .Rd(RD),
    .stall(stall)
  );

  
  program_counter pc 
  (
    .PC_in(pc_in),
    .stall(stall),
    .clk(clk),
    .reset(reset),
    .PC_out(pc_out)
  );
  
  instruction_memory im
  (
    .inst_address(pc_out),
    .instruction(instruction)
  );
  
  
  adder adder1
  (
    .p(pc_out),
    .q(64'd4),
    .out(adderout1)
  );
  
   IFID i1 
  (
    .clk(clk),
    .reset(reset),
    .IFIDWrite(stall),
    .instruction(instruction),
    .A(pc_out),
    .inst(inst_ifid_out),
    .a_out(random),
    .flush(flush)
  );
  
  Parser ip
  (
    .instruction(inst_ifid_out),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7)
  );
  
  CU cu
  (
    .opcode(opcode),
    .branch(branch),
    .memread(memread),
    .memtoreg(memtoreg),
    .memwrite(memwrite),
    .aluSrc(ALUsrc),
    .regwrite(regwrite),
    .Aluop(ALUop),
    .stall(stall)
  );
  
  data_extractor immextr
  (
    .instruction(inst_ifid_out),
    .imm_data(imm_data)
  );
  
  
  registerFile regfile 
  (
    .clk(clk),
    .reset(reset),
    .rs1(rs1),
    .rs2(rs2),
    .rd(memwbrd),
    .writedata(write_data),
    .reg_write(memwb_regwrite),
    .readdata1(readdata1),
    .readdata2(readdata2),
    .r8(r8),
    .r19(r19),
    .r20(r20),
    .r21(r21),
    .r22(r22)
  );
  
  IDEX i2
  (
    .clk(clk),
    .flush(flush),
    .reset(reset),
    .funct4_in({inst_ifid_out[30],inst_ifid_out[14:12]}),
    .A_in(random),
    .readdata1_in(readdata1),
    .readdata2_in(readdata2),
    .imm_data_in(imm_data),
    .rs1_in(rs1),.rs2_in(rs2),.rd_in(rd),
    .branch_in(branch),.memread_in(memread),.memtoreg_in(memtoreg),
    .memwrite_in(memwrite),.aluSrc_in(ALUsrc),.regwrite_in(regwrite),.Aluop_in(ALUop),
    .a(a1),.rs1(RS1),.rs2(RS2),.rd(RD),.imm_data(d),.readdata1(M1),.readdata2(M2),
    .funct4_out(funct4_out),.Branch(Branch),.Memread(Memread),.Memtoreg(Memtoreg),
    .Memwrite(Memwrite),.Regwrite(Regwrite),.Alusrc(Alusrc),.aluop(aluop)
  );
  adder adder2
  (
    .p(a1),
    .q(d << 1),
    .out(adderout2)
  );
  
  
  ThreebyOneMux m1
  (
    .a(M1),.b(write_data),.c(exmem_out_result),.sel(forwardA),.out(threeby1_out1)
  );
  
  ThreebyOneMux m2
  (
    .a(M2),.b(write_data),.c(exmem_out_result),.sel(forwardB),.out(threeby1_out2)
  );
  
  twox1Mux mux1
  (
    .A(threeby1_out2),.B(d),.SEL(Alusrc),.Y(alu_64_b)
  );
  
  Alu64 alu
  (
    .a(threeby1_out1),
    .b(alu_64_b),
    .ALuop(operation),
    .Result(AluResult),
    .zero(zero)
  );
  
   alu_control ac
  (
    .Aluop(aluop),
    .funct(funct4_out),
    .operation(operation)
  );
  
 
  
  EXMEM i3
  (
    .clk(clk),.reset(reset),.Adder_out(adderout2),.Result_in_alu(AluResult),.Zero_in(zero),.flush(flush),
    .writedata_in(threeby1_out2),.Rd_in(RD), .addermuxselect_in(addermuxselect),
    .branch_in(Branch),.memread_in(Memread),.memtoreg_in(Memtoreg),.memwrite_in(Memwrite),.regwrite_in(Regwrite),
    .Adderout( exmem_out_adder),.zero(exmem_out_zero),.result_out_alu(exmem_out_result),.writedata_out(write_Data),
    .rd(exmemrd),.Branch(BRANCH),.Memread(MEMREAD),.Memtoreg(MEMTOREG),.Memwrite(MEMEWRITE),.Regwrite(REGWRITE), .addermuxselect(branch_final)
  );
    
  data_memory datamem
  (
    .write_data(write_Data),
    .address(exmem_out_result),
    .memorywrite(MEMEWRITE),
    .clk(clk),
    .memoryread(MEMREAD),
    .read_data(readdata),
    .element1(element1),
    .element2(element2),
    .element3(element3),
    .element4(element4),
    .element5(element5),
    .element6(element6),
    .element7(element7),
    .element8(element8)
  );
  
  
  twox1Mux mux2
  (
    .A(adderout1),.B(exmem_out_adder),.SEL(BRANCH & branch_final),.Y(pc_in) // ??
  );

 
  MEMWB i4
  
  (
    .clk(clk),.reset(reset),.read_data_in(readdata),
    .result_alu_in(exmem_out_result),.Rd_in(exmemrd),.memtoreg_in(MEMTOREG),.regwrite_in(REGWRITE),
    .readdata(muxin1),.result_alu_out(muxin2),.rd(memwbrd),.Memtoreg(memwb_memtoreg),.Regwrite(memwb_regwrite)
  );
  
   twox1Mux mux3
  (
    .A(muxin2),.B(muxin1),.SEL(memwb_memtoreg),.Y(write_data)
  );
  
  
   ForwardingUnit f1
  (
    .RS_1(RS1),.RS_2(RS2),.rdMem(exmemrd),
    .rdWb(memwbrd),.regWrite_Wb(memwb_regwrite),
    .regWrite_Mem(REGWRITE),
    .Forward_A(forwardA),.Forward_B(forwardB)
  );
  
  
  branching_unit branc
  (
    .funct3(funct4_out[2:0]),.readData1(M1),.b(alu_64_b),.addermuxselect(addermuxselect)
  );

        
endmodule 