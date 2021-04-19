library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity top_level_resolver is
  port (
    -- Input Signals
    clk        : in std_logic;
    reset      : in std_logic;
    mode       : in std_logic;
    address_in : in std_logic_vector(8 downto 0);
    data_in    : in std_logic_vector(3 downto 0);
    load_in    : in std_logic;
    -- Output to Layer
    address_out_layer : out std_logic_vector(8 downto 0);
    data_out_layer    : out std_logic_vector(3 downto 0);
    load_out_layer    : out std_logic;
    -- Output to Storage
    address_out_storage : out std_logic_vector(8 downto 0);
    data_out_storage    : out std_logic_vector(3 downto 0);
    load_out_storage    : out std_logic
  );
end entity;

-- Behaviour of top_level_resolver
architecture rtl of top_level_resolver is
begin
  -- Behaviour Process
  beh : process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        -- Reset all Outputs and internal Variables
        address_out_layer   <= (others => 'Z');
        data_out_layer      <= (others => 'Z');
        load_out_layer      <= 'Z';
        address_out_storage <= (others => 'Z');
        data_out_storage    <= (others => 'Z');
        load_out_storage    <= 'Z';
      else
        -- Layer Branch
        if mode = '0' then
          address_out_layer <= address_in;
          data_out_layer    <= data_in;
          load_out_layer    <= load_in;
          -- All others to default
          address_out_storage <= (others => 'Z');
          data_out_storage    <= (others => 'Z');
          load_out_storage    <= 'Z';
          -- Storage Branch
        else
          address_out_storage <= address_in;
          data_out_storage    <= data_in;
          load_out_storage    <= load_in;
          -- All others to default
          address_out_layer <= (others => 'Z');
          data_out_layer    <= (others => 'Z');
          load_out_layer    <= 'Z';
        end if;
      end if;
    end if;
  end process;
end architecture;