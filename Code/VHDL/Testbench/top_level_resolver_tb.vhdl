library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

entity top_level_resolver_tb is
end;

architecture bench of top_level_resolver_tb is

  component top_level_resolver
    port (
      clk                 : in std_logic;
      reset               : in std_logic;
      mode                : in std_logic;
      address_in          : in std_logic_vector(8 downto 0);
      data_in             : in std_logic_vector(3 downto 0);
      load_in             : in std_logic;
      address_out_layer   : out std_logic_vector(8 downto 0);
      data_out_layer      : out std_logic_vector(3 downto 0);
      load_out_layer      : out std_logic;
      address_out_storage : out std_logic_vector(8 downto 0);
      data_out_storage    : out std_logic_vector(3 downto 0);
      load_out_storage    : out std_logic
    );
  end component;

  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics

  -- Ports
  signal clk                 : std_logic;
  signal reset               : std_logic;
  signal mode                : std_logic;
  signal address_in          : std_logic_vector(8 downto 0);
  signal data_in             : std_logic_vector(3 downto 0);
  signal load_in             : std_logic;
  signal address_out_layer   : std_logic_vector(8 downto 0);
  signal data_out_layer      : std_logic_vector(3 downto 0);
  signal load_out_layer      : std_logic;
  signal address_out_storage : std_logic_vector(8 downto 0);
  signal data_out_storage    : std_logic_vector(3 downto 0);
  signal load_out_storage    : std_logic;

begin

  top_level_resolver_inst : top_level_resolver
  port map(
    clk                 => clk,
    reset               => reset,
    mode                => mode,
    address_in          => address_in,
    data_in             => data_in,
    load_in             => load_in,
    address_out_layer   => address_out_layer,
    data_out_layer      => data_out_layer,
    load_out_layer      => load_out_layer,
    address_out_storage => address_out_storage,
    data_out_storage    => data_out_storage,
    load_out_storage    => load_out_storage
  );

  clk_process : process
  begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
  end process clk_process;

  beh_process : process
  begin
    reset <= '1';
    wait for 2 * clk_period;
    reset      <= '0';
    mode       <= '0';
    load_in    <= '1';
    address_in <= "001010010";
    data_in    <= "0100";
    wait for 2 * clk_period;
    mode       <= '1';
    load_in    <= '1';
    address_in <= "011011000";
    data_in    <= "0101";
    wait for 2 * clk_period;
    report "Simulation Stop";
    stop;
  end process;

end;