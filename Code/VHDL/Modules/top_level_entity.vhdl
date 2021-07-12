library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.all;

--! @title Top Level Entity
--! @file top_level_entity.vhdl
--! @author Fabian Franz (fabian.franz0596@gmail.com)
--! @version 0.1
--! @date 14.06.2021

--! This module has the purpose to put all modules 
--! of the perceptron project together.

entity top_level_entity is
  port (
    clk     : in std_logic;
    reset   : in std_logic;
    mode    : in std_logic;
    address : in std_logic_vector(10 downto 0);
    data    : in std_logic_vector(15 downto 0);
    load    : in std_logic;
    result  : out std_logic_vector(15 downto 0) := (others => '0')
  );
end entity top_level_entity;

architecture rtl of top_level_entity is
  ----------------------
  -- Internal Signals --
  ----------------------
  -- connection top level resolver to layer
  signal address_int_layer : std_logic_vector(10 downto 0) := (others => '0');
  signal data_int_layer    : std_logic_vector(3 downto 0)  := (others => '0');
  signal load_int_layer    : std_logic                     := '0';
  -- connection top level resolver to storage
  signal address_int_storage : std_logic_vector(9 downto 0)  := (others => '0');
  signal data_int_storage    : std_logic_vector(15 downto 0) := (others => '0');
  signal load_int_storage    : std_logic                     := '0';
  -- connect storage to first layer
  signal storage_to_first_layer : std_logic_vector(15 downto 0) := (others => '0');
  -- layer connection arrays
  -- axon ports to next layer
  type arr_16_times_16 is array (0 to 14) of std_logic_vector(15 downto 0);
  signal layer_axon_arr : arr_16_times_16; -- connect axon ports between layers
  -- address from layer resolver to layer
  type arr_16_times_7 is array (0 to 15) of std_logic_vector(6 downto 0);
  signal address_layer_arr : arr_16_times_7; -- connect address ports between layers
  -- data from layer resolver to layer
  type arr_16_times_4 is array (0 to 15) of std_logic_vector(3 downto 0);
  signal data_layer_arr : arr_16_times_4; --! connect data ports between layers
  -- load from layer resolver to layer
  signal load_layer : std_logic_vector (15 downto 0);
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
  -- perceptron component
  component perceptron is
    generic (
      perceptron_id : integer range 0 to 15
    );
    port (
      reset        : in std_logic;
      dentrid_port : in std_logic_vector(15 downto 0);
      axon_port    : out std_logic;
      address      : in std_logic_vector(6 downto 0);
      data         : in std_logic_vector(3 downto 0);
      load         : in std_logic
    );
  end component;
  -- layer resolver component
  component layer_resolver is
    generic (
      layer_count : integer range 0 to 15
    );
    port (
      reset       : in std_logic;
      address_in  : in std_logic_vector(10 downto 0);
      data_in     : in std_logic_vector(3 downto 0);
      load_in     : in std_logic;
      address_out : out std_logic_vector(6 downto 0);
      data_out    : out std_logic_vector(3 downto 0);
      load_out    : out std_logic
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
  -- instance of first layer perceptron (connected to storage)
  layer_1 : for i in 0 to 15 generate -- generate 16 perceptrrons in first layer
    layer_1_inst : perceptron
    generic map(
      perceptron_id => i
    )
    port map(
      reset        => reset,
      dentrid_port => storage_to_first_layer, -- storage to first layer
      axon_port    => layer_axon_arr(0)(i), -- first to second layer
      address      => address_layer_arr(0), -- first resolver to first layer
      data         => data_layer_arr(0), -- ""
      load         => load_layer(0) -- ""
    );
  end generate;
  -- instances of layer resolver
  layer_resolvers : for i in 0 to 15 generate -- generate 16 layer resolvers
    layer_resolver_inst : layer_resolver
    generic map(
      layer_count => i
    )
    port map(
      reset       => reset,
      address_in  => address_int_layer, -- tlr to resolvers
      data_in     => data_int_layer, -- ""
      load_in     => load_int_layer, -- ""
      address_out => address_layer_arr(i), -- layer resolver to perceptron array
      data_out    => data_layer_arr(i), -- ""
      load_out    => load_layer(i)
    );
  end generate;
  -- two dimensional layer array of perceptrons 14 x 16 (layer x perceptron)
  layer_arr_2D : for i in 1 to 14 generate -- layer
    layer_arr_1D : for j in 0 to 15 generate -- perceptron in layer
      perceptron_arr_inst : perceptron
      generic map(
        perceptron_id => j
      )
      port map(
        reset        => reset,
        dentrid_port => layer_axon_arr(i - 1), -- prev layer to current layer
        axon_port    => layer_axon_arr(i)(j), -- current to next layer
        address      => address_layer_arr(i), -- layer resolver to perceptron array
        data         => data_layer_arr(i), -- ""
        load         => load_layer(i) -- ""
      );
    end generate;
  end generate;
  -- instance of last layer (connected to output)
  layer_16 : for i in 0 to 15 generate -- generate 16 perceptrrons in last layer
    layer_16_inst : perceptron
    generic map(
      perceptron_id => i
    )
    port map(
      reset        => reset,
      dentrid_port => layer_axon_arr(14), -- last layer to previous layer
      axon_port    => result(i), -- last layer to qutput
      address      => address_layer_arr(15), -- first resolver to first layer
      data         => data_layer_arr(15), -- ""
      load         => load_layer(15) -- ""
    );
  end generate;
end architecture;

-----------------------------
-- Component Configuration --
-----------------------------
-- top level resolver
configuration tlr_conf of top_level_entity is
  for rtl
    for tlr_inst : top_level_resolver
      use entity work.top_level_resolver(rtl);
    end for;
  end for;
end configuration tlr_conf;
-- storage
configuration storage_conf of top_level_entity is
  for rtl
    for storage_inst : storage
      use entity work.storage(rtl);
    end for;
  end for;
end configuration storage_conf;