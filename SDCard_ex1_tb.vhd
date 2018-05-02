----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2018 10:02:50 AM
-- Design Name: 
-- Module Name: SDCard_ex1_tb - bench
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


library IEEE, work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.SdCardPckg.all;
use work.CommonPckg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SdCardCtrl_tb is
end;

architecture bench of SdCardCtrl_tb is
  component SdCardCtrl is
  generic (
    FREQ_G          : real       := 100.0;
    INIT_SPI_FREQ_G : real       := 0.4;
    SPI_FREQ_G      : real       := 25.0;
    BLOCK_SIZE_G    : natural    := 512;
    CARD_TYPE_G     : CardType_t := SD_CARD_E
    );
  port (
    clk_i      : in  std_logic;
    reset_i    : in  std_logic                     := '0';
    rd_i       : in  std_logic                     := '0';
    wr_i       : in  std_logic                     := '0';
    continue_i : in  std_logic                     := '0';
    addr_i     : in  std_logic_vector(31 downto 0) := x"00000000";
    data_i     : in  std_logic_vector(7 downto 0)  := x"00";
    data_o     : out std_logic_vector(7 downto 0)  := x"00";
    busy_o     : out std_logic;
    hndShk_i   : in  std_logic;
    hndShk_o   : out std_logic;
    error_o    : out std_logic_vector(15 downto 0) := (others => '0');
    cs_bo      : out std_logic                     := '1';
    sclk_o     : out std_logic                     := '0';
    mosi_o     : out std_logic                     := '1';
    miso_i     : in  std_logic                     := '0'
    );
end component;

signal clk_i: std_logic;
signal reset_i: std_logic := '0';
signal rd_i: std_logic := '0';
signal wr_i: std_logic := '0';
signal continue_i: std_logic := '0';
signal addr_i: std_logic_vector(31 downto 0) := x"00000000";
signal data_i: std_logic_vector(7 downto 0) := x"00";
signal data_o: std_logic_vector(7 downto 0) := x"00";
signal busy_o: std_logic;
signal hndShk_i: std_logic;
signal hndShk_o: std_logic;
signal error_o: std_logic_vector(15 downto 0) := (others => '0');
signal cs_bo: std_logic := '1';
signal sclk_o: std_logic := '0';
signal mosi_o: std_logic := '1';
signal miso_i: std_logic := '0' ;

constant clock_period: time := 10 ns;
signal stop_the_clock: boolean;

begin
  -- Insert values for generic parameters !!
uut: SdCardCtrl generic map ( FREQ_G          => 100.0,
                              INIT_SPI_FREQ_G => 0.4,
                              SPI_FREQ_G      => 25.0,
                              BLOCK_SIZE_G    => 512,
                              CARD_TYPE_G     =>  SD_CARD_E)
                   port map ( clk_i           => clk_i,
                              reset_i         => reset_i,
                              rd_i            => rd_i,
                              wr_i            => wr_i,
                              continue_i      => continue_i,
                              addr_i          => addr_i,
                              data_i          => data_i,
                              data_o          => data_o,
                              busy_o          => busy_o,
                              hndShk_i        => hndShk_i,
                              hndShk_o        => hndShk_o,
                              error_o         => error_o,
                              cs_bo           => cs_bo,
                              sclk_o          => sclk_o,
                              mosi_o          => mosi_o,
                              miso_i          => miso_i );

-- Handshake process
hndShk_proc: process(hndShk_o)
begin
  hndShk_i <= hndShk_o;
end process;

stimulus: process
variable randn : real := 0.5;
variable seed1: positive := 1;
variable seed2: positive := 1;
begin

  -- Put initialisation code here
-- hold reset state for 100 ns.
  addr_i <= x"A5A55A5A";
  rd_i <= '0';
  wr_i <= '0';
  continue_i <= '0';
  data_i <= x"01";
  miso_i <= '0';
  reset_i <= '1';
  wait for 100 ns;
  reset_i <= '0';
  wait for 520us;
  wait until mosi_o = '0';
  wait until sclk_o = '1';
  miso_i <= '0';

  wait for 22.5us;
  miso_i <= '1'; 
  wait for 2.5us; 
  miso_i <= '0'; 
  wait until busy_o = '0';
        
  wr_i <= '1';
  wait until busy_o = '1';
  continue_i <= '1';
        
  for i in 0 to 4 loop
      data_i <= std_logic_vector(to_unsigned(2*i,4)) & std_logic_vector(to_unsigned(2*i+1,4));
  wait until hndShk_o = '1';
  end loop;  
  for i in 0 to 40 loop
    wait until sclk_o = '0';
  end loop;
  miso_i <= '1';
  wait until sclk_o = '0';
  miso_i <= '0';
        
  for i in 0 to 4 loop
      data_i <= std_logic_vector(to_unsigned(3*i,4)) & std_logic_vector(to_unsigned(3*i+1,4));
      wait until hndShk_o = '1';
      continue_i <= '0';
      wr_i <= '0';
  end loop;
        
  for i in 0 to 40 loop
      wait until sclk_o = '0';
  end loop;
  miso_i <= '1';
      
  wait until busy_o = '0';
        
  rd_i <= '1';
  wait until busy_o = '1';
  continue_i <= '1';
        
  for i in 0 to 1000 loop
       UNIFORM(seed1,seed2,randn);
      if integer(randn) = 1 then
          miso_i <= '1';
      else
          miso_i <= '0';
      end if;
      wait until sclk_o = '0';
   end loop;
  -- Put test bench stimulus code here

  --stop_the_clock <= true;
  wait;
end process;


clocking: process
begin
  while not stop_the_clock loop
    clk_i <= '0', '1' after clock_period / 2;
    wait for clock_period;
  end loop;
  wait;
end process;


end bench;
