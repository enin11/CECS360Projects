`timescale 1ns / 1ps
/***************************************************************************
 * File Name: vga_sync.v
 * Project: VGA Sync
 * Designer: Marc Cabote
 * Email: marcdominic011@gmail.com
 * Rev. Date: 11 October, 2017
 * 
 * Purpose:	This module will generate the hysnc signal. Hsync
 *          specifies the time required to scan a row. This module also   
 *          generates the vsync signal which takes care of the time
 *          required to scan the entire screen. This will take into account
 *          a screen with 640 x 480 resolution with has a 25Mhz refresh rate.
 *
 * Notes:	-	This module has an asynchronous reset input.
 *          -  vide_on enables objects to be displayed
 ***************************************************************************/
module vga_sync(input            clk, rst,
					 output [9:0] pixel_x, pixel_y,
					 output         hsync, vsync, video_on);
	
	/*********************************
	*Counter to generate 25Mhz clock 
	*********************************/
	reg [1:0] count;
	wire tick;
	
	assign tick = (count == 2'b11);
	
	always @ (posedge clk, posedge rst)
		if (rst)  count <= 2'b0; else
		if (tick) count <= 2'b0; else
		          count <= count + 2'b1;
					 
					 
	/**********************************
	*Horizontal count 0-799
	**********************************/
	reg [9:0] hcount;
	wire endh;
	
	assign pixel_x = hcount ;
	assign endh = (hcount == 799);
  
	always @ (posedge clk, posedge rst)
		if (rst) hcount <= 10'b0; else
		if (tick)
			if (endh) hcount <= 10'b0; else
			          hcount <= hcount +10'b1;
						 
	assign hsync = ~(hcount >= 656 & hcount <= 751);
	
	/**********************************
	*Vertical count 0-524
	**********************************/
	reg [9:0] vcount;
	wire endv;
	
	assign pixel_y = vcount;
	assign endv = (vcount == 524);
	
	always @ (posedge clk, posedge rst)
		if (rst) vcount <= 10'b0; else
		if (tick)
			if(endh)
				if(endv) vcount <= 10'b0; else
							vcount <= vcount + 10'b1;
							
	assign vsync = ~(vcount >= 490 & vcount <= 491);
	
	//display would be on when vsync and hsync are "inside" the
	//vga monitor
	assign video_on = ((hcount<656) && (vcount<490));
				
endmodule
