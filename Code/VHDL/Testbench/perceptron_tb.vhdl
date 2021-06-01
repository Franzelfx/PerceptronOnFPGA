library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

entity perceptron_tb is
end;

architecture bench of perceptron_tb is

  component perceptron
    generic (
      perceptron_id : integer range 0 to 16
    );
    port (
      reset        : in std_logic;
      dentrid_port : in std_logic_vector(15 downto 0);
      axon_port    : out std_logic;
      address      : in std_logic_vector(6 downto 0);
      data         : in std_logic_vector(3 downto 0);
      load         : in std_logic
    );
  end component;

  -- Clock period
  constant clk_period : time := 5 ns;

  -- Ports
  signal reset        : std_logic;
  signal dentrid_port : std_logic_vector(15 downto 0);
  signal axon_port    : std_logic;
  signal address      : std_logic_vector(6 downto 0);
  signal data         : std_logic_vector(3 downto 0);
  signal load         : std_logic;

begin

  perceptron_inst : perceptron
  generic map(
    perceptron_id => 0
  )
  port map(
    reset        => reset,
    dentrid_port => dentrid_port,
    axon_port    => axon_port,
    address      => address,
    data         => data,
    load         => load
  );

  check_beh : process
  begin
    -- default values
    reset        <= '0';
    dentrid_port <= (others => '0');
    address      <= (others => '0');
    data         <= (others => '0');
    load         <= '0';
    wait for clk_period;
    reset <= '1';
    wait for clk_period;
    reset <= '0';
    wait for clk_period;
    -- set activation value to 16
    address <= "0000000";
    wait for clk_period;
    data <= "1111";
    wait for clk_period;
    load <= '1';
    wait for clk_period;
    load <= '0';
    wait for clk_period;
    -- set a sensitivity value
    -- sens_1
    address <= "0000001";
    wait for clk_period;
    data <= "1111";
    wait for clk_period;
    load <= '1';
    wait for clk_period;
    load <= '0';
    wait for clk_period;
    -- sens_2
    address <= "0000010";
    wait for clk_period;
    data <= "1111";
    wait for clk_period;
    load <= '1';
    wait for clk_period;
    load <= '0';
    wait for clk_period;
    -- sens_3
    address <= "0000011";
    wait for clk_period;
    data <= "1111";
    wait for clk_period;
    load <= '1';
    wait for clk_period;
    load <= '0';
    wait for clk_period;
    -- sens_4
    address <= "0000100";
    wait for clk_period;
    data <= "1111";
    wait for clk_period;
    load <= '1';
    wait for clk_period;
    load <= '0';
    wait for clk_period;
    -- final load to set the sens value
    load <= '1';
    wait for clk_period;
    load <= '0';
    wait for clk_period;
    -- check the programmed values and output behaviour
    dentrid_port <= "1111111111111111";
    wait for 2 * clk_period;
    load <= '1';
    wait for clk_period;
    load <= '0';
    wait for clk_period;
    dentrid_port <= "1111111111111110";
    wait for 2 * clk_period;
    load <= '1';
    wait for clk_period;
    load <= '0';
    wait for clk_period;
    dentrid_port <= "1111111111111111";
    wait for 2 * clk_period;
    load <= '1';
    wait for clk_period;
    load <= '0';
    wait for clk_period;
    report "Simulation Stop";
    stop;
  end process;
end;