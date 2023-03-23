/*
 * @Author: Pabin <pabin_pluto@foxmail.com>
 * @Date: 2023-03-22 15:19:05
 * @LastEditors: Pabin <pabin_pluto@foxmail.com>
 * @LastEditTime: 2023-03-22 15:51:45
 * @FilePath: Pabin_module\ab_uduu\ab_uduu.v
 * @Description: 
 *    This module converts the posedge and negedge 
 *of a clock signal into rising edge, when the 
 *clock signal is stable at low or high level, 
 *the output is low level, and the edge output 
 *peak pulse
 *  
 * Copyright (c) 2023 by Pabin, All Rights Reserved. 
 */

module ab_uduu (
    input clk_in,//输入时钟信号
    input rst_n, //复位信号
    output reg dubl_clk //输出双边沿脉冲信号
);
//时钟切换变量,用于切换dubl_clk的驱动源
reg clk_sel;
//根据clk_sel的数值，切换dubl_clk的驱动
always@(*) dubl_clk = clk_sel? clk_in: ~clk_in;

//由复位信号rst_n或输出时钟反馈驱动控制clk_sel的取值
always @(posedge dubl_clk or negedge rst_n) 
    begin
        if(~rst_n) ////根据clk_in的状态对clk_sel进行初始化
            begin
                clk_sel <= clk_in? 1'b0 : 1'b1;
            end
        else
            begin
                clk_sel <= ~clk_sel;
            end
    end
endmodule //ab_uduu
