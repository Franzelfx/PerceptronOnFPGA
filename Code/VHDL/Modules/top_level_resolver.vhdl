library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity top_level_resolver is
  port (
    clk            : in std_logic;
    reset          : in std_logic;
    mode_in        : in std_logic;
    address_in     : in std_logic_vector(8 downto 0);
    data_in        : in std_logic_vector(3 downto 0);
    address_out    : out std_logic_vector(8 downto 0);
    data_out_layer : out std_logic_vector(3 downto 0);
    load_out_layer : out std_logic;
  );
end entity;