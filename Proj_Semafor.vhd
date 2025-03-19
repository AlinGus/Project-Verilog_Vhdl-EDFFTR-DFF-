library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TrafficLightSystem is
    Port (
        CLK : in STD_LOGIC;                       -- Semnal de ceas
        RST : in STD_LOGIC;                       -- Reset asincron
        BTN : in STD_LOGIC;                       -- Buton pentru pietoni
        LIGHT_CARS : out STD_LOGIC_VECTOR(2 downto 0); -- Semafor ma?ini (3 LED-uri)
        LIGHT_PEDESTRIANS : out STD_LOGIC_VECTOR(1 downto 0) -- Semafor pietoni (2 LED-uri)
    );
end TrafficLightSystem;

architecture Behavioral of TrafficLightSystem is
    -- Definirea st?rilor FSM
    type state_type is (S0, S1, S2, S3);
    signal current_state, next_state : state_type;

    -- Contor pentru timp
    signal timer : integer := 0;

    -- Constante pentru timpi
    constant T_GREEN_CARS : integer := 30;   -- 30 secunde pentru verde ma?ini
    constant T_YELLOW_CARS : integer := 5;   -- 5 secunde pentru galben ma?ini
    constant T_GREEN_PEDESTRIANS : integer := 10; -- 10 secunde pentru verde pietoni
    constant T_FLASH_PEDESTRIANS : integer := 5;  -- 5 secunde pentru verde intermitent
begin
    -- Proces pentru FSM
    process(CLK, RST)
    begin
        if RST = '1' then
            current_state <= S0;    -- Reset la starea ini?ial?
            timer <= 0;
        elsif rising_edge(CLK) then
            current_state <= next_state;

            -- Contor pentru timp
            if current_state = next_state then
                timer <= timer + 1;
            else
                timer <= 0;
            end if;
        end if;
    end process;

    -- Proces pentru tranzi?iile FSM
    process(current_state, BTN, timer)
    begin
        case current_state is
            when S0 =>
                -- Verde pentru ma?ini, ro?u pentru pietoni
                LIGHT_CARS <= "100";           -- Verde
                LIGHT_PEDESTRIANS <= "01";     -- Ro?u
                if BTN = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;

            when S1 =>
                -- Galben pentru ma?ini
                LIGHT_CARS <= "010";           -- Galben
                LIGHT_PEDESTRIANS <= "01";     -- Ro?u
                if timer >= T_YELLOW_CARS then
                    next_state <= S2;
                else
                    next_state <= S1;
                end if;

            when S2 =>
                -- Ro?u pentru ma?ini, verde pentru pietoni
                LIGHT_CARS <= "001";           -- Ro?u
                LIGHT_PEDESTRIANS <= "10";     -- Verde
                if timer >= T_GREEN_PEDESTRIANS then
                    next_state <= S3;
                else
                    next_state <= S2;
                end if;

            when S3 =>
                -- Ro?u pentru ma?ini, verde intermitent pentru pietoni
                LIGHT_CARS <= "001";           -- Ro?u
                if (timer mod 2) = 0 then
                    LIGHT_PEDESTRIANS <= "10"; -- Verde
                else
                    LIGHT_PEDESTRIANS <= "00"; -- Stins
                end if;
                if timer >= T_FLASH_PEDESTRIANS then
                    next_state <= S0;
                else
                    next_state <= S3;
                end if;

            when others =>
                next_state <= S0;
        end case;
    end process;
end Behavioral;
