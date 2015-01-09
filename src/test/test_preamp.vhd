--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: test_preamp.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::SmartFusion2> <Die::M2S010T> <Package::484 FBGA>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;  --necessario per usare un file di testo come input di simulazione

entity test_preamp is
    generic (
		N : positive := 8   --per usare il file di testo ipotizzo campioni da 8 bit
	);
end test_preamp;
architecture behavior of test_preamp is
   --la simulazione � un po piu incasinata, ma a parte le port map iniziali non ho nemmeno messo il reset tanto
    --dovrebbe partire immediatamente, prende un valore dal file ogni 4 periodi di clock e fa il suo sporco lavoro

file vectors: text open read_mode is "test_preamp.dat";  --file di testo (da allegare con IMPORT su microsemi, non so sul vostro)
COMPONENT preamp
PORT( clk : in std_logic;
    input : in signed(N-1 downto 0);
    output : out signed(N-1 downto 0)
    );
END COMPONENT;
    
    --i nomi dei segnali sono copiati pari pari dal testbench del pdf
    SIGNAL clk : std_logic := '0' ;
    SIGNAL fmin : signed(N-1 downto 0) := (others => '0');
    SIGNAL dmout : signed(N-1 downto 0);
    constant clkperiod : time := 10.5 ns;

begin
    
    --anche le funzioni per prendere i valori di volta in volta dal file, e usano la libreria textIO
    test: preamp port map (clk=>clk,
        input=>fmin,
        output=>dmout);
    
    clk <= not clk after clkperiod / 2;    
   process
        variable vectorline : line;
        variable fmin_var : bit_vector(N-1 downto 0);
    begin

    

while not endfile(vectors) loop

    readline(vectors, vectorline);
    read(vectorline, fmin_var);
    fmin <= signed(to_stdLogicVector(fmin_var));
      
    wait for clkperiod*4;
end loop;

end process;

end behavior;
