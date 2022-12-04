//CONTADOR DE CUENTA ARBITRARIA 10-4-12-9-2-1-3-6

module JK(output reg Q,output wire nQ,input wire J,input wire K, input wire C);
    not (nQ,Q);

    initial
    begin
            Q=0; // Inicializa el biestable en 0
    end
    always @(negedge C)
        case({J,K})
            2'b10: Q=1; //J=1 K=0
            2'b01: Q=0; //J=0 K=1
            2'b11: Q=~Q; //J=1 K=1
        endcase
    endmodule


module contador(output wire[3:0]Q, input wire C);
    wire [3:0] nQ;  // Salida complementaria

    wire AQ1Q0, AQ3nQ0, AnQ2nQ0, AnQ3nQ2,AQ3nQ1; // Salidas intermedias AND
    wire OQ1Q0Q3nQ0,OQ1Q3,OnQ3nQ2Q3nQ1; // Salidas intermedias OR

    and A0 (AQ1Q0, Q[1], Q[0]); // AND Q1 y Q0
    and A1 (AQ3nQ0, Q[3], nQ[0]); // AND Q3 y nQ0
    and A2 (AnQ2nQ0, nQ[2], nQ[0]); // AND nQ2 y nQ0
    and A3 (AnQ3nQ2, nQ[3], nQ[2]); // AND nQ3 y nQ2
    and A4 (AQ3nQ1, Q[3], nQ[1]); // AND Q3 y nQ1

    or O0 (OQ1Q0Q3nQ0, AQ1Q0, AQ3nQ0); // OR Q1Q0 y Q3nQ0
    or O1 (OQ1Q3, Q[1], Q[3]); // OR Q1 y Q3
    or O2 (OnQ3nQ2Q3nQ1, AnQ3nQ2, AQ3nQ1); // OR nQ3nQ2 y Q3nQ1

    JK jk3 (Q[3], nQ[3],Q[2],nQ[2],C); 
    JK jk2 (Q[2], nQ[2],OQ1Q0Q3nQ0,OQ1Q3,C);
    JK jk1 (Q[1], nQ[1],nQ[2],AnQ2nQ0, C);
    JK jk0 (Q[0], nQ[0],OnQ3nQ2Q3nQ1,OQ1Q3,C);

endmodule

module test;
    reg C; // Entrada de reloj
    wire[3:0] Q; // Salida del contador
    contador Contador1(Q,C);

    always #2 C=~C; //Funcion reloj
    initial
    begin
        $dumpfile("test.dmp"); //Nombre del archivo de salida de cronograma
        $dumpvars; //Comando para que se muestren las variables en el cronograma

        C=0; // Inicializa el reloj en 0
        Contador1.jk3.Q='b1; // Inicializa el contador en 1
        Contador1.jk2.Q='b0; // Inicializa el contador en 0
        Contador1.jk1.Q='b1; // Inicializa el contador en 1         =10
        Contador1.jk0.Q='b0; // Inicializa el contador en 0

    $monitor($time,"Q=%b%b%b%b=%d",Q[3],Q[2],Q[1],Q[0],Q); //Muestra en pantalla el valor de los registros
    #100 $finish;
    end

endmodule
