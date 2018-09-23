`timescale 1ns / 1ps
/***************************************************************************
 * File Name: vga_controller.v
 * Project: VGA Sync
 * Designer: Marc Cabote
 * Email: marcdominic011@gmail.com
 * Rev. Date: 11 October, 2017
 * 
 * Purpose:	This project introduces the use of vga(video graphics array) 
 *          display. The design will have 640 x 480 resolution. 
 *				The color of the screen will be determined by the onboard 
 *				switches 0-11. The vga sync is then verified through 
 *				simulation with the use of test fixtures. The code will 
 *				then be programmed to the board with the use of a vga monitor.  
 *          
 *
 * Notes:	-  This is the top level module for this project
 *          -	This module has an asynchronous reset input.
 *          -  switches 0-11 drive vga_rgb 0-11 respectively. 
 *          -  Reset is button up
 ***************************************************************************/
module vga_controller(input clk, rst,
							 output hsync , vsync,
							 output [11:0] rgb);
	

	wire video_on; //wire for the 2 to 1 mux
	wire rst_out;  //wire for aiso to vga sync reset
	wire[9:0] pixel_x, pixel_y;
	
	aiso
	m0(.clk(clk), .rst(rst), .rst_out(rst_out));
	
	vga_sync	
	m1( .clk(clk), .rst(rst_out),.pixel_x(pixel_x), .pixel_y(pixel_y), 
	    .hsync(hsync), .vsync(vsync), .video_on(video_on));
	
	pixel_generator
	m2( .video_on(video_on), .pixel_x(pixel_x), .pixel_y(pixel_y),.rgb(rgb));

endmodule
