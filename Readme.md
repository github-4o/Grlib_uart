this repo holds a code for UART controller.

WARNING: gpl flue. source code is based on grlib implementation

features:
1. no dependencies on grlib packages
2. explicit datapath for both write and read ports
3. recoveres baudrate. the code uses first *several* bytes to recover baudrate. those bytes are discarded. it's enough to send 0x55/0xAA for a baudrate recovery to complete.
