--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: 
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-

-- created by   :   RD Jordan
-- Module Name: matrix_w_vio - Behavioral



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity matrix_w_vio is
    Port ( clk : in STD_LOGIC);
end matrix_w_vio;

architecture Behavioral of matrix_w_vio is

component  vio_0 
port(
clk : in STD_LOGIC;
probe_in0 : in STD_LOGIC_VECTOR (63 downto 0);
probe_out0 : out STD_LOGIC_VECTOR (63 downto 0);
probe_out1 : out STD_LOGIC_VECTOR (63 downto 0);
probe_out2 : out STD_LOGIC_VECTOR (0 downto 0);
probe_out3 : out STD_LOGIC_VECTOR (5 downto 0)
);
end component;

signal probe_in0 :  STD_LOGIC_VECTOR (63 downto 0);
signal probe_out0 :  STD_LOGIC_VECTOR (63 downto 0);
signal probe_out1 :  STD_LOGIC_VECTOR (63 downto 0);
signal probe_out2 :  STD_LOGIC_VECTOR (0 downto 0);
signal probe_out3 :  STD_LOGIC_VECTOR (5 downto 0);

begin

vio_1: vio_0 
port map(
clk => clk,
probe_in0 => probe_in0,
probe_out0 => probe_out0,
probe_out1 => probe_out1,
probe_out2 => probe_out2,
probe_out3 => probe_out3
);

test_matrix : entity work.or_matrix_full
    Port map ( input => probe_out0,
           clk => clk,
           mask => probe_out1,
           mask_en => probe_out2(0),
           mask_addr => probe_out3,
           output => probe_in0
           );

end Behavioral;
