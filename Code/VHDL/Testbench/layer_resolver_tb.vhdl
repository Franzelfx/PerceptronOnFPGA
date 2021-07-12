library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

--! @title layer_resolver_tb
--! @file pereptron.vhdl
--! @author Fabian Franz (fabian.franz0596@gmail.com)
--! @version 0.1
--! @date 18.05.2021

entity layer_resolver_tb is
end;

architecture bench of layer_resolver_tb is

  component layer_resolver
    generic (
      layer_count : integer range 0 to 16
    );
    port (
      reset       : in std_logic;
      address_in  : in std_logic_vector(10 downto 0);
      data_in     : in std_logic_vector(3 downto 0);
      load_in     : in std_logic;
      address_out : out std_logic_vector(6 downto 0);
      data_out    : out std_logic_vector(3 downto 0);
      load_out    : out std_logic
    );
  end component;

  -- Clock period
  constant clk_period : time := 5 ns;

  -- Ports
  signal reset       : std_logic;
  signal address_in  : std_logic_vector(10 downto 0);
  signal data_in     : std_logic_vector(3 downto 0);
  signal load_in     : std_logic;
  signal address_out : std_logic_vector(6 downto 0);
  signal data_out    : std_logic_vector(3 downto 0);
  signal load_out    : std_logic;

begin

  layer_resolver_inst : layer_resolver
  generic map(
    layer_count => 1
  )
  port map(
    reset       => reset,
    address_in  => address_in,
    data_in     => data_in,
    load_in     => load_in,
    address_out => address_out,
    data_out    => data_out,
    load_out    => load_out
  );

  ----------------------------------
  -- general module function test --
  ----------------------------------
  input_process : process
  begin
    ---------------------------
    -- assign default values --
    ---------------------------
    address_in <= (others => 'Z');
    data_in    <= (others => 'Z');
    load_in    <= '0';
    -------------------
    -- trigger reset --
    -------------------
    reset <= '1';
    wait for 1.5 * clk_period;
    reset <= '0';
    --------------------------------------------------
    -- set first address near limit (80), 2nd layer --
    --------------------------------------------------
    load_in    <= '1';
    address_in <= std_logic_vector(to_unsigned(80, address_in'length));
    data_in    <= std_logic_vector(to_unsigned(4, data_in'length));
    wait for clk_period;
    ----------------------------------------
    -- set second address near limit (79) --
    ----------------------------------------
    load_in    <= '1';
    address_in <= std_logic_vector(to_unsigned(63, address_in'length));
    data_in    <= std_logic_vector(to_unsigned(5, data_in'length));
    wait for clk_period;
    -----------------------------------
    -- check the reset functionality --
    -----------------------------------
    reset <= '1';
    wait for 2 * clk_period;
    reset <= '0';
    stop;
  end process;
end;
------------------------------------
-- Configuration for the instance --
------------------------------------
configuration one of layer_resolver_tb is
  for bench
    for layer_resolver_inst : layer_resolver
      use entity work.layer_resolver(rtl);
    end for;
  end for;
end configuration one;