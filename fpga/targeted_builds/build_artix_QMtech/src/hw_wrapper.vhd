----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.07.2024 11:40:19
-- Design Name: 
-- Module Name: hw_wrapper - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hw_wrapper is
  Port ( 
    clk  : in std_logic;
    rst  : in std_logic;
    -- rotery io
    rot_enc_addr  : in std_logic_vector(3 downto 0); -- rot enc address mux, driven by reg file
    rot_encA  : in std_logic_vector(5 downto 0);
    rot_encB  : in std_logic_vector(5 downto 0);
    rot_reg_0 : out std_logic_vector(47 downto 0);
    rot_reg_1 : out std_logic_vector(47 downto 0);
    rot_reg_2 : out std_logic_vector(47 downto 0);
    rot_reg_3 : out std_logic_vector(47 downto 0);
    rot_reg_4 : out std_logic_vector(47 downto 0);
    -- Button io
    columns         : in std_logic_vector(6 - 1 downto 0);
    rows            : out std_logic_vector(5 - 1 downto 0);
    button_state    : out std_logic_vector(32 - 1 downto 0);
    button_event    : out std_logic_vector(32 - 1 downto 0)
  
  );
end hw_wrapper;

architecture Behavioral of hw_wrapper is

  constant g_NUM_KEY_ROWS    : integer := 5;
  constant g_NUM_KEY_COLUMNS : integer := 6;
  constant g_NUM_ROT         : integer := 5;

--  signal rst : std_logic := '0';
--  signal rst_n : std_logic := '1';

  -- buttons
  signal debounce_strobe_i : std_logic := '1'; --should be a 10ms strobe
  signal columns_i         : std_logic_vector(g_NUM_KEY_COLUMNS - 1 downto 0);
  signal rows_o            : std_logic_vector(g_NUM_KEY_ROWS - 1 downto 0);
  signal button_state_o    : std_logic_vector(g_NUM_KEY_COLUMNS * g_NUM_KEY_ROWS - 1 downto 0);
  signal button_event_o    : std_logic_vector(g_NUM_KEY_COLUMNS * g_NUM_KEY_ROWS - 1 downto 0);

  -- rotery encoders
  signal rotary_event_o : std_logic_vector(g_NUM_ROT - 1 downto 0); -- rotery events for all roter encoders to use for interupts
  signal input_addr     : std_logic_vector(4 - 1 downto 0); -- the address of which register the roterys whould write to from their personal register bank

  signal step_size : std_logic := '1'; --rotery encoder step size is 4, hook up so there is a way to control this  
  signal sw_a      : std_logic_vector(g_NUM_ROT - 1 downto 0);
  signal sw_b      : std_logic_vector(g_NUM_ROT - 1 downto 0);
  type output_rot_a is array (0 to 5 - 1) of std_logic_vector(47 downto 0); -- each of these 0,1,2,3,4 represetn all 4 registers for each rotery as one long vector
  signal output_regs_rot : output_rot_a;

  attribute keep : string;
  -- attribute keep of rotary_event_o : signal is "true";
  attribute keep of output_regs_rot : signal is "true";

begin

-- Input assignements
sw_a <= rot_encA;
sw_b <= rot_encB;
input_addr <= rot_enc_addr;
columns_i <= columns;



  debounced_button_decoder_inst : entity work.debounced_button_decoder
    generic
    map (
    g_NUM_KEY_ROWS    => g_NUM_KEY_ROWS,
    g_NUM_KEY_COLUMNS => g_NUM_KEY_COLUMNS
    )
    port map
    (
      reset_n           =>  '1',
      clock_i           => clk,
      debounce_strobe_i => debounce_strobe_i,
      columns_i         => columns_i,
      rows_o            => rows_o,
      button_state_o    => button_state_o,
      button_event_o    => button_event_o
    );


  g_GENERATE_ROT : for ii in 0 to g_NUM_ROT-1 generate
    rot_reg_inst : entity work.rot_reg
      port
      map (
      sw_a          => sw_a(ii),
      sw_b          => sw_b(ii),
      step_size     => step_size,
      input_addr    => input_addr,
      rst           => rst,
      clk           => clk,
      output_regs_o => output_regs_rot(ii),
      rotary_event_o => rotary_event_o(ii)
      );
  end generate g_GENERATE_ROT;

-- Output assign
 rows <= rows_o;
 button_state <= "00" & button_state_o;  
 button_event <= "00" & button_event_o;
 rot_reg_0 <= output_regs_rot(0);
 rot_reg_1 <= output_regs_rot(1);
 rot_reg_2 <= output_regs_rot(2);
 rot_reg_3 <= output_regs_rot(3);
 rot_reg_4 <= output_regs_rot(4);

end Behavioral;