module traffic_control_tb;
    reg clk;
    reg reset;
    reg C;
    reg TS;
    reg TL;

    wire MG, MY, MR;
    wire SG, SY, SR;
    wire ST;

    traffic_control uut (
        .clk(clk),
        .reset(reset),
      .C(C),
        .TS(TS),
        .TL(TL),
        .MG(MG),
        .MY(MY),
        .MR(MR),
        .SG(SG),
        .SY(SY),
        .SR(SR),
        .ST(ST)
    );

    always #5 clk = ~clk;

initial begin
        $dumpfile("traffic_control_tb.vcd");
  $dumpvars(0, traffic_control_tb);
        clk = 0;
        reset = 0;
        C = 0;
        TS = 0;
        TL = 0;

        reset = 1;
        #10;
        reset = 0;

        C = 0;
        TL = 1;
        #100;

        C = 1;
        #50;

        TS = 1;
        TL = 0;
        #20;

        TL = 1;
        #100;
        TS = 1;
        TL = 0;
        #20;

        TS = 0;
        C = 0;
        TL = 1;
        #100;

        $finish;
    end

    initial begin
        $monitor("Time: %d, Reset: %b, C: %b, TS: %b, TL: %b, MG: %b, MY: %b, MR: %b, SG: %b, SY: %b, SR: %b, ST: %b",
                 $time, reset, C, TS, TL, MG, MY, MR, SG, SY, SR, ST);
    end
endmodule
