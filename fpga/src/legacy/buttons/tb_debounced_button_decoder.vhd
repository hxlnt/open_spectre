--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|     
-- Create Date: oct 2024 RDJordan
-- Design Name: 
-- Module Name: TB for button debouncer/key scanner

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_debounced_button_decoder is
end tb_debounced_button_decoder;

architecture behavior of tb_debounced_button_decoder is

    -- Parameters for the test
    constant g_NUM_KEY_ROWS    : integer := 5;
    constant g_NUM_KEY_COLUMNS : integer := 6;

    -- Signals for connecting to the DUT
    signal reset_n           : std_logic;
    signal clock_i, clr_event           : std_logic;
    signal debounce_strobe_i : std_logic;
    signal columns_i         : std_logic_vector(g_NUM_KEY_COLUMNS-1 downto 0);
    signal rows_o            : std_logic_vector(g_NUM_KEY_ROWS-1 downto 0);
    signal button_state_o    : std_logic_vector(g_NUM_KEY_COLUMNS * g_NUM_KEY_ROWS-1 downto 0);
    signal button_event_o    : std_logic_vector(g_NUM_KEY_COLUMNS * g_NUM_KEY_ROWS-1 downto 0);

    -- Clock period
    constant clk_period : time := 20 ns;

begin

    -- Instantiate the DUT (Device Under Test)
    uut: entity work.debounced_button_decoder
        generic map (
            g_NUM_KEY_ROWS    => g_NUM_KEY_ROWS,
            g_NUM_KEY_COLUMNS => g_NUM_KEY_COLUMNS
        )
        port map (
            reset_n           => reset_n,
            clock_i           => clock_i,
            clr_event         => clr_event,
            debounce_strobe_i => debounce_strobe_i,
            columns_i         => columns_i,
            rows_o            => rows_o,
            button_state_o    => button_state_o,
            button_event_o    => button_event_o
        );

    -- Clock generation process
    clk_process : process
    begin
        clock_i <= '0';
        wait for clk_period / 2;
        clock_i <= '1';
        wait for clk_period / 2;
    end process;
    
     debounce_process : process
    begin
        debounce_strobe_i <= '0';
        wait for clk_period * 20;
        debounce_strobe_i <= '1';
        wait for clk_period * 20;
    end process;

    -- Test stimulus
    stimulus_process: process
    begin
        -- Initialize signals
        reset_n <= '0';
        clr_event <= '0';
--        debounce_strobe_i <= '0';
        columns_i <= (others => '0');  -- No button pressed (default is '1' for unpressed)
        
        wait for 100 ns;
        
        -- Release reset
        reset_n <= '1';
        columns_i(0) <= '0';  -- Release column 0
        wait for 100 ns;
        
        -- Simulate button press on row 1, column 1
        columns_i(0) <= '1';  -- Simulate column 0 being pressed
        wait for 1 Us;
        columns_i(0) <= '0';  -- Release column 0

        -- Simulate debounce strobe
--        debounce_strobe_i <= '1';
--        wait for 50 ns;
--        debounce_strobe_i <= '0';

        -- Add more button press simulations as needed
        wait for 200 ns;

        
        -- Finish simulation
        wait;
    end process;

end behavior;
