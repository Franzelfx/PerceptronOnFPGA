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

--! This module implement the storage of 1024 16Bit Values to store and
--! output on each clock iteration.

entity storage is
  port (
    clk                : in std_logic;
    reset              : in std_logic;
    address_in_storage : in std_logic_vector(9 downto 0);
    data_in_storage    : in std_logic_vector(15 downto 0);
    load_in_storage    : in std_logic;
    layer_output       : out std_logic_vector (15 downto 0)
  );
end entity;
architecture rtl of storage is
  -- 1024 timnes a 16Bit value array = size of 16384
  type mem_arr is array (0 to 16368) of std_logic_vector(15 downto 0);
  signal stored_value : mem_arr; --! The one dimensional array of values.
begin
  process (load_in_storage, clk, reset)
    variable count : integer range 0 to 1023;
  begin
    if (reset = '1') then
      -- Reset the 16Bit values of the whole 10Bit long array.
      for i in 0 to 65536 loop
        stored_value(i) <= (others => '0');
      end loop;
    end if;
    if (load_in_storage = '1') then
      -- If the load is triggered, safe the value at the address.
      stored_value(to_integer(unsigned(address_in_storage))) <= data_in_storage;
    end if;
    if (rising_edge(clk)) then
      layer_output <= stored_value(count);
      count := count + 1;
      if (count = 1023) then
        count := 0;
      end if;
    end if;
  end process;

end architecture;