`timescale 1ns/1ns

`include "UART_TX.v"
`include "UART_RX.v"

module UART_TB ();
  // 25000000 / 115200 = 217 Clocks Per Bit.
  parameter TB_CLOCK_PERIOD_NS = 40;
  parameter TB_CLKS_PER_BIT    = 217;
  parameter TB_BIT_PERIOD      = 8600;
  
  reg TB_Clock = 0;
  reg TB_TX_Send = 0;
  wire TB_TX_Active, TB_RX_Input_Serial;
  wire TB_TX_Output_Serial;
  reg [7:0] TB_TX_Input_Byte = 0;
  wire [7:0] TB_RX_Input_Byte;

  UART_RX #(.CLKS_PER_BIT(TB_CLKS_PER_BIT)) UART_RX_Inst
  	 (.Clock(TB_Clock),
     .Input_Serial(TB_RX_Input_Serial),
      .Main_RX_Receive(TB_RX_Receive),
     .Main_Data_In(TB_RX_Input_Byte)
     );
  
  UART_TX #(.CLKS_PER_BIT(TB_CLKS_PER_BIT)) UART_TX_Inst
  	 (.Clock(TB_Clock),
     .TX_Send(TB_TX_Send),
     .Input_Byte(TB_TX_Input_Byte),
     .Main_TX_Active(TB_TX_Active),
     .Output_Serial(TB_TX_Output_Serial)
     );

  assign TB_RX_Input_Serial = TB_TX_Active ? TB_TX_Output_Serial : 1'b1;
    
  always
    #(TB_CLOCK_PERIOD_NS/2) TB_Clock <= !TB_Clock;
  
  initial
    begin
      @(posedge TB_Clock);
      @(posedge TB_Clock);
      TB_TX_Send   <= 1'b1;
      TB_TX_Input_Byte <= 8'hFF;
      @(posedge TB_Clock);
      TB_TX_Send <= 1'b0;

      @(posedge TB_RX_Receive);
      if (TB_RX_Input_Byte == 8'hFF)
        $display("Test Passed - Correct Byte Received");
      else
        $display("Test Failed - Incorrect Byte Received");
      
      @(posedge TB_Clock);
      @(posedge TB_Clock);
      TB_TX_Send   <= 1'b1;
      TB_TX_Input_Byte <= 8'hAA;
      @(posedge TB_Clock);
      TB_TX_Send <= 1'b0;

      @(posedge TB_RX_Receive);
      if (TB_RX_Input_Byte == 8'hAA)
        $display("Test Passed - Correct Data Received");
      else
        $display("Test Failed - Incorrect Data Received");
      
      $finish();
    end
  
  initial 
  begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end
endmodule
