`timescale 1ns / 1ns
/***************************************************************************
 * File Name: vga_sync_tb.v
 * Project: VGA Sync
 * Designer: Marc Cabote
 * Email: marcdominic011@gmail.com
 * Rev. Date: 11 October, 2017
 * 
 * Purpose:	The purpose of this module is to test if the vga_sync
 *          will behave the way it is expected to behave. From this 
 *				test we will see that the waveform for vsync will be less
 *				frequent thatn hsync as expected. This test is used  
 *				for verification specific to the vga_sync module. 
 *				 
 *          
 *
 * Notes:	
 *          
 *          
 ***************************************************************************/

module vga_sync_tb;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	//wire [9:0] pixel_x;
	//wire [9:0] pixel_y;
	wire hsync;
	wire vsync;
	wire video_on;
	
	// Instantiate the Unit Under Test (UUT)
	vga_sync uut (
		.clk(clk), 
		.rst(rst), 
		//.pixel_x(pixel_x), 
		//.pixel_y(pixel_y), 
		.hsync(hsync), 
		.vsync(vsync), 
		.video_on(video_on)
	);
	
	// initialize clock to always so it will
	// oscillate the clock source model every 1 clock unit
	always #1 clk =~clk;
	
	initial begin
		//reset high to test reset
		//notice that clock is set to 0
		//as reset is asynchronous
		clk = 0;
		rst = 1;
		
		// Wait 1 clock unit for global reset to finish
		#1;
		rst = 0;

      
		// Add stimulus here
	
	end
	
      
endmodule

