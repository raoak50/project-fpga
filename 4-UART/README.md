UART builds off the use of counters but introduces FSM.
FSM or Finite State Machine is a way to control phases of a hardware.
Basically, the hardware cycles through phases such as IDLE, START, DATA, and STOP.
After recieving a signal, the machine switches off its IDLE state and begins.
For TX, the UART takes in a data register and outputs its values chronologically.
For RX, the UART takes in the values chronologically and outputs them to a register.
Ultimately, UART is important to learn how the clk works and how counters work.
To store data, you must use a clocked block and not a combinational one. 

