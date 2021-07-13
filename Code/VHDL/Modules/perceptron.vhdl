library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

--! @title Perceptron
--! @file pereptron.vhdl
--! @author Fabian Franz (fabian.franz0596@gmail.com)
--! @version 0.1
--! @date 18.05.2021

--! This module describes the actual behaviour of the combinatorical
--! perceptron. The perceptron is capable of holding the values for
--! input sensitivity and the output activation.

entity perceptron is
  generic (
    perceptron_id : integer range 0 to 15 --! the ID of the perceptron in the specific layer
  );
  port (
    reset        : in std_logic; --! reset inputs and outputs of the entity to default values
    dentrid_port : in std_logic_vector(15 downto 0); --! input from previous layer
    axon_port    : out std_logic := '0'; --! output to next layer
    address      : in std_logic_vector(6 downto 0); --! current address for parameter manipulation
    data         : in std_logic_vector(3 downto 0); --! value of the addressed parameter
    load         : in std_logic --! signal to actually store the addressed parameter value
  );
end entity;

architecture rtl of perceptron is
  ----------------------
  -- internal signals --
  ----------------------
  -- the two parameters of the perceptron
  signal activation_value  : unsigned (3 downto 0)  := (others => '1'); --! threshold parameter for input count until output is set to one
  signal sensitivity_value : unsigned (15 downto 0) := (others => '0'); --! determine whis inputs are activated and counted.
  -- needs to be split into 4 vectors
  signal sens_1 : unsigned (3 downto 0)   := (others => '0');
  signal sens_2 : unsigned (7 downto 4)   := (others => '0');
  signal sens_3 : unsigned (11 downto 8)  := (others => '0');
  signal sens_4 : unsigned (15 downto 12) := (others => '0');
begin

  behaviour : process (load, reset, dentrid_port, address, data) is
    variable count     : unsigned(3 downto 0)           := (others => '0');
    variable old_value : std_logic_vector (15 downto 0) := (others => '0');
  begin
    --------------------
    -- reset handling --
    --------------------
    if (reset = '1') then
      axon_port         <= '0';
      activation_value  <= (others => '1');
      sensitivity_value <= (others => '0');
      sens_1            <= (others => '0');
      sens_2            <= (others => '0');
      sens_3            <= (others => '0');
      sens_4            <= (others => '0');
      count     := (others         => '0');
      old_value := (others         => '0');
    else
      ----------------------------
      -- value storage handling --
      ----------------------------
      if load = '1' then
        -- check if the current perceptron is meant (first 4 Bit)
        if (shift_right((unsigned(address) and "1111000"), 3) = perceptron_id) then
          -- check the parameters (last 3 Bit)
          if ((unsigned(address) and "0000111") = 0) then
            activation_value <= unsigned(data);
          end if;
          if ((unsigned(address) and "0000111") = 1) then
            sens_1 <= unsigned(data);
          end if;
          if ((unsigned(address) and "0000111") = 2) then
            sens_2 <= unsigned(data);
          end if;
          if ((unsigned(address) and "0000111") = 3) then
            sens_3 <= unsigned(data);
          end if;
          if ((unsigned(address) and "0000111") = 4) then
            sens_4 <= unsigned(data);
          end if;
        end if;
        sensitivity_value <= sens_4 & sens_3 & sens_2 & sens_1;
      end if;
      ---------------------
      -- output handling --
      ---------------------
      if dentrid_port /= old_value then
        -- count over all Bits and proceed sensitivity and and output activation
        count := "0000";
        for i in 0 to 15 loop
          if ((dentrid_port(i) = '1') and (sensitivity_value(i) = '1')) then
            count := count + 1;
          end if;
        end loop; -- counter
        old_value := dentrid_port;
        -- update axon
        if (count >= activation_value) then
          axon_port <= '1';
        else
          axon_port <= '0';
        end if;
      end if;
    end if;
  end process;
end architecture;