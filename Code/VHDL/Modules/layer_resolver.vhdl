library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

--! This module is designed for resolving the signals in every
--! single layer of the multilayer perceptron.
--! The addresss resolving is based on the "layer_count" variable, which
--! determine the number of every single layer in the whole multilayer perceptron.
--! Based on this number, the address is forwarded by a 4-Bit bus to single 
--! perceptrons in the layer.

entity layer_resolver is
  generic (
    layer_count : integer range 0 to 16
  );
  port (
    clk         : in std_logic;
    reset       : in std_logic;
    address_in  : in std_logic_vector(10 downto 0);
    data_in     : in std_logic_vector(3 downto 0);
    load_in     : in std_logic;
    address_out : out std_logic_vector(6 downto 0);
    data_out    : out std_logic_vector(3 downto 0);
    load_out    : out std_logic
  );
end entity;

architecture rtl of layer_resolver is
begin
  process (clk, address_in) is
    variable perceptron_address : integer range 0 to 32;
  begin
    if rising_edge(clk) then
      if reset = '1' then
        address_out <= (others => 'Z');
        data_out    <= (others => 'Z');
        load_out    <= '0';
      else
        -- detect valid address
        if (load_in = '1') then
          if (to_integer(unsigned(address_in)) >= layer_count * 80) and
            (to_integer(unsigned(address_in)) < (layer_count + 1) * 80) then
            -- forward the address and data
            perceptron_address := (to_integer(unsigned(address_in)) - layer_count * 80);
            address_out <= std_logic_vector(to_unsigned(perceptron_address, address_out'length));
            data_out    <= data_in;
            load_out    <= load_in;
          else
            -- reset address and data output
            address_out <= (others => 'Z');
            data_out    <= (others => 'Z');
            load_out    <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;
end architecture;