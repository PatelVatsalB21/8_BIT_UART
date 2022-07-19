// CLKS_PER_BIT = (Frequency of Clock)/(Frequency of UART)
// Example: 25 MHz Clock, 115200 baud UART
// (25000000)/(115200) = 217
 
module UART_TX 
  #(parameter CLKS_PER_BIT = 217)
  (
   input       Clock,
   input       TX_Send,
   input [7:0] Input_Byte, 
   output      Main_TX_Active,
   output reg  Output_Serial,
   );
 
  parameter IDLE         = 3'b000;
  parameter START_BIT = 3'b001;
  parameter DATA_BIT = 3'b010;
  parameter STOP_BIT  = 3'b011;
  
  reg [2:0] present_state = 0;
  reg [7:0] Clock_Count = 0;
  reg [2:0] Data_Bit_Index   = 0;
  reg [7:0] Data_Out    = 0;
  reg       TX_Active   = 0;
    
  always @(posedge Clock)
  begin
      
    case (present_state)
      IDLE :
        begin
          Output_Serial   <= 1'b1;
          Clock_Count <= 0;
          Data_Bit_Index   <= 0;
          
          if (TX_Send == 1'b1)
          begin
            TX_Active <= 1'b1;
            Data_Out   <= Input_Byte;
            present_state   <= START_BIT;
          end
          else
            present_state <= IDLE;
        end
      
      START_BIT :
        begin
          Output_Serial <= 1'b0;
          
          if (Clock_Count < CLKS_PER_BIT-1)
          begin
            Clock_Count <= Clock_Count + 1;
            present_state     <= START_BIT;
          end
          else
          begin
            Clock_Count <= 0;
            present_state     <= DATA_BIT;
          end
        end
      
      DATA_BIT :
        begin
          Output_Serial <= Data_Out[Data_Bit_Index];
          
          if (Clock_Count < CLKS_PER_BIT-1)
          begin
            Clock_Count <= Clock_Count + 1;
            present_state     <= DATA_BIT;
          end
          else
          begin
            Clock_Count <= 0;
            
            if (Data_Bit_Index < 7)
            begin
              Data_Bit_Index <= Data_Bit_Index + 1;
              present_state   <= DATA_BIT;
            end
            else
            begin
              Data_Bit_Index <= 0;
              present_state   <= STOP_BIT;
            end
          end 
        end
      
      STOP_BIT :
        begin
          Output_Serial <= 1'b1;
      
          if (Clock_Count < CLKS_PER_BIT-1)
          begin
            Clock_Count <= Clock_Count + 1;
            present_state     <= STOP_BIT;
          end
          else
          begin
            Clock_Count <= 0;
            present_state     <= IDLE;
            TX_Active   <= 1'b0;
          end 
        end
      
      
      default :
        present_state <= IDLE;
      
    endcase
  end
  
  assign Main_TX_Active = TX_Active;
  
endmodule