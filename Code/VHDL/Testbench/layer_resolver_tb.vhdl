library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

entity layer_resolver_tb is
end;

architecture bench of layer_resolver_tb is

  component layer_resolver
    generic (
      layer_count : integer range 0 to 16
    );
    port (
      clk         : in std_logic;
      reset       : in std_logic;
      address_in  : in std_logic_vector(8 downto 0);
      data_in     : in std_logic_vector(3 downto 0);
      load_in     : in std_logic;
      address_out : out std_logic_vector(4 downto 0);
      data_out    : out std_logic_vector(3 downto 0);
      load_out    : out std_logic
    );
  end component;

  -- Clock period
  constant clk_period : time := 5 ns;

  -- Ports
  signal clk         : std_logic;
  signal reset       : std_logic;
  signal address_in  : std_logic_vector(8 downto 0);
  signal data_in     : std_logic_vector(3 downto 0);
  signal load_in     : std_logic;
  signal address_out : std_logic_vector(4 downto 0);
  signal data_out    : std_logic_vector(3 downto 0);
  signal load_out    : std_logic;

begin

  layer_resolver_inst : layer_resolver
  generic map(
    layer_count => 1
  )
  port map(
    clk         => clk,
    reset       => reset,
    address_in  => address_in,
    data_in     => data_in,
    load_in     => load_in,
    address_out => address_out,
    data_out    => data_out,
    load_out    => load_out
  );

  -- simple clock mechanism
  clk_process : process
  begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
  end process clk_process;

  -- general module function test
  input_process : process
  begin
    -- assign default values
    address_in <= (others => 'Z');
    data_in    <= (others => 'Z');
    load_in    <= '0';
    -- trigger reset
    reset <= '1';
    wait for 1.5 * clk_period;
    reset <= '0';
    -- fire first address near limit (32), 2nd layer
    load_in    <= '1';
    address_in <= std_logic_vector(to_unsigned(32, address_in'length));
    data_in    <= std_logic_vector(to_unsigned(4, data_in'length));
    wait for clk_period;
    -- fire second address near limit (63)
    load_in    <= '1';
    address_in <= std_logic_vector(to_unsigned(63, address_in'length));
    data_in    <= std_logic_vector(to_unsigned(5, data_in'length));
    wait for clk_period;
    -- check the reset functionality
    reset <= '1';
    wait for 2 * clk_period;
    reset <= '0';
    stop;
  end process;

end;