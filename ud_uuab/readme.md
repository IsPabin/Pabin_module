# 模块介绍
## 1.模块由来
本模块产生于林老师提出的一个问题，问题是：如何让一个always模块由clk的上升沿和下降沿都能触发?
本问题在网上已有多种解决办法，思路主要有：
- 倍频clk，使用高一倍的频率信号触发always
- 由posedge和negeedge触发的always分别管理reg a，reg b，再通过clk电平判断，将其合并到reg out
- 通过锁相环产生一个相差180°的clk信号clk1，由clk和clk1共同触发always模块
有鉴于本人对锁相环不甚了解，其他方法又过于繁杂，故在几番思索之后，参考曾经做过的一个5分频电路的思路，设计了本模块

## 2.如何使用
`input：clk——in //输入时钟信号`

`input: rst_n //低电平初始化信号`

`output: dubl_clk //输出上升脉冲信号`

## 3.核心思路
将clk_in的上升沿和下降沿全部转化为上升脉冲（up-down $\Longrightarrow$ up-up）,当clk处于稳定的高或低电平时，输出将保持低电平

## 4.仿真波形
环境：modelsim se win32 10.1c 
![image](https://user-images.githubusercontent.com/99165596/226847238-d4d03a45-1c89-483e-856b-45ec23305100.png)
