module ForwardingUnit
  (
    input [4:0] RS_1, //ID/EX.RegisterRs1
    input [4:0] RS_2, //ID/EX.RegisterRs2
    input [4:0] rdMem, //EX/MEM.Register Rd
    input [4:0] rdWb, //MEM/WB.RegisterRd
    
    input regWrite_Wb, //MEM/WB.RegWrite
    input regWrite_Mem, // EX/MEM.RegWrite
    output reg [1:0] Forward_A,
    output reg [1:0] Forward_B
 );
  
  always @(*)
    begin
    	if ( (rdMem == RS_1) & (regWrite_Mem != 0 & rdMem !=0))
          begin
          	Forward_A = 2'b10;
          end
      	else
          begin 
            // Not condition for MEM hazard 
            if ((rdWb== RS_1) & (regWrite_Wb != 0 & rdWb != 0) & ~((rdMem == RS_1) &(regWrite_Mem != 0 & rdMem !=0)  )  )
              begin
                Forward_A = 2'b01;
              end
            else
              begin
                Forward_A = 2'b00;
              end
          end
      
        if ( (rdMem == RS_2) & (regWrite_Mem != 0 & rdMem !=0) )
          begin
            Forward_B = 2'b10;
          end
        else
          begin
            // Not condition for MEM Hazard 
            if ( (rdWb == RS_2) & (regWrite_Wb != 0 & rdWb != 0) &  ~((regWrite_Mem != 0 & rdMem !=0 ) & (rdMem == RS_2) ) )
              begin
                Forward_B = 2'b01;
              end
            else
              begin
                Forward_B = 2'b00;
              end
          end
    end
endmodule