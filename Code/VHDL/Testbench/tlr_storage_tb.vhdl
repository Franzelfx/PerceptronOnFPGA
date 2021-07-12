library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.uniform;
use std.env.stop;

--! @title "Top Level Resolver and Storage" Testbench
--! @file tlr_storage_tb.vhdl
--! @author Fabian Franz (fabian.franz0596@gmail.com)
--! @version 0.1
--! @date 26.06.2021

entity tlr_storage_tb is
end;

architecture bench of tlr_storage_tb is
  component tlr_storage
    port (
      clk     : in std_logic;
      reset   : in std_logic;
      mode    : in std_logic;
      address : in std_logic_vector(10 downto 0);
      data    : in std_logic_vector(15 downto 0);
      load    : in std_logic
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

begin

  tlr_storage_inst : tlr_storage
  port map(
    clk     => clk,
    reset   => reset,
    mode    => mode,
    address => address,
    data    => data,
    load    => load
  );

  -- system integration test
  beh_process : process is
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
    ----------------------------
    -- actual behaviour check --
    ----------------------------
  begin
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
    -- get the data back iteratively at the output port
    for i in 0 to 1023 loop
      wait for clk_period;
      clk <= '1';
      wait for clk_period;
      clk <= '0';
    end loop;
    stop;
  end process;
end;