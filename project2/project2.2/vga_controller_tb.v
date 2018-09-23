`timescale 1ns / 1ps
/***************************************************************************
 * File Name: vga_controller_tb.v
 * Project: VGA Object Mapped
 * Designer: Marc Cabote
 * Email: marcdominic011@gmail.com
 * Rev. Date: 11 October, 2017
 * 
 * Purpose:	The purpose of this module is to test if the the vga top
 *          will behave the way it is expected to behave. From this 
 *				we will see that proper rgb values will be set depending
 *				on the pixel location (x or y).
 *								           
 * Notes: -	25 Mhz Clock, Vcount and Hcount were copied from top level 
 *          to sync the clocks
 *        -	remove comments on display to see where the error is if 
 *          error counter is not zero
 *        -	if error counter stays zero then the top level is verified
 ***************************************************************************/

module vga_controller_tb;
	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire hsync;
	wire vsync;
	wire [11:0] rgb;
	
	//Signals
	wire [9:0] pixel_x, pixel_y;
	wire video_on;
	
	//Variables
	integer errorCount = 0;//counter for error
	
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
	
	assign pixel_x = hcount;
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

	assign video_on = ((hcount<656) && (vcount<490));
	// Instantiate the Unit Under Test (UUT)
	vga_controller uut (
		.clk(clk), 
		.rst(rst), 
		.hsync(hsync), 
		.vsync(vsync), 
		.rgb(rgb)
	);
	
	always #1 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;//check reset

		// Wait 100 ns for global reset to finish
		#1;
		rst = 0;
        
		// Add stimulus here

	end
	
	always @ (posedge clk, posedge rst)
   begin 
          
      if (tick && video_on) begin  
			 //Verify Wall
          if (pixel_x >= 32 && pixel_x <= 35 
			      && (rgb != 12'hF00))
				  //$display ("Error Wall");
              errorCount = errorCount + 1;
				  			    
          //Verify Bar
          else if ((pixel_x >= 600) && (pixel_x <= 603) 
					&& (pixel_y >= 204)  && (pixel_y <= 276) 
					&& (rgb != 12'h0F0))
					//$display ("Error Bar");
               errorCount = errorCount + 1; 
                   
          //Verify Ball
          else if ((pixel_x >= 580) && (pixel_x <= 588) 
			       && (pixel_y >= 238) && (pixel_y <= 246) 
					 && (rgb != 12'h00F))
					//$display ("Error Ball");
                errorCount = errorCount + 1;
					
			 //Verify Background
			 else if (!(pixel_x >= 32) && !(pixel_x <= 35) 
					&&	!(pixel_x >= 600) && !(pixel_x <= 603) 
					&& !(pixel_y >= 204) && !(pixel_y <= 276) 
					&& !(pixel_x >= 580) && !(pixel_x <= 588) 
			      && !(pixel_y >= 238) && !(pixel_y <= 246) 
					&& (rgb != 12'h000))
					//$display ("Error BG");
					errorCount = errorCount + 1;
         
			//Else display error
         else if (errorCount != 0)
				$display ("Error Count: ",errorCount);
		end

		if (!(video_on) && !(rgb == 12'h00))
			//$display ("Error video");
			errorCount = errorCount + 1;
		else if (errorCount != 0)
			$display ("Error Count: ",errorCount);
			
   end
	    
endmodule

