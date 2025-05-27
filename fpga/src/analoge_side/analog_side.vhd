--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|     
-- Create Date: 12.09.2023 16:43:19
-- Design Name: 
-- Module Name: analog_side - Behavioral
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library work;
use work.array_pck.all;

entity analog_side is
  port
  (

    clk      : in std_logic;
    rst      : in std_logic;
    wr       : in std_logic;
    vsync    : in std_logic;
    hsync    : in std_logic;
    out_addr : in std_logic_vector(7 downto 0);
    gain_out  : out std_logic_vector(15 downto 0);
    gain_in  : in std_logic_vector(15 downto 0);
    --analoge controls from reg file -- these should be added ot the matrix outputs so that you always have cxontroll of these things, these ins act as an offset
    pos_h_1       : in std_logic_vector(11 downto 0);
    pos_v_1       : in std_logic_vector(11 downto 0);
    zoom_h_1      : in std_logic_vector(11 downto 0);
    zoom_v_1      : in std_logic_vector(11 downto 0);
    circle_1      : in std_logic_vector(11 downto 0);
    gear_1        : in std_logic_vector(11 downto 0);
    lantern_1     : in std_logic_vector(11 downto 0);
    fizz_1        : in std_logic_vector(11 downto 0);
    pos_h_2       : in std_logic_vector(11 downto 0);
    pos_v_2       : in std_logic_vector(11 downto 0);
    zoom_h_2      : in std_logic_vector(11 downto 0);
    zoom_v_2      : in std_logic_vector(11 downto 0);
    circle_2      : in std_logic_vector(11 downto 0);
    gear_2        : in std_logic_vector(11 downto 0);
    lantern_2     : in std_logic_vector(11 downto 0);
    fizz_2        : in std_logic_vector(11 downto 0);
    --random
    noise_freq    : in std_logic_vector(9 downto 0);
    slew_in       : in std_logic_vector(2 downto 0);
    cycle_recycle : in std_logic;
    -- Video from the digital side
    YUV_in        : in std_logic_vector(23 downto 0);
    y_alpha       : in std_logic_vector(11 downto 0);
    u_alpha       : in std_logic_vector(11 downto 0);
    v_alpha       : in std_logic_vector(11 downto 0);
    
   audio_in_t   : in std_logic_vector(9 downto 0);
   audio_in_b   : in std_logic_vector(9 downto 0);
   audio_in_sig : in std_logic_vector(9 downto 0);
   
   --osc control
   sync_sel_osc1 : in STD_LOGIC_VECTOR(1 downto 0);
   osc_1_freq : in STD_LOGIC_VECTOR(9 downto 0);
   osc_1_derv : in STD_LOGIC_VECTOR(7 downto 0);
   sync_sel_osc2 : in STD_LOGIC_VECTOR(1 downto 0);
   osc_2_freq : in STD_LOGIC_VECTOR(9 downto 0);
   osc_2_derv : in STD_LOGIC_VECTOR(7 downto 0);
    --signals from the digital side
    dsm_hi_i       : in std_logic_vector(9 downto 0);
    dsm_lo_i       : in std_logic_vector(9 downto 0);
--    y_digital      : in std_logic_vector(11 downto 0);
--    u_digital      : in std_logic_vector(11 downto 0);
--    v_digital      : in std_logic_vector(11 downto 0);

    -- signals passed to the digital side (not in original design but i think they are cool)
    vid_span : out std_logic_vector(7 downto 0);
    osc_1_sqr_o : out std_logic;
    osc_2_sqr_o : out std_logic;
    noise_1_o : out std_logic;
    noise_2_o : out std_logic;
   -- Signals sent to the shape generator
   matrix_pos_h_1   : out std_logic_vector(11 downto 0);
   matrix_pos_v_1   : out std_logic_vector(11 downto 0);
   matrix_zoom_h_1  : out std_logic_vector(11 downto 0);
   matrix_zoom_v_1  : out std_logic_vector(11 downto 0);
   matrix_circle_1  : out std_logic_vector(11 downto 0);
   matrix_gear_1    : out std_logic_vector(11 downto 0);
   matrix_lantern_1 : out std_logic_vector(11 downto 0);
   matrix_fizz_1    : out std_logic_vector(11 downto 0);
   matrix_pos_h_2   : out std_logic_vector(11 downto 0);
   matrix_pos_v_2   : out std_logic_vector(11 downto 0);
   matrix_zoom_h_2  : out std_logic_vector(11 downto 0);
   matrix_zoom_v_2  : out std_logic_vector(11 downto 0);
   matrix_circle_2  : out std_logic_vector(11 downto 0);
   matrix_gear_2    : out std_logic_vector(11 downto 0);
   matrix_lantern_2 : out std_logic_vector(11 downto 0);
   matrix_fizz_2    : out std_logic_vector(11 downto 0);
    
    y_out    : out std_logic_vector(7 downto 0);
    u_out    : out std_logic_vector(7 downto 0);
    v_out    : out std_logic_vector(7 downto 0)
--    outputs_o      : out array_12(19 downto 0) -- 12-bit wide outputs

    

  );
end analog_side;

architecture Behavioral of analog_side is

  signal mixer_inputs : array_12(15 downto 0) := (others => (others => '0'));
  signal outputs      : array_12(19 downto 0); -- 12-bit wide outputs

  signal out_addr_int : integer;
  signal ch_addr_int  : integer;

  --matrix inputs
  signal osc1_out_sq  : std_logic_vector(11 downto 0);
  signal osc1_out_sin : std_logic_vector(11 downto 0);
  signal osc2_out_sq  : std_logic_vector(11 downto 0);
  signal osc2_out_sin : std_logic_vector(11 downto 0);
  signal noise_1      : std_logic_vector(9 downto 0);
  signal noise_2      : std_logic_vector(9 downto 0);

  --oscilator outputs
  signal osc1_out_sq_i  : std_logic;
  signal osc2_out_sq_i  : std_logic;

  -- analoge matrix yuv out
  signal y_anna : std_logic_vector(11 downto 0);
  signal u_anna : std_logic_vector(11 downto 0);
  signal v_anna : std_logic_vector(11 downto 0);

  signal y_signal1 : std_logic_vector(11 downto 0);
  signal u_signal1 : std_logic_vector(11 downto 0);
  signal v_signal1 : std_logic_vector(11 downto 0);
  signal y_signal2 : std_logic_vector(11 downto 0) := (others => '0');
  signal u_signal2 : std_logic_vector(11 downto 0) := (others => '0');
  signal v_signal2 : std_logic_vector(11 downto 0) := (others => '0');
  signal y_result : std_logic_vector(11 downto 0) := (others => '0');
  signal u_result : std_logic_vector(11 downto 0) := (others => '0');
  signal v_result : std_logic_vector(11 downto 0) := (others => '0');
  
   signal y_digital      :  std_logic_vector(11 downto 0);
   signal u_digital      :  std_logic_vector(11 downto 0);
   signal v_digital      :  std_logic_vector(11 downto 0);

  --shape gen mixed with register file inputs
  signal mixed_pos_h_1   : std_logic_vector(11 downto 0);
  signal mixed_pos_v_1   : std_logic_vector(11 downto 0);
  signal mixed_zoom_h_1  : std_logic_vector(11 downto 0);
  signal mixed_zoom_v_1  : std_logic_vector(11 downto 0);
  signal mixed_circle_1  : std_logic_vector(11 downto 0);
  signal mixed_gear_1    : std_logic_vector(11 downto 0);
  signal mixed_lantern_1 : std_logic_vector(11 downto 0);
  signal mixed_fizz_1    : std_logic_vector(11 downto 0);
  signal mixed_pos_h_2   : std_logic_vector(11 downto 0);
  signal mixed_pos_v_2   : std_logic_vector(11 downto 0);
  signal mixed_zoom_h_2  : std_logic_vector(11 downto 0);
  signal mixed_zoom_v_2  : std_logic_vector(11 downto 0);
  signal mixed_circle_2  : std_logic_vector(11 downto 0);
  signal mixed_gear_2    : std_logic_vector(11 downto 0);
  signal mixed_lantern_2 : std_logic_vector(11 downto 0);
  signal mixed_fizz_2    : std_logic_vector(11 downto 0);

begin

  --split incoming YUV data from the digital side to the 11 bit mixer
  y_digital <= YUV_in(23 downto 16) & "0000";
  u_digital <= YUV_in(15 downto 8) & "0000";
  v_digital <= YUV_in(7 downto 0) & "0000";

  out_addr_int <= to_integer(unsigned(out_addr));

  --analoge matrix inputs
  mixer_inputs(0)  <= osc1_out_sq;
  mixer_inputs(1)  <= osc1_out_sin;
  mixer_inputs(2)  <= osc2_out_sq;
  mixer_inputs(3)  <= osc2_out_sin ;
  mixer_inputs(4)  <= noise_1     & "00";
  mixer_inputs(5)  <= noise_2     & "00";
  mixer_inputs(6)  <= audio_in_t   & "00";
  mixer_inputs(7)  <= audio_in_b  & "00";
  mixer_inputs(8)  <= audio_in_sig & "00";
  mixer_inputs(9)  <= dsm_hi_i       & "00";
  mixer_inputs(10) <= dsm_lo_i     & "00";

 -- mixers for Shape Gen1
  pos_h_1_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => outputs(0),
  B => pos_h_1,
  SUM => mixed_pos_h_1
  );
  pos_v_1_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => outputs(1),
  B => pos_v_1,
  SUM => mixed_pos_v_1
  );
  zoom_h_1_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => outputs(2),
  B => zoom_h_1,
  SUM => mixed_zoom_h_1
  );
  zoom_v_1_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => outputs(3),
  B => zoom_v_1,
  SUM => mixed_zoom_v_1
  );
  circle_1_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => outputs(4),
  B => circle_1,
  SUM => mixed_circle_1
  );
  gear_1_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => outputs(5),
  B => gear_1,
  SUM => mixed_gear_1
  );
  lantern_1_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => outputs(6),
  B => lantern_1,
  SUM => mixed_lantern_1
  );
  fizz_1_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => outputs(8),
  B => fizz_1,
  SUM => mixed_fizz_1
  );
  
  -- Mixers for shape gen 2
   pos_h_2_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => outputs(8),
  B => pos_h_2,
  SUM => mixed_pos_h_2
  );
  pos_v_2_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => outputs(10),
  B => zoom_v_2,
  SUM => mixed_pos_v_2
  );
  zoom_h_2_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => outputs(11),
  B => zoom_h_2,
  SUM => mixed_zoom_h_2
  );
  zoom_v_2_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => outputs(12),
  B => pos_v_2,
  SUM => mixed_zoom_v_2
  );
  circle_2_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => outputs(13),
  B => circle_2,
  SUM => mixed_circle_2
  );
  gear_2_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => outputs(14),
  B => gear_2,
  SUM => mixed_gear_2
  );
  lantern_2_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => outputs(15),
  B => lantern_2,
  SUM => mixed_lantern_2
  );
  fizz_2_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => outputs(16),
  B => fizz_2,
  SUM => mixed_fizz_2
  );
  --analoge matrix outputs
  matrix_pos_h_1   <= mixed_pos_h_1;
  matrix_pos_v_1   <= mixed_pos_v_1;
  matrix_zoom_h_1  <= mixed_zoom_h_1;
  matrix_zoom_v_1  <= mixed_zoom_v_1;
  matrix_circle_1  <= mixed_circle_1;
  matrix_gear_1    <= mixed_gear_1;
  matrix_lantern_1 <= mixed_lantern_1;
  matrix_fizz_1    <= mixed_fizz_1;
  matrix_pos_h_2   <= mixed_pos_h_2;
  matrix_pos_v_2   <= mixed_pos_v_2;
  matrix_zoom_h_2  <= mixed_zoom_h_2;
  matrix_zoom_v_2  <= mixed_zoom_v_2;
  matrix_circle_2  <= mixed_circle_2;
  matrix_gear_2    <= mixed_gear_2;
  matrix_lantern_2 <= mixed_lantern_2;
  matrix_fizz_2    <= mixed_fizz_2;
  y_anna           <= outputs(16);
  u_anna           <= outputs(17);
  v_anna           <= outputs(18);
  vid_span         <= outputs(19)(11 downto 4); -- video span is only 8 bits
  
  analox_matrix : entity work.mixer_interface
    port map
    (
      clk          => clk,
      rst          => rst,
      wr           => wr,
      out_addr     => out_addr_int,
      gain_in      => not gain_in,
      gain_out     => gain_out,
      mixer_inputs => mixer_inputs,
      outputs      => outputs
    );

    osc1: entity work.SinWaveGenerator
        Port map(
        clk => clk,
        reset => rst,
        freq => osc_1_freq,
        sync_sel => sync_sel_osc1,
        sync_plus => vsync,
        sync_minus => hsync,
        dist_level => osc_1_derv,
        sin_out => osc1_out_sin,
        square_out => osc1_out_sq_i
        );
        
        osc1_out_sq <= (others => osc1_out_sq_i);
        
    osc2: entity work.SinWaveGenerator
        Port map(
        clk => clk,
        reset => rst,
        freq => osc_2_freq,
        sync_sel => sync_sel_osc2,
        sync_plus => vsync,
        sync_minus => hsync,
        dist_level => osc_2_derv,
        sin_out => osc2_out_sin,
        square_out => osc2_out_sq_i
        );
        
        osc2_out_sq <= (others => osc2_out_sq_i);

  random_1 : entity work.random_voltage
    port map (
    Clock      => clk,
    rst        => rst,
    recycle    => cycle_recycle,
    noise_freq => noise_freq,
    slew_in    => slew_in,
    noise_1    => noise_1,
    noise_2    => noise_2,
    extra_in    => vsync
    );


-------------Combine the YUV video form the digital matrix with the analoge matrix
  Y_dig_ann_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => y_anna,
  B => y_digital,
  SUM => y_signal1
  );
  U_dig_ann_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => u_anna,
  B => u_digital,
  SUM => u_signal1
  );  
  V_dig_ann_mix : entity work.Adder_12bit_NoOverflow 
  port map(
  A => v_anna,
  B => v_digital,
  SUM => v_signal1
  );
  
  ---------YUV levels are atenuators for the video signal levels 
  YUV_out_levels : entity work.YUV_levels
    port
    map(
    y_signal1 => y_signal1,
    y_signal2 => y_signal2,
    y_alpha   => y_alpha,
    y_result  => y_result,
    u_signal1 => u_signal1,
    u_signal2 => u_signal2,
    u_alpha   => u_alpha,
    u_result  => u_result,
    v_signal1 => v_signal1,
    v_signal2 => v_signal2,
    v_alpha   => v_alpha,
    v_result  => v_result
    );

  y_out <= y_result(11 downto 4);
  u_out <= u_result(11 downto 4);
  v_out <= v_result(11 downto 4);
--  outputs_o <= outputs;
osc_1_sqr_o <= osc1_out_sq_i;
osc_2_sqr_o <= osc2_out_sq_i;

noise_1_o <= noise_1(5);
noise_2_o <= noise_2(5);

end Behavioral;