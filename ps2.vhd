LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ps2 is
	port( 	keyboard_clk, keyboard_data, clock_50MHz ,
			reset : in std_logic;--, read : in std_logic;
			scan_code : out std_logic_vector( 7 downto 0 );
			scan_readyo : out std_logic;
			hist3 : out std_logic_vector(7 downto 0);
			hist2 : out std_logic_vector(7 downto 0);
			hist1 : out std_logic_vector(7 downto 0);
			hist0 : out std_logic_vector(7 downto 0);
			HEX7  : out std_logic_vector(6 downto 0);
			HEX6  : out std_logic_vector(6 downto 0);
			HEX5  : out std_logic_vector(6 downto 0);
			HEX4  : out std_logic_vector(6 downto 0);
			HEX3  : out std_logic_vector(6 downto 0);
			HEX2  : out std_logic_vector(6 downto 0);
			HEX1  : out std_logic_vector(6 downto 0);
			HEX0  : out std_logic_vector(6 downto 0)
		);
end entity ps2;

architecture structural of ps2 is

component keyboard IS
	PORT( 	keyboard_clk, keyboard_data, clock_50MHz ,
			reset, read : IN STD_LOGIC;
			scan_code : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			scan_ready : OUT STD_LOGIC);
end component keyboard;

component oneshot is
port(
	pulse_out : out std_logic;
	trigger_in : in std_logic; 
	clk: in std_logic );
end component oneshot;

component leddcd is
	port(
		 data_in : in std_logic_vector(3 downto 0);
		 segments_out : out std_logic_vector(6 downto 0)
		);
end component leddcd;	


signal scan2 : std_logic;
signal scan_code2 : std_logic_vector( 7 downto 0 );
signal history3 : std_logic_vector(7 downto 0);
signal history2 : std_logic_vector(7 downto 0);
signal history1 : std_logic_vector(7 downto 0);
signal history0 : std_logic_vector(7 downto 0);
signal read : std_logic;

begin

u1: keyboard port map(	
				keyboard_clk => keyboard_clk,
				keyboard_data => keyboard_data,
				clock_50MHz => clock_50MHz,
				reset => reset,
				read => read,
				scan_code => scan_code2,
				scan_ready => scan2
			);

pulser: oneshot port map(
   pulse_out => read,
   trigger_in => scan2,
   clk => clock_50MHz
			);

-- my code
com_led7: leddcd port map(data_in => history3(7 downto 4), segments_out => HEX7);
com_led6: leddcd port map(data_in => history3(3 downto 0), segments_out => HEX6);  
com_led5: leddcd port map(data_in => history2(7 downto 4), segments_out => HEX5); 
com_led4: leddcd port map(data_in => history2(3 downto 0), segments_out => HEX4);    
com_led3: leddcd port map(data_in => history1(7 downto 4), segments_out => HEX3); 
com_led2: leddcd port map(data_in => history1(3 downto 0), segments_out => HEX2);      
com_led1: leddcd port map(data_in => history0(7 downto 4), segments_out => HEX1);
com_led0: leddcd port map(data_in => history0(3 downto 0), segments_out => HEX0); 

scan_readyo <= scan2;
scan_code <= scan_code2;

hist0<=history0;
hist1<=history1;
hist2<=history2;
hist3<=history3;

a1 : process(scan2)
begin
	if(rising_edge(scan2)) then
	history3 <= history2;
	history2 <= history1;
	history1 <= history0;
	history0 <= scan_code2;
	end if;
end process a1;


end architecture structural;