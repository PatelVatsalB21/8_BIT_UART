// CLKS_PER_BIT = (Frequency of Clock)/(Frequency of UART)
// Example: 25 MHz Clock, 115200 baud UART
// (25000000)/(115200) = 217
 
module UART_RX
  #(parameter CLKS_PER_BIT = 217)
  (
   input        Clock,
   input        Input_Serial,
   output       Main_RX_Receive,
    output [7:0] Main_Data_Out
   );
   
  parameter IDLE         = 3'b000;
  parameter START_BIT = 3'b001;
  parameter DATA_BIT = 3'b010;
  parameter STOP_BIT  = 3'b011;
  
  reg [7:0] Clock_Count = 0;
  reg [2:0] Data_Bit_Index   = 0;
  reg [7:0] Data_Out     = 0;
  reg       RX_Receive       = 0;
  reg [2:0] Present_State     = 0;
  
  always @(posedge Clock)
  begin
      
    case (Present_State)
      IDLE :
        begin
          RX_Receive       <= 1'b0;
          Clock_Count <= 0;
          Data_Bit_Index   <= 0;
          
          if (Input_Serial == 1'b0)
            Present_State <= START_BIT;
          else
            Present_State <= IDLE;
        end
     
      START_BIT :
        begin
          if (Clock_Count == (CLKS_PER_BIT-1)/2)
          begin
            if (Input_Serial == 1'b0)
            begin
              Clock_Count <= 0;
              Present_State     <= DATA_BIT;
            end
            else
              Present_State <= IDLE;
          end
          else
          begin
            Clock_Count <= Clock_Count + 1;
            Present_State     <= START_BIT;
          end
        end
      
      DATA_BIT :
        begin
          if (Clock_Count < CLKS_PER_BIT-1)
          begin
            Clock_Count <= Clock_Count + 1;
            Present_State     <= DATA_BIT;
          end
          else
          begin
            Clock_Count          <= 0;
            Data_Out[Data_Bit_Index] <= Input_Serial;
            
            if (Data_Bit_Index < 7)
            begin
              Data_Bit_Index <= Data_Bit_Index + 1;
              Present_State   <= DATA_BIT;
            end
            else
            begin
              Data_Bit_Index <= 0;
              Present_State   <= STOP_BIT;
            end
          end
        end
      
      STOP_BIT :
        begin
          if (Clock_Count < CLKS_PER_BIT-1)
          begin
            Clock_Count <= Clock_Count + 1;
     	    Present_State     <= STOP_BIT;
          end
          else
          begin
       	    RX_Receive       <= 1'b1;
            Clock_Count <= 0;
            Present_State     <= IDLE;
          end
        end
      
      default :
        Present_State <= IDLE;
      
    endcase
  end    
  
  assign Main_RX_Receive = RX_Receive;
  assign Main_Data_Out = Data_Out;
  
endmodule