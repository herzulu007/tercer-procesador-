
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RF is
    Port ( rs1 : in  STD_LOGIC_VECTOR (5 downto 0);--Register Source 1
           rs2 : in  STD_LOGIC_VECTOR (5 downto 0);--Register Source 2
           rd : in  STD_LOGIC_VECTOR (5 downto 0);--Register Destination
			  write_enabler: in STD_LOGIC;--Enabler to write
           dwr : in  STD_LOGIC_VECTOR (31 downto 0);--Data to write
           CRs1 : out  STD_LOGIC_VECTOR (31 downto 0);-- Content Register Source 1
           CRs2 : out  STD_LOGIC_VECTOR (31 downto 0);-- Content Register Source 2
			  CRd : out STD_LOGIC_VECTOR (31 downto 0); -- Content Register Destination
			  clk: in STD_LOGIC
			  );
end RF;

architecture Behavioral of RF is

type ram_type is array (0 to 39) of std_logic_vector (31 downto 0);
signal registers : ram_type :=(others => x"00000000");

begin
process(clk,dwr)
begin
	if(rising_edge(clk))then
		if(write_enabler = '1' and rd /= "000000")then --Si esta habilitado para escribir
			registers(conv_integer(rd)) <= dwr; --Escribe en el registro de destino
		end if;
	end if;
end process;
CRs1 <= registers(conv_integer(rs1));
CRs2 <= registers(conv_integer(rs2));
CRd <= registers(conv_integer(rd));
end Behavioral;

