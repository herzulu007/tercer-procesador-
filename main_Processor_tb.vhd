
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY main_Processor_tb IS
END main_Processor_tb;
 
ARCHITECTURE behavior OF main_Processor_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT main_Processor
    PORT(
         CLK : IN  std_logic;
         reset : IN  std_logic;
         ALU_RESULT : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal ALU_RESULT : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: main_Processor PORT MAP (
          CLK => CLK,
          reset => reset,
          ALU_RESULT => ALU_RESULT
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      reset <= '1';
      wait for 100 ns;
		reset <= '0';
		wait for 500 ns;
      wait;
   end process;

END;
