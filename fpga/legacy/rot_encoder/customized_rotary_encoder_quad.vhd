--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Created: 20.05.2022 14:34:42 by RD JOrdan
-- Description: Rotery encoder
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
--  Typical rotary encoders output a quadrature encoded 2-bit signal as follows:
--
--  Clockwise motion:
--               ____      ____      ____      ____      ____
--  Signal A: __|    |____|    |____|    |____|    |____|     ...
--             ____      ____      ____      ____      ____
--  Signal B: |    |____|    |____|    |____|    |____|    |_ ...
--
--  Anti-Clockwise motion:
--             ____      ____      ____      ____      ____
--  Signal A: |    |____|    |____|    |____|    |____|    |_ ...
--               ____      ____      ____      ____      ____
--  Signal B: __|    |____|    |____|    |____|    |____|     ...

-- Source: https://forum.digikey.com/t/quadrature-decoder-vhdl/12671

-- OLD CODE:
-- module quad(clk, quadA, quadB, count);
-- input clk, quadA, quadB;
-- output [7:0] count;

-- reg [2:0] quadA_delayed, quadB_delayed;
-- always @(posedge clk) quadA_delayed <= {quadA_delayed[1:0], quadA};
-- always @(posedge clk) quadB_delayed <= {quadB_delayed[1:0], quadB};

-- wire count_enable = quadA_delayed[1] ^ quadA_delayed[2] ^ quadB_delayed[1] ^ quadB_delayed[2];
-- wire count_direction = quadA_delayed[1] ^ quadB_delayed[2];

-- reg [7:0] count;
-- always @(posedge clk)
-- begin
--   if(count_enable)
--   begin
--     if(count_direction) count<=count+1; else count<=count-1;
--   end
-- end

-- endmodule

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity customized_rotary_encoder_quad is
  generic (
    g_DATA_WIDTH : integer := 16
  );
  port (
    clk_i          : in  std_logic;
    swa_i          : in  std_logic;
    swb_i          : in  std_logic;
    rotary_event_o : out std_logic;
    rotary_dir_o   : out std_logic;                 -- '1': Left, '0' :Right 
    data_out_o     : out std_logic_vector(g_DATA_WIDTH-1 downto 0)
  );
end entity customized_rotary_encoder_quad;

architecture customized_rtl of customized_rotary_encoder_quad is  
  -- Output signals
  signal dir_d_custom     : std_logic := '0';
  signal reg_swa_custom, reg_swb_custom : std_logic_vector(2 downto 0) := "000";
  signal count_enable, count_direction, count_direction_d : std_logic                                   := '0';

  signal count_int_custom : std_logic_vector(g_DATA_WIDTH-1 downto 0) := (others => '0');

begin

  -- Main process for rotary encoder
  enc_p_custom : process (clk_i)
  begin
    if rising_edge(clk_i) then
	  -- Shift and update register values, helps with metastability
	  reg_swa_custom <= reg_swa_custom(1 downto 0) & swa_i;
	  reg_swb_custom <= reg_swb_custom(1 downto 0) & swb_i;

    count_enable      <= reg_swa_custom(1) xor reg_swa_custom(2) xor reg_swb_custom(1) xor reg_swb_custom(2);
    count_direction   <= reg_swa_custom(1) xor reg_swb_custom(2);
    count_direction_d <= count_direction;

     
      -- Process the encoder output and update counters
      if (count_enable = '1') then -- Valid event
          rotary_dir_o <= count_direction;
          rotary_event_o <= '1';
          if (count_direction = '1') then
            count_int_custom <= count_int_custom + 1;
          else
            count_int_custom <= count_int_custom - 1;
          end if;
        else
          rotary_event_o <= '0';
        end if;
    end if;
  end process enc_p_custom;

  -- Output the count value
  data_out_o <= count_int_custom;

end architecture customized_rtl;
