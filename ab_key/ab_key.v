module ab_key
#(
    parameter ISH = 1'b0, //是否为高电平有效
    parameter CHECKTIME = 3,//消抖阈值，单位10ms
    parameter LONGTIME =30, //长按下阈值，单位：10ms
    parameter OUTKEEP = 2    //输出保持度,单位：10ms
)
(
    input wire clk_100,
    input wire keyin,
    output reg[1:0] keyout //按键输出，11为长按下，01为短按下，00为无按键按下
);

//定义按键类型 : 无按键 短按键 长按键
localparam NONEKEY = 2'b00,SHOTKEY = 2'b01,LONGKEY = 2'b11;

//定义计数器
integer checktime= CHECKTIME;
integer longtime = LONGTIME;
integer outkeep  = OUTKEEP;
//定义按键输入
reg key;
always @(*) key = ISH? ~keyin:keyin; //按键按下，低有效

//定义按键缓存
reg [1:0] demo_key;

//计数器工作
//check计数器
always@(posedge clk_100)
    begin
        if(key)
            checktime <= CHECKTIME; //按键弹起，消抖计时复位
        else if(~key)
        begin
            if(checktime<=0) checktime<=0;//保持
            else checktime <= checktime-1;//计数
        end
    end

//longtime计数器
always@(posedge clk_100)
    begin
        if(key)
            longtime <= LONGTIME;    //按键弹起计时复位
        else if(~key)
        begin
            if(longtime<=0) longtime<=0;//保持
            else longtime <= longtime-1;//计数
        end
    end

//outkeep计数器
always@(posedge clk_100)
    begin
        if(~key)                    //按键按下计时复位
        outkeep <= OUTKEEP;
        else if(key)
        begin
            if(outkeep<=0) outkeep<=0;//保持
            else outkeep <= outkeep-1;
        end
    end

//按键类型决判
always@(*)
begin
if(~key)   //按键按下，就一直判断
    begin
        if(longtime<=0)
            demo_key =LONGKEY;//判定为长按键
        else if(checktime<=0)
            demo_key =SHOTKEY;//判定为短按键
        else
            demo_key =NONEKEY;//判定为空按键
    end
else   //按键抬起保持
    begin
        demo_key<=demo_key;//保持
    end
end
//按键脉冲发送
always@(*) 
begin
    if(key)  //按键弹起
        begin
            if(outkeep > 0) 
                keyout =demo_key;
            else
                keyout = NONEKEY;
        end
    else
        begin
            keyout = NONEKEY;
        end
end
endmodule //pab4789_Getkey