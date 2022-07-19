# 8_Bit_UART

## Table of Contents
- [Abstract](#abstract)
- [UART Transmitter Receiver Connection](#uart-transmitter-receiver-connection)
- [Output Signals](#output-signals)

## Abstract
UART stands for Universal Asynchronous Receiver/Transmitter. UART is a hardware communication protocol that uses asynchronous serial communication with configurable speed. As there is no clock signal to synchronize the output bits from the transmitting device going to the receiving end, it is called Asynchronous. UART interface is divided into two parts:- Transmitter and Receiver. Transmitter sends the data to the receiver via data lines. It is the most used protocol in device-to-device communication.

## UART Transmitter Receiver Connection
The UART Transmitter takes 3 inputs:- ```Clock```, ```TX_Send```, ```Input_Byte```
- ```Clock``` - Takes external Clock signal for internal use
- ```TX_Send``` - Uses this signal to start data transfer
- ```Input_Byte``` - This is a 8 bit data line carrying input data to be transferred

The UART Transmitter gives 2 outputs:- ```Main_TX_Active```, ```Output_Serial```
- ```Main_TX_Active``` - This signal is used to check if transmitter has started transmission process
- ```Output_Serial``` - The data entered in the transmitter parallely gets converted to serial form and leaves via Output_Serial

The UART Transmitter takes 2 inputs:- ```Clock```, ```Input_Serial```
- ```Clock``` - Takes external Clock signal for internal use
- ```Input_Serial``` - The data transmitted on wire is received serially via Input_Serial

The UART Transmitter gives 2 outputs:- ```Main_TX_Active```, ```Output_Serial```
- ```Main_RX_Receive``` - This signal is used to check if receiver has completed data reception and conversion
- ```Main_Data_Out``` - The data entered in the receiver serially gets converted to parallel form and leaves via Main_Data_Out

![](https://github.com/PatelVatsalB21/8_Bit_UART/blob/main/images/UART%20Diagram.png)

## Output Signals
### TestBench
![](https://github.com/PatelVatsalB21/8_Bit_UART/blob/main/images/UART%20TB%20Signal.png)
### Transmitter
![](https://github.com/PatelVatsalB21/8_Bit_UART/blob/main/images/UART%20TX%20Signal.png)
### Receiver
![](https://github.com/PatelVatsalB21/8_Bit_UART/blob/main/images/UART%20RX%20Signal.png)
