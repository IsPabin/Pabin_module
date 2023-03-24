<!--
 * @Author: Pabin <pabin_pluto@foxmail.com>
 * @Date: 2023-03-24 10:51:39
 * @LastEditors: Pabin <pabin_pluto@foxmail.com>
 * @LastEditTime: 2023-03-24 11:20:00
 * @FilePath: \Pabin_module\ab_itpl\readme.md
 * @Description: 
 * 
 * Copyright (c) 2023 by Pabin, All Rights Reserved. 
-->
# 模块介绍
## 1.模块由来
本模块想法开始于2022秋数电期中作业时，设计一个时间可设置的计时器时，所遇到的一个每当状态切换后需要初始化的问题，结果后来的不断完善，设计出了此模块
对于状态初始化，有以下方式：
1. FPGA上电初始化：
    - 可以在verilog编写always模块时，添加一个敏感信号rst_n(变量名称任意，重点是下降沿触发，对应操作为以常量给某个reg，即可实现对reg的上电初始化，这样做的原因是这种复位信号及其相关赋值操作，会被综合为一次复位操作，在FPGA上电时，会默认执行一次,故可以实现上电初始化
    - 可以在定义reg变量的时候直接赋初值，即如：`reg [3:0] data = 4'b1010`的操作，这样也会在上电的时候实现初始化，我个人认为这样写，还是会综合一次复位操作，在FPGA上电时，会默认执行一次，只不过，一方案可以在后续多次执行，而这种只能在上电时执行罢了
2. 状态切换初始化：
    - 一种办法是：将`state<=next_state`交给一个时钟去控制，然后就可以将`pulse = !(state==next_state)`作为初始化时钟了
    - 还有一种办法就是本模块，其特点是支持通过例化参数控制pulse的次数和宽度


## 2.如何使用
`parameter KEEP //默认为1，保持度，KEEP（0~127）个监测工作时钟，当KEEP=0，在程序执行中只产生首次脉冲，且宽度为1个clk`

`input：clk //监测工作时钟`

`input: check //被监测信号`

`output: pulse //初始化脉冲信号（脉宽不会超过check高电平宽度）`

## 3.核心思路
以监测时钟clk监测check，当check变为高电平时，触发脉冲pulse，并开始计数，当计数至零后pulse置零，同时，在KEEP=0时使用lock充当单脉冲锁

## 4.仿真波形
环境：modelsim se win32 10.1c 
KEEP = 0（单次脉冲）

KEEP = N（N>0）
