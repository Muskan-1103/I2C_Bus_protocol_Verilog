module test_step2;
	//inputs
	reg clk;
	reg reset;
	
	//outputs
	wire i2c_sda;
	wire i2c_scl;
	
	wire i2c_clk;

	//instantiate the uut
	i2c_clk_divider instance)name(
		.reset(reset),
		.ref_clk(clk),
		.i2c_scl(i2c_scl)
	);
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
		#2000;
		reset = 0;
		#16000;
	end
endmodule
