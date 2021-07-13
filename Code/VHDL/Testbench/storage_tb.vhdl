library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

--! @title Perceptron
--! @file pereptron.vhdl
--! @author Fabian Franz (fabian.franz0596@gmail.com)
--! @version 0.1
--! @date 31.05.2021

entity storage_tb is
end;

architecture bench of storage_tb is

  component storage
    port (
      clk                : in std_logic;
      reset              : in std_logic;
      address_in_storage : in std_logic_vector(9 downto 0);
      data_in_storage    : in std_logic_vector(15 downto 0);
      load_in_storage    : in std_logic;
      layer_output       : out std_logic_vector (15 downto 0)
    );
  end component;

  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics

  -- Ports
  signal clk                : std_logic;
  signal reset              : std_logic;
  signal address_in_storage : std_logic_vector(9 downto 0);
  signal data_in_storage    : std_logic_vector(15 downto 0);
  signal load_in_storage    : std_logic;
  signal layer_output       : std_logic_vector (15 downto 0);

begin

  storage_inst : storage
  port map(
    clk                => clk,
    reset              => reset,
    address_in_storage => address_in_storage,
    data_in_storage    => data_in_storage,
    load_in_storage    => load_in_storage,
    layer_output       => layer_output
  );

  check_beh : process
  begin
    -----------------
    -- first reset --
    -----------------
    reset              <= '1';
    clk                <= '0';
    load_in_storage    <= '0';
    address_in_storage <= std_logic_vector(to_unsigned(0, address_in_storage'length));
    data_in_storage    <= std_logic_vector(to_unsigned(0, data_in_storage'length));
    wait for clk_period;
    reset <= '0';
    --------------------------
    -- set the input values --
    --------------------------
    address_in_storage <= std_logic_vector(to_unsigned(0, address_in_storage'length));
    data_in_storage    <= std_logic_vector(to_unsigned(244, data_in_storage'length));
    wait for clk_period;
    load_in_storage <= '1';
    wait for clk_period;
    load_in_storage    <= '0';
    address_in_storage <= std_logic_vector(to_unsigned(1, address_in_storage'length));
    data_in_storage    <= std_logic_vector(to_unsigned(12, data_in_storage'length));
    wait for clk_period;
    load_in_storage <= '1';
    wait for clk_period;
    load_in_storage    <= '0';
    address_in_storage <= std_logic_vector(to_unsigned(2, address_in_storage'length));
    data_in_storage    <= std_logic_vector(to_unsigned(899, data_in_storage'length));
    wait for clk_period;
    load_in_storage <= '1';
    wait for clk_period;
    load_in_storage <= '0';
    ---------------------------
    -- get the output values --
    ---------------------------
    clk <= '1';
    wait for clk_period;
    clk <= '0';
    wait for clk_period;
    clk <= '1';
    wait for clk_period;
    clk <= '0';
    wait for clk_period;
    clk <= '1';
    wait for clk_period;
    clk <= '0';
    wait for clk_period;
    report "Simulation Stop";
    stop;
  end process;
end;
------------------------------------
-- Configuration for the instance --
------------------------------------
configuration one of storage_tb is
  for bench
    for storage_inst : storage
      use entity work.storage(rtl);
    end for;
  end for;
end configuration one;