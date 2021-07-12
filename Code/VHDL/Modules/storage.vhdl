library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

--! @title Perceptron Storage
--! @file storage.vhdl
--! @author Fabian Franz (fabian.franz0596@gmail.com)
--! @version 0.1
--! @date 31.05.2021

--! This module implement the storage of 1024 16Bit Values and
--! output them on each clock iteration.

entity storage is
  port (
    clk                : in std_logic; --! clock for iteration over storage values
    reset              : in std_logic; --! reset to set default values
    address_in_storage : in std_logic_vector(9 downto 0); --! address where tha value have to be stored
    data_in_storage    : in std_logic_vector(15 downto 0); --! actual data which have to be stored
    load_in_storage    : in std_logic; --! trigger the storage
    layer_output       : out std_logic_vector (15 downto 0) := (others => '0') --! output to the first layer
  );
end entity;
architecture rtl of storage is
  -- 1024 times a 16Bit value array = size of 16384
  type arr_1024_times_16 is array (0 to 1023) of std_logic_vector(15 downto 0); --! the one dimensional array of stored values
  signal stored_value : arr_1024_times_16;
begin
  behaviour : process (load_in_storage, clk, reset)
    variable count : integer range 0 to 1023;
  begin
    --------------------
    -- reset handling --
    --------------------
    if (reset = '1') then
      -- Reset the 16Bit values of the whole 10Bit long array.
      for i in 0 to 1023 loop
        stored_value(i) <= (others => '0');
        count := 0;
      end loop;
    end if;
    --------------------
    -- input handling --
    --------------------
    if (rising_edge(load_in_storage)) then
      -- If the load is triggered, safe the value at the address.
      stored_value(to_integer(unsigned(address_in_storage))) <= data_in_storage;
    end if;
    ---------------------
    -- output handling --
    ---------------------
    if (rising_edge(clk)) then
      layer_output <= stored_value(count);
      count := count + 1;
      if (count = 1023) then
        count := 0;
      end if;
    end if;
  end process;

end architecture;