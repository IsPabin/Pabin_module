/*
 * @Author: Pabin <pabin_pluto@foxmail.com>
 * @Date: 2023-03-24 10:50:15
 * @LastEditors: Pabin <pabin_pluto@foxmail.com>
 * @LastEditTime: 2023-03-24 10:51:27
 * @FilePath: \Pabin_module\ab_itpl\ab_itpl.v
 * @Description: 
 * Generate initial pulse with adjustable width.
 * Copyright (c) 2023 by Pabin, All Rights Reserved. 
 */

module ab_itpl 
#(
    parameter KEEP=1
)(
    input clk,          //监测工作时钟
    input check,        //监测信号
    output reg pulse    //脉冲输出
);
reg lock=0;//定义单脉冲锁标志位
reg [6:0]out_ctr;//定义脉冲保持计数器，最大保持127个工作时钟长度
reg en; //定义触发使能标志位
always@(*)  pulse = (|out_ctr)&&(~lock);    //脉冲输出，受到lock的控制

always@(posedge clk )                           //监测时钟采样
    begin
        if(!check)                              //check低电平时执行
                begin
                    out_ctr =0;
                    en = 1;                     //check为低电平时，触发使能置一;
                end
        else                                    //状态启动时执行
            begin
                if(en)                          //check高电平到来，判断触发使能
                    begin
                        en<=0;                  //触发使能置零
                        if(KEEP==0)
                        begin
                            out_ctr = 1;        //单次脉冲强行赋值
                        end
                        else
                            out_ctr <= KEEP;    //检测到check高电平，开始产生脉冲
                    end
                else if(out_ctr<=0)
                    begin
                        out_ctr<=0;             //脉冲输出结束后保持低电平
                    end
                else
                    begin
                        if(KEEP==0)    lock = 1;//启动锁lock，确保只输出一次
                        else        lock = 0;
                        out_ctr <= out_ctr-1;   //pulse保持计数器
                    end
            end
end
endmodule