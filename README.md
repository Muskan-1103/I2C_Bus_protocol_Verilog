# I2C_Bus_protocol_Verilog
Step1 File: This step looks at designing the finite state machine, and implementing the data signal.
Step2 File: This step looks at designing the logic for the I2C clock.
I2C_CLK_DIVIDER File:This step looks at configuring a clock divider to handle the high-speed (100MHz) clock on the XUPV5 board and stepping it down to 100KHz.  It also looks at how to handle timing in the ISIM simulator.
Step3 File: This step introduces uses Xilinx's core generator to create a FIFO, and then we use a layered module approach to integrate the existing hardware with the FIFO buffer.

Source Followed :  https://youtube.com/playlist?list=PLIA9XWvqXXMzzO0g6bZTEtjTBv6sbKYpN&si=OLcNGKy2pPRYyIbu
