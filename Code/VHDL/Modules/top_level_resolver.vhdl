library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

--! @title Top Level Resolver
--! @file top_level_resolver.vhdl
--! @author Fabian Franz (fabian.franz0596@gmail.com)
--! @version 0.1
--! @date 06.2021

--! This module implement the data and address handling switch between
--! the layer modules and the storage module.

entity top_level_resolver is
  port (
    -------------------
    -- Input Signals --
    -------------------
    reset      : in std_logic; --! global reset
    mode       : in std_logic; --! 	select the direction
    address_in : in std_logic_vector(10 downto 0); --! the address of data storage
    data_in    : in std_logic_vector(15 downto 0); --! the actual data to store
    load_in    : in std_logic; --! triggers the storage
    ------------------------------------------------
    -- Output to Layer 11Bit address and 4Bit data --
    ------------------------------------------------
    address_out_layer : out std_logic_vector(10 downto 0) := (others => '0'); --! address casting, mode='1'
    data_out_layer    : out std_logic_vector(3 downto 0)  := (others => '0'); --! data forwarding
    load_out_layer    : out std_logic                     := '0'; --! triggers storage
    ----------------------------------------------------
    -- Output to Storage 10Bit address and 16Bit data --
    ----------------------------------------------------
    address_out_storage : out std_logic_vector(9 downto 0)  := (others => '0'); --! address casting, mode='0'
    data_out_storage    : out std_logic_vector(15 downto 0) := (others => '0'); --! data forwarding
    load_out_storage    : out std_logic                     := '0' --! triggers storage
  );
end entity;

-------------------------------------
-- Behaviour of top_level_resolver --
-------------------------------------
architecture rtl of top_level_resolver is
begin
  -----------------------
  -- Behaviour Process --
  -----------------------
  behaviour : process (reset, mode, address_in, data_in, load_in) is
  begin
    if reset = '1' then
      ----------------------------------------------
      -- Reset all Outputs and internal Variables --
      ----------------------------------------------
      address_out_layer   <= (others => '0');
      data_out_layer      <= (others => '0');
      load_out_layer      <= '0';
      address_out_storage <= (others => '0');
      data_out_storage    <= (others => '0');
      load_out_storage    <= '0';
    elsif reset = '0' then
      ------------------
      -- Layer Branch --
      ------------------
      if mode = '0' then
        address_out_layer <= address_in;
        data_out_layer    <= data_in(3 downto 0); -- least significant bits
        load_out_layer    <= load_in;
        ---------------------------
        -- All others to default --
        ---------------------------
        address_out_storage <= (others => '0');
        data_out_storage    <= (others => '0');
        load_out_storage    <= '0';
        --------------------
        -- Storage Branch --
        --------------------
      elsif mode = '1' then
        address_out_storage <= address_in(9 downto 0); -- least significant bits
        data_out_storage    <= data_in;
        load_out_storage    <= load_in;
        ---------------------------
        -- All others to default --
        ---------------------------
        address_out_layer <= (others => '0');
        data_out_layer    <= (others => '0');
        load_out_layer    <= '0';
      end if;
    end if;
  end process;
end architecture;