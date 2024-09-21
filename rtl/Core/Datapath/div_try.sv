module div_try #(parameter WIDTH=4) (

    input      logic clk,

    input      logic start,          // start signal

    output     logic busy,           // calculation in progress

    output     logic valid,          // quotient and remainder are valid

    output     logic dbz,            // divide by zero flag

    input      logic [WIDTH-1:0] x,  // dividend

    input      logic [WIDTH-1:0] y,  // divisor

    output     logic [WIDTH-1:0] q,  // quotient

    output     logic [WIDTH-1:0] r,   // remainder
    output     logic done
    );



    logic [WIDTH-1:0] y1;            // copy of divisor

    logic [WIDTH-1:0] q1, q1_next;   // intermediate quotient

    logic [WIDTH:0] ac, ac_next;     // accumulator (1 bit wider)

    logic [$clog2(WIDTH)-1:0] i;     // iteration counter
   logic reset;
   /* logic [2:0] count;

    always_ff @ (posedge clk) begin 
            if (reset) count<=3'b000;
            else if (count < 3'b100)count = count + 1'b1;


    end

    always_comb begin 
        if (count == 3'b000)begin  start_div =1'b1;  end
        else if (count == 3'b010) start_div=1'b0;
        else if (count =3'b100) begin reset =1'b0;start_div=1'b0; end 
        else if (~start & done ) reset =1'b1;

    end
     */

 /*   always_comb begin 
        

         if (start & busy) reset =1'b0;
         else if (start & ~ busy) reset=1'b0;
         else if (start & done ) reset =1'b1;
        else if (start) reset=1'b1;
        
     end*/

    always_comb begin

        if (ac >= {1'b0,y1}) begin

            ac_next = ac - y1;

            {ac_next, q1_next} = {ac_next[WIDTH-1:0], q1, 1'b1};

        end else begin

            {ac_next, q1_next} = {ac, q1} << 1;

        end

    end



    always_ff @(negedge clk) begin

        if (busy) begin

            if (i == WIDTH-1) begin  // we're done

                busy <= 0;
                done <=1'b1;

                valid <= 1;

                q <= q1_next;

                r <= ac_next[WIDTH:1];  // undo final shift

            end else begin  // next iteration

                i <= i + 1;
                done<=1'b0;
                ac <= ac_next;

                q1 <= q1_next;

            end

        end
        
        else    if (start) begin

            valid <= 0;

            i <= 0;

            if (y == 0) begin  // catch divide by zero

                busy <= 0;
                done <=1'b1;

                dbz <= 1;

            end else begin  // initialize values

                busy <= 1;
                done<=1'b0;

                dbz <= 0;

                y1 <= y;

                {ac, q1} <= {{WIDTH{1'b0}}, x, 1'b0};

            end

        end 

    end

endmodule
