module ab_key
#(
    parameter ISH = 1'b0, //�Ƿ�Ϊ�ߵ�ƽ��Ч
    parameter CHECKTIME = 3,//������ֵ����λ10ms
    parameter LONGTIME =30, //��������ֵ����λ��10ms
    parameter OUTKEEP = 2    //������ֶ�,��λ��10ms
)
(
    input wire clk_100,
    input wire keyin,
    output reg[1:0] keyout //���������11Ϊ�����£�01Ϊ�̰��£�00Ϊ�ް�������
);

//���尴������ : �ް��� �̰��� ������
localparam NONEKEY = 2'b00,SHOTKEY = 2'b01,LONGKEY = 2'b11;

//���������
integer checktime= CHECKTIME;
integer longtime = LONGTIME;
integer outkeep  = OUTKEEP;
//���尴������
reg key;
always @(*) key = ISH? ~keyin:keyin; //�������£�����Ч

//���尴������
reg [1:0] demo_key;

//����������
//check������
always@(posedge clk_100)
    begin
        if(key)
            checktime <= CHECKTIME; //��������������ʱ��λ
        else if(~key)
        begin
            if(checktime<=0) checktime<=0;//����
            else checktime <= checktime-1;//����
        end
    end

//longtime������
always@(posedge clk_100)
    begin
        if(key)
            longtime <= LONGTIME;    //���������ʱ��λ
        else if(~key)
        begin
            if(longtime<=0) longtime<=0;//����
            else longtime <= longtime-1;//����
        end
    end

//outkeep������
always@(posedge clk_100)
    begin
        if(~key)                    //�������¼�ʱ��λ
        outkeep <= OUTKEEP;
        else if(key)
        begin
            if(outkeep<=0) outkeep<=0;//����
            else outkeep <= outkeep-1;
        end
    end

//�������;���
always@(*)
begin
if(~key)   //�������£���һֱ�ж�
    begin
        if(longtime<=0)
            demo_key =LONGKEY;//�ж�Ϊ������
        else if(checktime<=0)
            demo_key =SHOTKEY;//�ж�Ϊ�̰���
        else
            demo_key =NONEKEY;//�ж�Ϊ�հ���
    end
else   //����̧�𱣳�
    begin
        demo_key<=demo_key;//����
    end
end
//�������巢��
always@(*) 
begin
    if(key)  //��������
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