library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EDFFTR is
    Port (
        RN : in STD_LOGIC;   
        E  : in STD_LOGIC;   
        D  : in STD_LOGIC;   
        CK : in STD_LOGIC;   
        Q  : out STD_LOGIC;  
        QN : out STD_LOGIC   
    );
end EDFFTR;

architecture Comportament of EDFFTR is
    -- Parametrii dinamici (în ps pentru simulare precisă)
    constant tpLH_CK_Q : time := 498 ps;        -- Timp de propagare CK -> Q
    constant tpHL_CK_Q : time := 660 ps;        -- Timp de propagare CK -> Q
    constant tpLH_CK_QN : time := 808 ps;       -- Timp de propagare CK -> QN
    constant tpHL_CK_QN : time := 644 ps;       -- Timp de propagare CK -> QN
    constant tSETUP : time := 515 ps;           -- Setup time pentru D înainte de CK
    constant tHOLD : time := 886 ps;            -- Hold time pentru D după CK
begin
    process(CK)
    begin
        if rising_edge(CK) then
            -- Verificarea timpului de setup
            assert D'stable(tSETUP)
            report "Setup time violated" severity error;

            -- Verificarea timpului de hold
            assert D'stable(tHOLD)
            report "Hold time violated" severity error;

            -- Comportamentul bistabilului
            if RN = '0' then
                Q <= '0' after tpHL_CK_Q;
                QN <= '1' after tpLH_CK_QN;
            elsif E = '1' then
                Q <= D after tpLH_CK_Q;
                QN <= not D after tpHL_CK_QN;
            end if;
        end if;
    end process;
end Comportament;
