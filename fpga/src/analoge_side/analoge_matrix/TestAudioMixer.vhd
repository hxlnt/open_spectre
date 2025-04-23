--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|      
-- Create Date: 2023
-- Created by: Rob D Jordan
-- Notes: 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;
library work;
use work.array_pck.all;

entity TestAudioMixer is
end TestAudioMixer;

architecture sim of TestAudioMixer is
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal inputs : array_12(9 downto 0);
    signal gains : array_5(9 downto 0);
    signal output : STD_LOGIC_VECTOR(11 downto 0);
    constant CLOCK_PERIOD : time := 10 ns;
    

begin
    -- Instantiate the DUT (Design Under Test)
    uut : entity work.AudioMixer
        Port Map (
            clk => clk,
            reset => reset,
            inputs => inputs,
            gains => gains,
            output => output
        );

    -- Clock process
    clk_process : process
    begin
        while now < 1000 ns loop
            clk <= not clk;
            wait for CLOCK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_process : process
    begin
        wait for 20 ns; -- Wait for initial stability

        -- Test 1: All inputs at maximum, no gains
        inputs <= (others => "111111111111");
        gains <= (others => "00000");
        reset <= '0';
        wait for 10 ns;
        assert output = "000000000001" report "Test 1 failed" severity error;

        -- Test 2: All inputs at maximum, all gains at maximum
        gains <= (others => "11111");
        wait for 10 ns;
        assert output = "011111111111" report "Test 2 failed" severity error;

        -- Test 3: Varying inputs and gains
        inputs <= (others => "000001100000");
        gains <= (others => "00100"); -- Gain 0 set to 2
        wait for 10 ns;
        assert output = "000001100000" report "Test 3 failed" severity error;

        -- You can add more tests here
        
        -- Finish the simulation
        wait;
    end process;
end sim;
