-- VHDL 2008
-- 11 input unity gain mixer with mutes, all ins and outs are 12-bit
-- 6 cycle pipeline delay

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mixer_11_1 is
  port (
    clk     : in  std_logic;
    input_0 : in  std_logic_vector(11 downto 0);
    input_1 : in  std_logic_vector(11 downto 0);
    input_2 : in  std_logic_vector(11 downto 0);
    input_3 : in  std_logic_vector(11 downto 0);
    input_4 : in  std_logic_vector(11 downto 0);
    input_5 : in  std_logic_vector(11 downto 0);
    input_6 : in  std_logic_vector(11 downto 0);
    input_7 : in  std_logic_vector(11 downto 0);
    input_8 : in  std_logic_vector(11 downto 0);
    input_9 : in  std_logic_vector(11 downto 0);
    input_10: in  std_logic_vector(11 downto 0);

    mutes   : in  std_logic_vector(10 downto 0);  -- '0' = unmuted, '1' = muted

    mixed_out : out std_logic_vector(11 downto 0)
  );
end entity;
architecture pipelined of mixer_11_1 is

  type t_unsigned12_array is array (0 to 10) of unsigned(11 downto 0);
  type t_unsigned13_array is array (0 to 4) of unsigned(12 downto 0);
  type t_unsigned14_array is array (0 to 2) of unsigned(13 downto 0);

  signal a       : t_unsigned12_array;
  signal s1      : t_unsigned13_array;
  signal s2      : t_unsigned14_array;
  signal final_sum : unsigned(15 downto 0);
  signal mixed_reg : std_logic_vector(11 downto 0);

begin
  mixed_out <= mixed_reg;
  


  process(clk)
  begin
    if rising_edge(clk) then
    
     --stage 1 apply mute
      a(0)  <= (others => '0') when mutes(0) = '1' else unsigned(input_0);
      a(1)  <= (others => '0') when mutes(1) = '1' else unsigned(input_1);
      a(2)  <= (others => '0') when mutes(2) = '1' else unsigned(input_2);
      a(3)  <= (others => '0') when mutes(3) = '1' else unsigned(input_3);
      a(4)  <= (others => '0') when mutes(4) = '1' else unsigned(input_4);
      a(5)  <= (others => '0') when mutes(5) = '1' else unsigned(input_5);
      a(6)  <= (others => '0') when mutes(6) = '1' else unsigned(input_6);
      a(7)  <= (others => '0') when mutes(7) = '1' else unsigned(input_7);
      a(8)  <= (others => '0') when mutes(8) = '1' else unsigned(input_8);
      a(9)  <= (others => '0') when mutes(9) = '1' else unsigned(input_9);
      a(10) <= (others => '0') when mutes(10) = '1' else unsigned(input_10);


      -- Stage 2: pairwise sum (adds 2x 12-bit -> 13-bit)
      s1(0) <= resize(a(0), 13) + resize(a(1), 13);
      s1(1) <= resize(a(2), 13) + resize(a(3), 13);
      s1(2) <= resize(a(4), 13) + resize(a(5), 13);
      s1(3) <= resize(a(6), 13) + resize(a(7), 13);
      s1(4) <= resize(a(8), 13) + resize(a(9), 13);  -- 5 pairs, a(10) left out

      -- Stage 3: add partials with leftover
      s2(0) <= resize(s1(0), 14) + resize(s1(1), 14);
      s2(1) <= resize(s1(2), 14) + resize(s1(3), 14);
      s2(2) <= resize(s1(4), 14) + resize(a(10), 14);  -- combine with a(10)

      -- Final sum
      final_sum <= resize(s2(0), 16) + resize(s2(1), 16) + resize(s2(2), 16);

      -- Saturate to 12 bits
      if final_sum > to_unsigned(4095, 16) then
        mixed_reg <= std_logic_vector(to_unsigned(4095, 12));
      else
        mixed_reg <= std_logic_vector(final_sum(11 downto 0));
      end if;

    end if;
  end process;
end architecture;
