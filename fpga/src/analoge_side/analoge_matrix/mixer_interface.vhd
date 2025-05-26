--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|      
-- Created by: Rob D Jordan
-- Create Date: 12.09.2023 14:52:58
-- Design Name: 
-- Module Name: mixer_interface - Behavioral

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library work;
use work.array_pck.all;


entity mixer_interface is

  Port ( 
    clk      :in    STD_LOGIC;
    rst      :in    STD_LOGIC;
    wr       :in    STD_LOGIC;
    out_addr     :in    integer;
    ch_addr      :in    integer;
    gain_in  :in    STD_LOGIC; -- 1= mute 0 = unmuted
    mixer_inputs : in array_12(10 downto 0);
    outputs : out array_12(19 downto 0)  

  );
end mixer_interface;

architecture Behavioral of mixer_interface is

    signal mutes        : array_10(9 downto 0);

begin

process (clk) is
begin
    if rising_edge (clk) then
        if wr = '1' then
           case out_addr is
            when 0 =>
               mutes(ch_addr) <= gain_in;
            when 1 =>
               mutes(ch_addr) <= gain_in;
            when 2 =>
               mutes(ch_addr) <= gain_in;
            when 3 =>
               mutes(ch_addr) <= gain_in;
            when 4 =>
               mutes(ch_addr) <= gain_in;
            when 5 =>
               mutes(ch_addr) <= gain_in;
            when 6 =>
               mutes(ch_addr) <= gain_in;
            when 7 =>
               mutes(ch_addr) <= gain_in;
            when 8 =>
               mutes(ch_addr) <= gain_in;
            when 9 =>
               mutes(ch_addr) <= gain_in;
            when 10 =>
                mutes(ch_addr) <= gain_in;
            when 11 =>
                mutes(ch_addr) <= gain_in;
            when 12 =>
                mutes(ch_addr) <= gain_in;
            when 13 =>
                mutes(ch_addr) <= gain_in;
            when 14 =>
                mutes(ch_addr) <= gain_in;
            when 15 =>
                mutes(ch_addr) <= gain_in;
            when 16 =>
                mutes(ch_addr) <= gain_in;
            when 17 =>
                mutes(ch_addr) <= gain_in;
            when 18 =>
                mutes(ch_addr) <= gain_in;
            when 19 =>
                mutes(ch_addr) <= gain_in;
            when others => -- 'U', 'X', '-', etc.
                mutes(ch_addr) <= (others => '0');
        end case;
        
        elsif rst = '1' then -- on reset all inputs are muted (all pins in matrix removed)
             mutes <= (others => (others => '1'));
       end if;
    
    end if;
end process;

analog_matrix: entity work.analog_matrix
        port map (
            clk           => clk,
            mixer_inputs  => mixer_inputs,
            mutes         => mutes,
            outputs       => outputs
       );


end Behavioral;
