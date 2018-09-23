`timescale 1ns / 1ps
/***************************************************************************
 * File Name: pixel_generator.v
 * Project: VGA Object Mapped
 * Designer: Marc Cabote
 * Email: marcdominic011@gmail.com
 * Rev. Date: 23 October, 2017
 * 
 * Purpose:	This module will generate the objects specified. These objects
 *				are a Wall, a Ball , and a Bar(Paddle). Each object will have
 *          a specified region.The Wall shall occupy the region from 
 *				horizontal scan count 32 through 35.The Paddle shall occupy 
 *				the region from horizontal scan count 600 through 603 and 
 *				vertical scan count 204 to 276. The Ball shall occupy 
 *				the region from horizontal scan count 580 through 588 and 
 *				vertical scan count 238 through 246.
 *
 * Notes:	-	This module has no reset, the reset comes from vga sync
 *          -  vide_on enables objects to be displayed
 ***************************************************************************/
module pixel_generator(input  video_on,
							  input [9:0] pixel_x, pixel_y,
							  output reg[11:0] rgb);
	
	wire wall, bar, ball;
	wire [11:0] wall_rgb, bar_rgb, ball_rgb;						  

	/*********************************
	* generate WALL
	*********************************/
	assign wall = (pixel_x >= 32) && ( pixel_x <= 35);
	assign wall_rgb = 12'hF00;//wall blue
	
	/*********************************
	* generate BAR
	*********************************/
	assign bar = (pixel_x >= 600) && (pixel_x <=603)
	           &&(pixel_y >= 204) && (pixel_y <=276);
	assign bar_rgb = 12'h0F0;//bar green
	
   /*********************************
	* generate BALL
	*********************************/
	assign ball = (pixel_x >= 580) && (pixel_x <=588)
	           &&(pixel_y >= 238) && (pixel_y <=246);
	assign ball_rgb = 12'h00F;//ball red
	
   /*********************************
	* generate display
	*********************************/	
	always @ (*) begin
		if (video_on) 
			if (wall)
				rgb = wall_rgb; else
			if (bar)
				rgb = bar_rgb; else
			if (ball)
				rgb = ball_rgb;
			else
				rgb = 12'h000;//blank
		else
			rgb = 12'h000;//blank
	end
endmodule
