`timescale 1ns / 1ps
/***************************************************************************
 * File Name: aiso.v
 * Project: VGA Object Mapped
 * Designer: Marc Cabote
 * Email: marcdominic011@gmail.com
 * Rev. Date: 20 September, 2017
 * 
 * Purpose:	The asynchronous in syncrhonous out (AISO) is designed to 
 *          produce a synchronized reset from an asynchronous reset. 
 *          The reset output from the aiso is then fed to all the rest
 *          of the modules for this project. The reset is produced at every
 *          rising edge of the clock. This module forces two flops to zero
 *          at a press of the reset button, which tells us the input from 1
 *          turns to zero at the output producing a synchronous reset.
 *
 * Notes:	-	This module has an asynchronous reset input.
 *         
 ***************************************************************************/
module aiso(input  clk, rst,
				output rst_out);
	
	//local registers
	reg qMeta, qOk;
	
	always @(posedge clk, posedge rst)
		if(rst) begin
			  qMeta <= 1'b0;//reset metastable and stable output
			  qOk <= 1'b0;
		end
	
		else begin   
	        qMeta <= 1'b1;//metastable gets 1 from button press
	        qOk <= qMeta; //stable gets metastable 
		end		  
	
	assign rst_out = ~qOk; //invert the output to produce synchronous out

endmodule
