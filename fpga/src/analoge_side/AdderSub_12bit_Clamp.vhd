library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AdderSub_12bit_Clamp is
  Port ( 
    clk      : in std_logic;
    A        : in  STD_LOGIC_VECTOR(11 downto 0); -- unsigned
    B        : in  STD_LOGIC_VECTOR(11 downto 0); -- signed
    Sum      : out STD_LOGIC_VECTOR(11 downto 0);
    Overflow : out STD_LOGIC
  );
end AdderSub_12bit_Clamp;

architecture Behavioral of AdderSub_12bit_Clamp is
  signal A_u    : UNSIGNED(11 downto 0);
  signal B_s    : SIGNED(11 downto 0);
  signal Result : SIGNED(12 downto 0); -- 13-bit result to hold signed sum
  signal Clamped: UNSIGNED(11 downto 0);
begin

  A_u <= UNSIGNED(A);
  B_s <= SIGNED(B);

  -- Perform addition/subtraction with extended precision
  Result <= SIGNED('0' & A_u) + RESIZE(B_s, 13);

  process(Result)
  begin
    if Result < 0 then
      Clamped <= (others => '0');
      Overflow <= '1';
    elsif Result > to_signed(4095, 13) then
      Clamped <= (others => '1');
      Overflow <= '1';
    else
      Clamped <= UNSIGNED(Result(11 downto 0));
      Overflow <= '0';
    end if;


  end process;
  
    process(clk)
    begin
        if rising_edge(clk) then
            Sum <= STD_LOGIC_VECTOR(Clamped);
        end if;
    end process;

end Behavioral;
