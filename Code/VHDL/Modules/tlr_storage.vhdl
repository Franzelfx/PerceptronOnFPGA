library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

--! @title Top Level Resolver and Storage
--! @file tlr_storage.vhdl
--! @author Fabian Franz (fabian.franz0596@gmail.com)
--! @version 0.1
--! @date 31.05.2021

--! This is the integration test of the "Top Level Resolver" and the 
--! "Storage" module.
entity tlr_storage is
  port (
    clk     : in std_logic;
    reset   : in std_logic;
    mode    : in std_logic;
    address : in std_logic_vector(10 downto 0);
    data    : in std_logic_vector(15 downto 0);
    load    : in std_logic
  );
end entity;

architecture rtl of tlr_storage is
  ----------------------
  -- Internal Signals --
  ----------------------
  -- connection top level resolver to layer
  signal address_int_layer : std_logic_vector(10 downto 0) := (others => '0');
  signal data_int_layer    : std_logic_vector(3 downto 0)  := (others => '0');
  signal load_int_layer    : std_logic;
  -- connection top level resolver to storage
  signal address_int_storage : std_logic_vector(9 downto 0)  := (others => '0');
  signal data_int_storage    : std_logic_vector(15 downto 0) := (others => '0');
  signal load_int_storage    : std_logic;
  -- connect storage to first layer
  signal storage_to_first_layer : std_logic_vector(15 downto 0) := (others => '0');
  ---------------------------
  -- component declaration --
  ---------------------------
  -- top level resolver component
  component top_level_resolver is
    port (
      reset               : in std_logic;
      mode                : in std_logic;
      address_in          : in std_logic_vector(10 downto 0);
      data_in             : in std_logic_vector(15 downto 0);
      load_in             : in std_logic;
      address_out_layer   : out std_logic_vector(10 downto 0);
      data_out_layer      : out std_logic_vector(3 downto 0);
      load_out_layer      : out std_logic;
      address_out_storage : out std_logic_vector(9 downto 0);
      data_out_storage    : out std_logic_vector(15 downto 0);
      load_out_storage    : out std_logic
    );
  end component;
  -- storage component
  component storage is
    port (
      clk                : in std_logic;
      reset              : in std_logic;
      address_in_storage : in std_logic_vector(9 downto 0);
      data_in_storage    : in std_logic_vector(15 downto 0);
      load_in_storage    : in std_logic;
      layer_output       : out std_logic_vector (15 downto 0)
    );
  end component;
begin
  -----------------------------
  -- Component instanciation --
  -----------------------------
  -- instance of top level resolver (connected to top level entity input)
  tlr_inst : top_level_resolver
  port map(
    reset               => reset,
    mode                => mode,
    address_in          => address,
    data_in             => data,
    load_in             => load,
    address_out_layer   => address_int_layer, -- tlr to internal routing
    data_out_layer      => data_int_layer, -- ""
    load_out_layer      => load_int_layer, -- ""
    address_out_storage => address_int_storage, -- ""
    data_out_storage    => data_int_storage, -- ""
    load_out_storage    => load_int_storage -- ""
  );
  -- instance of storage (connected to tlr)
  storage_inst : storage
  port map(
    clk                => clk,
    reset              => reset,
    address_in_storage => address_int_storage, -- tlr to storage
    data_in_storage    => data_int_storage, -- ""
    load_in_storage    => load_int_storage, -- ""
    layer_output       => storage_to_first_layer -- storage to first layer
  );
end architecture;

-------------------------------------
-- Configuration for the instances --
-------------------------------------
-- configuration for the "Top Level Resolver"
configuration tlr_conf of tlr_storage is
  for rtl
    for tlr_inst : top_level_resolver
      use entity work.top_level_resolver(rtl);
    end for;
  end for;
end configuration tlr_conf;

-- configuration for the "Storage"
configuration storage_conf of tlr_storage is
  for rtl
    for storage_inst : storage
      use entity work.storage(rtl);
    end for;
  end for;
end configuration storage_conf;