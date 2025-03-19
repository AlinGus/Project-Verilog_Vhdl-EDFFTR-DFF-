library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TrafficLightSystem_tb is
-- Entitatea testbench nu are porturi
end TrafficLightSystem_tb;

architecture Behavioral of TrafficLightSystem_tb is
    -- Semnale interne pentru conectare
    signal CLK : STD_LOGIC := '0';
    signal RST : STD_LOGIC := '0';
    signal BTN : STD_LOGIC := '0';
    signal LIGHT_CARS : STD_LOGIC_VECTOR(2 downto 0);
    signal LIGHT_PEDESTRIANS : STD_LOGIC_VECTOR(1 downto 0);

    -- Perioada semnalului de ceas (1s)
    constant CLK_PERIOD : time := 1 sec;
begin
    -- Instan?ierea unit??ii de testat (DUT - Design Under Test)
    uut: entity work.TrafficLightSystem
        port map (
            CLK => CLK,
            RST => RST,
            BTN => BTN,
            LIGHT_CARS => LIGHT_CARS,
            LIGHT_PEDESTRIANS => LIGHT_PEDESTRIANS
        );

    -- Generarea semnalului de ceas
    CLK_process: process
    begin
        while true loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimuli pentru test
    Stimuli_process: process
    begin
        -- Reset activ timp de 2s
        RST <= '1';
        wait for 2 sec;
        RST <= '0';

        -- Ap?sare buton la 10s
        wait for 10 sec;
        BTN <= '1';
        wait for 1 sec;
        BTN <= '0'; -- Eliberare buton

        -- Ap?sare buton la 50s
        wait for 50 sec;
        BTN <= '1';
        wait for 1 sec;
        BTN <= '0'; -- Eliberare buton

        -- Finalizarea simul?rii dup? 100s
        wait for 100 sec;
        wait;
    end process;
end Behavioral;
