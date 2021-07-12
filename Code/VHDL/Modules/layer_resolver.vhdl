library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

--! @title layer_resolver
--! @file pereptron.vhdl
--! @author Fabian Franz (fabian.franz0596@gmail.com)
--! @version 0.1
--! @date 18.05.2021

--! This module is designed for resolving the signals in every
--! single layer of the multilayer perceptron.
--! The address resolving is based on the "layer_count" variable, which
--! determine the number of every single layer in the whole multilayer perceptron.
--! Based on this number, the address is forwarded by a 7-Bit bus to the 
--! single perceptrons in the layer.

entity layer_resolver is
  generic (
    layer_count : integer range 0 to 16 --! identifier for the current layer
  );
  port (
    reset       : in std_logic; --! reset to default output values
    address_in  : in std_logic_vector(10 downto 0); --! input address from "Top Level Resolver"
    data_in     : in std_logic_vector(3 downto 0); --! input data from "Top Level resolver"
    load_in     : in std_logic; --! load input from "Top Level Resolver"
    address_out : out std_logic_vector(6 downto 0) := (others => '0'); --! addressing the sensitivity and activation value in the "Perceptron"
    data_out    : out std_logic_vector(3 downto 0) := (others => '0'); --! the actual value for sensitivity and activation in the "Perceptron"
    load_out    : out std_logic                    := '0' --! triggers the storage in the "Perceptron"
  );
end entity;

architecture rtl of layer_resolver is
begin
  behaviour : process (address_in, reset, load_in, data_in) is
    variable perceptron_address : integer range 0 to 15;
  begin
    if reset = '1' then
      address_out <= (others => '0');
      data_out    <= (others => '0');
      load_out    <= '0';
    else
      --------------------------
      -- detect valid address --
      --------------------------
      if (load_in = '1') then
        -- address = xxxx xxxx xxx (layer, perceptron in layer, value)
        if (shift_right((unsigned(address_in) and "11110000000"), 7) = layer_count) then
          ------------------------------
          -- forward address and data --
          ------------------------------
          address_out <= address_in(6 downto 0);
          data_out    <= data_in;
          load_out    <= load_in;
        else
          -----------------------------------
          -- reset address and data output --
          -----------------------------------
          address_out <= (others => '0');
          data_out    <= (others => '0');
          load_out    <= '0';
        end if;
      end if;
    end if;
  end process;
end architecture;