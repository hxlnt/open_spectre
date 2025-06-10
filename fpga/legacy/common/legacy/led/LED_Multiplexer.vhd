
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Created by: RD Jordan
-- Created: 2023
-- Description: LED multiplexer based on example from FPGA4U
-- Note: probaly not going to be used in final design, Shift reg run from micro blaze/reg file is probably a better bet
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LED_Multiplexer is
    generic (
        ROWS    : integer := 8;  -- Number of rows
        COLUMNS : integer := 8   -- Number of columns
    );
    port (
        clk       : in  std_logic;
        data_in   : in  std_logic_vector(ROWS * COLUMNS - 1 downto 0);
        leds      : out std_logic_vector(COLUMNS - 1 downto 0);
        row       : out std_logic_vector(ROWS - 1 downto 0);
        col       : out std_logic_vector(COLUMNS - 1 downto 0)
    );
end entity LED_Multiplexer;

architecture Behavioral of LED_Multiplexer is
    signal row_counter    : integer range 0 to ROWS-1 := 0;
    signal col_counter    : integer range 0 to COLUMNS-1 := 0;
    signal led_index      : integer range 0 to ROWS * COLUMNS - 1 := 0;
    signal enable_mux     : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            -- Increment counters
            if enable_mux = '1' then
                col_counter <= col_counter + 1;
                if col_counter = COLUMNS-1 then
                    row_counter <= (row_counter + 1) mod ROWS;
                end if;
            end if;

            -- Update LED index
            led_index <= row_counter * COLUMNS + col_counter;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            -- Output LEDs based on data_in
            if led_index < ROWS * COLUMNS then
                leds <= data_in(led_index);
            end if;

            -- Output row and column
            row <= std_logic_vector(to_unsigned(row_counter, ROWS));
            col <= std_logic_vector(to_unsigned(col_counter, COLUMNS));

            -- Enable MUX
            if col_counter = COLUMNS-1 then
                enable_mux <= '1';
            else
                enable_mux <= '0';
            end if;
        end if;
    end process;
end architecture Behavioral;
