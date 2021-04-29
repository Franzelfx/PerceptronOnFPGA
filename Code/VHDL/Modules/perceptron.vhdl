library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

--! This module describes the actual behaviour of the combinatorical
--! perceptron. The perceptron is capable of holding the values for
--! input sensitivity and the output activation.

entity perceptron is
  generic (
    perceptron_count : integer range 0 to 16
  );
  port (
    reset        : in std_logic;
    dentrid_port : in std_logic_vector(15 downto 0);
    axon_port    : out std_logic;
    address      : in std_logic_vector(4 downto 0);
    data         : in std_logic_vector(3 downto 0);
    load         : in std_logic
  );
end entity;

architecture rtl of perceptron is

begin
  -- store the information about the input sensitivity
  input_sensitivity_storage : process (load)
  begin

  end process;
  -- store the information about the output activation
  output_activation_storage : process (load)
  begin

  end process;
  -- all the magic happens in this process
  proceed_input : process (dentrid_port)
  begin

  end process;
end architecture;