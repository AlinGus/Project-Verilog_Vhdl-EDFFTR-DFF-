`timescale 1ps / 1ps

module Test_EDFFTR;

    reg RN, E, D, CK;  // Semnale de intrare
    wire Q, QN;        // Semnale de ie?ire

    // Instan?ierea modulului EDFFTR
    EDFFTR #(
        .tpLH_CK_Q(498),
        .tpHL_CK_Q(660),
        .tpLH_CK_QN(808),
        .tpHL_CK_QN(644),
        .tSETUP(515),
        .tHOLD(886)
    ) uut (
        .RN(RN),
        .E(E),
        .D(D),
        .CK(CK),
        .Q(Q),
        .QN(QN)
    );

    // Generarea semnalului de ceas
    initial begin
        CK = 0;
        forever #500 CK = ~CK;  // Perioada ceasului: 1 ns (500 ps pentru fiecare tranzi?ie)
    end

    // Testare comportament
    initial begin
        // Resetare ini?ial?
        RN = 0; E = 0; D = 0;
        #1000 RN = 1;  // Activare reset dup? 1 ns

        // Test cu Enable activ
        #1000 D = 1; E = 1;  // D = 1, E = 1
        #1000 D = 0;         // Schimbare pe D
        
        // Test pentru timpi de setup ?i hold
        #800 D = 1; #300;    // Setup time = 515 ps
        #1000 D = 0; #100;   // Hold time = 886 ps

        // Finalizare simulare
        #5000 $stop;
    end

endmodule
