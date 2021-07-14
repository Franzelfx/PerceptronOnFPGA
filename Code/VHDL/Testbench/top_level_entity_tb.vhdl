library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.uniform;
use std.env.stop;

--! @title Top Level Entity
--! @file top_level_entity.vhdl
--! @author Fabian Franz (fabian.franz0596@gmail.com)
--! @version 0.1
--! @date 31.05.2021

entity top_level_entity_tb is
end;

architecture bench of top_level_entity_tb is

  component top_level_entity
    port (
      clk     : in std_logic;
      reset   : in std_logic;
      mode    : in std_logic;
      address : in std_logic_vector(10 downto 0);
      data    : in std_logic_vector(15 downto 0);
      load    : in std_logic;
      result  : out std_logic_vector(15 downto 0) := (others => '0')
    );
  end component;

  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics

  -- Ports
  signal clk     : std_logic;
  signal reset   : std_logic;
  signal mode    : std_logic;
  signal address : std_logic_vector(10 downto 0);
  signal data    : std_logic_vector(15 downto 0);
  signal load    : std_logic;
  signal result  : std_logic_vector(15 downto 0);
begin

  top_level_entity_inst : top_level_entity
  port map(
    clk     => clk,
    reset   => reset,
    mode    => mode,
    address => address,
    data    => data,
    load    => load,
    result  => result
  );

  -- system integration test
  beh_process : process
    -- randome number variable
    variable seed1, seed2 : integer := 999;
    -- randome vector number generator
    impure function rand_slv(len : integer) return std_logic_vector is
      variable r                   : real;
      variable slv                 : std_logic_vector(len - 1 downto 0);
    begin
      for i in slv'range loop
        uniform(seed1, seed2, r);
        if r > 0.5 then
          slv(i) := '1';
        else
          slv(i) := '0';
        end if;
      end loop;
      return slv;
    end function;
  begin
    --------------------------------
    -- Write Test Data to Storage --
    --------------------------------
    -- reset everything and set standard values
    wait for clk_period;
    clk     <= '0';
    reset   <= '1';
    mode    <= '1'; -- '1' for storage addressing
    address <= (others => '0');
    data    <= (others => '0');
    load    <= '0';
    wait for clk_period;
    -- load some data in the storage
    reset <= '0';
    for i in 0 to 1023 loop
      address <= std_logic_vector(to_unsigned(i, address'length)); -- addressing every place in the storage
      data    <= rand_slv(16); -- write some randome data in the storage
      wait for clk_period;
      load <= '1';
      wait for clk_period;
      load <= '0';
    end loop;
    ------------------------------------------------
    -- Standard Activation and Sensitivity Values --
    ------------------------------------------------
    -- get the storage data back iteratively at the output port
    for i in 0 to 1023 loop
      wait for clk_period;
      clk <= '1';
      wait for clk_period;
      clk <= '0';
    end loop;
    ----------------------------------------------------
    -- Non Standard Activation and Sensitivity Values --
    ----------------------------------------------------
    -- format is: xxxx xxxx xxx (layer, perceptron in layer, value)
    -- value => 0 = activation value, 1-4 = sens_1 to sens_4, ends up in 16Bit activation vector
    mode <= '0'; -- '0' for layer addressing
    for i in 0 to 2047 loop -- iterate over all perceptrons
      address <= std_logic_vector(to_unsigned(i, address'length));
      data    <= "0000000000001111" and rand_slv(16); -- set randome activation value
      wait for clk_period/2;
      load <= '1';
      wait for clk_period/2;
      load <= '0';
    end loop;
    -- get the storage data back iteratively at the output port
    for i in 0 to 1023 loop
      wait for clk_period;
      clk <= '1';
      wait for clk_period;
      clk <= '0';
    end loop;
    stop;
  end process;

end;