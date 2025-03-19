`timescale 1ps / 1ps

module EDFFTR (
    input wire RN,        // Reset asincron (activ pe '0')
    input wire E,         // Enable
    input wire D,         // Intrare de date
    input wire CK,        // Semnal de ceas
    output reg Q,         // Ie?irea principal?
    output wire QN        // Ie?irea inversat?
);

    // Ie?irea complementar? este negarea lui Q
    assign QN = ~Q;

    // Parametri generici pentru timpi dinamici
    parameter tpLH_CK_Q = 498;        // Timp de propagare CK ? Q (ns -> ps)
    parameter tpHL_CK_Q = 660;        // Timp de propagare CK ? Q (ns -> ps)
    parameter tpLH_CK_QN = 808;       // Timp de propagare CK ? QN (ns -> ps)
    parameter tpHL_CK_QN = 644;       // Timp de propagare CK ? QN (ns -> ps)
    parameter tSETUP = 515;           // Setup time pentru D înainte de CK (ns -> ps)
    parameter tHOLD = 886;            // Hold time pentru D dup? CK (ns -> ps)

    always @(posedge CK or negedge RN) begin
        if (!RN) begin
            Q <= #tpHL_CK_Q 1'b0;  // Reset pe Q
        end else if (E) begin
            Q <= #tpLH_CK_Q D;     // Transfer? D la Q
        end
    end

    specify
        // Specifica?ii pentru timpii de setup ?i hold
        $setup(D, posedge CK, tSETUP);
        $hold(posedge CK, D, tHOLD);
    endspecify

endmodule
