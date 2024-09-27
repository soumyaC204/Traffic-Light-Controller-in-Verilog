
module traffic_control (
    input clk,
input C, input reset,
    input TS,
    input TL,
    output reg MG, MY, MR,
    output reg SG, SY, SR,
    output reg ST
);

    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;
    localparam S3 = 2'b11;
traffic_timers timers_inst(
    .clk(clk),
    .reset(reset),
    .TS(TS),
    .TL(TL)
);
    reg [1:0] p_state, n_state;

always @(posedge clk or posedge reset) begin
        if (reset)
            p_state <= S0;
        else
            p_state <= n_state;
    end

    always @(*) begin
        case (p_state)
            S0: begin
                if (~C || TL)
                    n_state = S0;
                else
                    n_state = S1;
            end
            S1: begin
                if (~TS)
                    n_state = S1;
                else
                    n_state = S2;
            end
            S2: begin
                if (C && TL)
                    n_state = S2;
                else
                    n_state = S3;
            end
            S3: begin
                if (~TS)
                    n_state = S3;
                else
                    n_state = S0;
            end
            default:
                n_state = S0;
        endcase
    end

    always @(p_state) begin
        case (p_state)
            S0: begin
                MG = 1; MY = 0; MR = 0;
                SG = 0; SY = 0; SR = 1;
                ST = TL;
            end
            S1: begin
                MG = 0; MY = 1; MR = 0;
                SG = 0; SY = 0; SR = 1;
                ST = TS;
            end
            S2: begin
                MG = 0; MY = 0; MR = 1;
                SG = 1; SY = 0; SR = 0;
                ST = TL;
            end
            S3: begin
                MG = 0; MY = 0; MR = 1;
                SG = 0; SY = 1; SR = 0;
                ST = TS;
            end
        endcase
    end
endmodule

module traffic_timers(
    input clk,
    input reset,
    output reg TS,
    output reg TL
);

parameter SHORT_LIMIT = 5;
parameter LONG_LIMIT  = 20;

reg [31:0] ts_counter;
reg [31:0] tl_counter;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        ts_counter <= 0;
        tl_counter <= 0;
        TS <= 0;
        TL <= 0;
    end else begin
        if (ts_counter < SHORT_LIMIT) begin
            ts_counter <= ts_counter + 1;
            TS <= 0;
        end else begin
            ts_counter <= 0;
            TS <= 1;
        end

        if (tl_counter < LONG_LIMIT) begin
            tl_counter <= tl_counter + 1;
            TL <= 0;
        end else begin
            tl_counter <= 0;
            TL <= 1;
        end
    end
end
endmodule

