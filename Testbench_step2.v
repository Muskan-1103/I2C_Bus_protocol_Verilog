module test_step2;
	//inputs
	reg clk;
	reg reset;
	
	//outputs
	wire i2c_sda;
	wire i2c_scl;
	
	//instantiate the uut
	step2 uut(
		.clk(clk),
		.reset(reset),
		.i2c_sda(i2c_sda),
		.i2c_scl(i2c_scl)
	);

	initial begin
		clk = 0;
		forever begin
			clk = #1 ~clk;
		end
	end

	initial begin
		reset = 1;
		#10;
		reset = 0;
		#100;
	end
endmodule
