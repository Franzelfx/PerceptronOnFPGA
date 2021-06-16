library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

--! @title Top Level Resolver
--! @file top_level_resolver.vhdl
--! @author Fabian Franz (fabian.franz0596@gmail.com)
--! @version 0.1
--! @date 18.05.2021

entity top_level_resolver_tb is
end;

architecture bench of top_level_resolver_tb is

  component top_level_resolver
    port (
      reset               : in std_logic;
      mode                : in std_logic;
      address_in          : in std_logic_vector(9 downto 0);
      data_in             : in std_logic_vector(15 downto 0);
      load_in             : in std_logic;
      address_out_layer   : out std_logic_vector(8 downto 0);
      data_out_layer      : out std_logic_vector(3 downto 0);
      load_out_layer      : out std_logic;
      address_out_storage : out std_logic_vector(9 downto 0);
      data_out_storage    : out std_logic_vector(15 downto 0);
      load_out_storage    : out std_logic
    );
  end component;

  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics

  -- Ports
  signal reset               : std_logic;
  signal mode                : std_logic;
  signal address_in          : std_logic_vector(9 downto 0);
  signal data_in             : std_logic_vector(15 downto 0);
  signal load_in             : std_logic;
  signal address_out_layer   : std_logic_vector(8 downto 0);
  signal data_out_layer      : std_logic_vector(3 downto 0);
  signal load_out_layer      : std_logic;
  signal address_out_storage : std_logic_vector(9 downto 0);
  signal data_out_storage    : std_logic_vector(15 downto 0);
  signal load_out_storage    : std_logic;

begin

  top_level_resolver_inst : top_level_resolver
  port map(
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

  beh_process : process
  begin
    reset      <= '1';
    mode       <= '0';
    address_in <= "0000000000";
    data_in    <= "0000000000000000";
    load_in    <= '0';
    wait for 2 * clk_period;
    reset <= '0';
    -------------------------------------------------------
    -- addressing the layer (9Bit address and 4Bit data) --
    -------------------------------------------------------
    mode       <= '0';
    load_in    <= '1';
    address_in <= "0010100101";
    data_in    <= "0000000000001101";
    wait for 2 * clk_period;
    ----------------------------
    -- addressing the storage --
    ----------------------------
    mode       <= '1';
    load_in    <= '1';
    address_in <= "0110110000";
    data_in    <= "0000000000000011";
    wait for 2 * clk_period;
    report "Simulation Stop";
    stop;
  end process;

end;
------------------------------------
-- Configuration for the instance --
------------------------------------
configuration one of top_level_resolver_tb is
  for bench
    for top_level_resolver_inst : top_level_resolver
      use entity work.top_level_resolver(rtl);
    end for;
  end for;
end configuration one;