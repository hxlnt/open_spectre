library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AdderSub_12bit_Clamp is
  Port ( 
    A        : in  STD_LOGIC_VECTOR(11 downto 0); -- unsigned
    B        : in  STD_LOGIC_VECTOR(11 downto 0); -- signed
    Sum      : out STD_LOGIC_VECTOR(11 downto 0);
    Overflow : out STD_LOGIC                     -- High on overflow or underflow
  );
end AdderSub_12bit_Clamp;

architecture Behavioral of AdderSub_12bit_Clamp is
  signal A_unsigned  : UNSIGNED(11 downto 0);
  signal B_signed    : SIGNED(11 downto 0);
  signal Result      : SIGNED(12 downto 0);  -- One extra bit for overflow detection
  signal Clamped     : UNSIGNED(11 downto 0);
begin

  A_unsigned <= UNSIGNED(A);
  B_signed   <= SIGNED(B);

  -- Extend A and B and compute result
  Result <= SIGNED('0' & A_unsigned) + RESIZE(B_signed, 13);

  process(Result)
  begin
    if Result < 0 then
      Clamped <= (others => '0');
      Overflow <= '1';
    elsif Result > 4095 then
      Clamped <= (others => '1');
      Overflow <= '1';
    else
      Clamped <= UNSIGNED(Result(11 downto 0));
      Overflow <= '0';
    end if;

    Sum <= STD_LOGIC_VECTOR(Clamped);
  end process;

end Behavioral;
