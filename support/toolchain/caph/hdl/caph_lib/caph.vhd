-----------------------------------------------------------------------------------------
--                                                                                     --
--                This file is part of the CAPH Compiler distribution                  --
--                            http://caph.univ-bpclermont.fr                           --
--                                                                                     --
--                                  Jocelyn SEROT                                      --
--                         Jocelyn.Serot@univ-bpclermont.fr                            --
--                                                                                     --
--         Copyright 2011-2015 Jocelyn SEROT.  All rights reserved.                    --
--  This file is distributed under the terms of the GNU Library General Public License --
--      with the special exception on linking described in file ../LICENSE.            --
--                                                                                     --
-----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package core is

  function cond(e1: boolean; e2: signed; e3: signed) return signed;
  function cond(e1: boolean; e2: unsigned; e3: unsigned) return unsigned;
  function cond(e1: boolean; e2: std_logic_vector; e3: std_logic_vector) return std_logic_vector;
  function eq(e1: signed; e2: signed) return unsigned;
  function eq(e1: unsigned; e2: unsigned) return unsigned;
  function mul(e1: signed; e2: signed) return signed;
  function mul(e1: unsigned; e2: unsigned) return unsigned;
  function to_std_logic_vector(e: unsigned; s: natural) return std_logic_vector;
  function to_std_logic_vector(e: signed; s: natural) return std_logic_vector;
  function to_std_logic_vector(e: boolean; s: natural) return std_logic_vector;
  function from_std_logic_vector(e: std_logic_vector; s: natural) return unsigned;
  function from_std_logic_vector(e: std_logic_vector; s: natural) return signed;
  function from_std_logic_vector(e: std_logic_vector; s: natural) return boolean;
  function from_std_logic_vector(e: std_logic_vector; s: natural) return std_logic_vector;
  function to_bool(e: unsigned) return boolean;
  function to_bool(e: signed) return boolean;
  function to_bool(e: std_logic_vector) return boolean;
  function conv_unsigned(e: unsigned; s: natural) return unsigned;
  function conv_unsigned(e: signed; s: natural) return unsigned;
  function conv_unsigned(e: boolean; s: natural) return unsigned;
  function conv_unsigned(e: integer; s: natural) return unsigned;
  function conv_signed(e: signed; s: natural) return signed;
  function conv_signed(e: unsigned; s: natural) return signed;
  function conv_signed(e: boolean; s: natural) return signed;
  function conv_signed(e: integer; s: natural) return signed;
  function to_integer(e: integer) return integer;
  function to_string(v : std_logic_vector) return string;  -- for debug only
  procedure dump_slv(name: string; v: std_logic_vector); -- for debug only


component stream_in is
generic ( filename: string := "input.bin"; size: integer := 10; period: integer := 2; blanking: boolean := false );
port (  full : in std_logic;
        dout : out std_logic_vector(size-1 downto 0);
        wr : out std_logic;   -- write (push) signal, active 1 on clk^
        clk : in std_logic;
        rst : in std_logic
        );
end component;

component stream_out is
generic ( filename: string := "vhdl_result.dat"; size: integer := 10);
port (  empty : in std_logic; 
        din : in std_logic_vector(size-1 downto 0);
        rd : out std_logic;   -- read (pop) signal
        clk : in std_logic;
        rst : in std_logic
        );
end component;

component port_in is
generic ( filename: string := ""; size: integer := 10; ival: bit_vector);
port (  full : in std_logic;
        dout : out std_logic_vector(size-1 downto 0);
        wr : out std_logic;   -- write (push) signal, active 1 on clk^
        clk : in std_logic;
        rst : in std_logic
        );
end component;

component port_out is
generic ( filename: string := "result.bin"; size: integer := 10 );
port (  empty : in std_logic; 
        din : in std_logic_vector(size-1 downto 0);
        rd : out std_logic;   -- read (pop) signal, active 1 on clk^
        clk : in std_logic;
        rst : in std_logic
        );
end component;

--~ 
--~ component split2 is
    --~ generic ( size: integer := 10);
    --~ port (  
      --~ d_f:    out std_logic;
      --~ d :     in std_logic_vector (size-1 downto 0);
      --~ d_wr :  in std_logic;
      --~ d1_f :  in std_logic; 
      --~ d1 :    out std_logic_vector(size-1 downto 0);
      --~ d1_wr : out std_logic;
      --~ d2_f :  in std_logic; 
      --~ d2 :    out std_logic_vector(size-1 downto 0);
      --~ d2_wr : out std_logic
      --~ );
--~ end component;
--~ 
--~ component split3 is
    --~ generic ( size: integer := 10);
    --~ port (  
      --~ d_f:    out std_logic;
      --~ d :     in std_logic_vector (size-1 downto 0);
      --~ d_wr :  in std_logic;
      --~ d1_f :  in std_logic; 
      --~ d1 :    out std_logic_vector(size-1 downto 0);
      --~ d1_wr : out std_logic;
      --~ d2_f :  in std_logic; 
      --~ d2 :    out std_logic_vector(size-1 downto 0);
      --~ d2_wr : out std_logic;
      --~ d3_f :  in std_logic; 
      --~ d3 :    out std_logic_vector(size-1 downto 0);
      --~ d3_wr : out std_logic
      --~ );
--~ end component;
--~ 
--~ component split4 is
    --~ generic ( size: integer := 10);
    --~ port (  
      --~ d_f:    out std_logic;
      --~ d :     in std_logic_vector (size-1 downto 0);
      --~ d_wr :  in std_logic;
      --~ d1_f :  in std_logic; 
      --~ d1 :    out std_logic_vector(size-1 downto 0);
      --~ d1_wr : out std_logic;
      --~ d2_f :  in std_logic; 
      --~ d2 :    out std_logic_vector(size-1 downto 0);
      --~ d2_wr : out std_logic;
      --~ d3_f :  in std_logic; 
      --~ d3 :    out std_logic_vector(size-1 downto 0);
      --~ d3_wr : out std_logic;
      --~ d4_f :  in std_logic; 
      --~ d4 :    out std_logic_vector(size-1 downto 0);
      --~ d4_wr : out std_logic
      --~ );
--~ end component;
--~ 
--~ component split5 is
    --~ generic ( size: integer := 10);
    --~ port (  
      --~ d_f:    out std_logic;
      --~ d :     in std_logic_vector (size-1 downto 0);
      --~ d_wr :  in std_logic;
      --~ d1_f :  in std_logic; 
      --~ d1 :    out std_logic_vector(size-1 downto 0);
      --~ d1_wr : out std_logic;
      --~ d2_f :  in std_logic; 
      --~ d2 :    out std_logic_vector(size-1 downto 0);
      --~ d2_wr : out std_logic;
      --~ d3_f :  in std_logic; 
      --~ d3 :    out std_logic_vector(size-1 downto 0);
      --~ d3_wr : out std_logic;
      --~ d4_f :  in std_logic; 
      --~ d4 :    out std_logic_vector(size-1 downto 0);
      --~ d4_wr : out std_logic;
      --~ d5_f :  in std_logic; 
      --~ d5 :    out std_logic_vector(size-1 downto 0);
      --~ d5_wr : out std_logic
      --~ );
--~ end component;
--~ 
--~ component split6 is
    --~ generic ( size: integer := 10);
    --~ port (  
      --~ d_f:    out std_logic;
      --~ d :     in std_logic_vector (size-1 downto 0);
      --~ d_wr :  in std_logic;
      --~ d1_f :  in std_logic; 
      --~ d1 :    out std_logic_vector(size-1 downto 0);
      --~ d1_wr : out std_logic;
      --~ d2_f :  in std_logic; 
      --~ d2 :    out std_logic_vector(size-1 downto 0);
      --~ d2_wr : out std_logic;
      --~ d3_f :  in std_logic; 
      --~ d3 :    out std_logic_vector(size-1 downto 0);
      --~ d3_wr : out std_logic;
      --~ d4_f :  in std_logic; 
      --~ d4 :    out std_logic_vector(size-1 downto 0);
      --~ d4_wr : out std_logic;
      --~ d5_f :  in std_logic; 
      --~ d5 :    out std_logic_vector(size-1 downto 0);
      --~ d5_wr : out std_logic;
      --~ d6_f :  in std_logic; 
      --~ d6 :    out std_logic_vector(size-1 downto 0);
      --~ d6_wr : out std_logic
      --~ );
--~ end component;

--component decoder is
--    generic ( size: integer := 8 )
--    port (
--      sel: in integer;
--      outp: std_logic_vector ( size-1 downto 0)
--      );
--end component;

end core;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- use STD.textio.all;   -- FOR DEBUG ONLY

package body core is

  function cond(e1: boolean; e2: signed; e3: signed) return signed is
  begin
    if e1 then return e2; else return e3; end if;
  end;

  function cond(e1: boolean; e2: unsigned; e3: unsigned) return unsigned is
  begin
    if e1 then return e2; else return e3; end if;
  end;

  function cond(e1: boolean; e2: std_logic_vector; e3: std_logic_vector) return std_logic_vector is
  begin
    if e1 then return e2; else return e3; end if;
  end;

  function eq(e1: signed; e2: signed) return unsigned is
  begin
     if ( e1 = e2 ) then
       return "1";
     else
       return "0";
     end if;
  end;

  function eq(e1: unsigned; e2: unsigned) return unsigned is
  begin
     if ( e1 = e2 ) then
       return "1";
     else
       return "0";
     end if;
  end;

  function maximum(L, R: INTEGER) return INTEGER is
    begin
        if L > R then
            return L;
        else
            return R;
        end if;
  end;

  function mul (e1: signed; e2: signed) return signed is
        constant length: INTEGER := maximum(e1'length, e2'length);
    begin
        return resize(e1*e2, length);
    end;

  function mul (e1: unsigned; e2: unsigned) return unsigned is
        constant length: INTEGER := maximum(e1'length, e2'length);
    begin
        return resize(e1*e2, length);
    end;

  function to_std_logic_vector(e: unsigned; s:natural) return std_logic_vector is
  begin
    return STD_LOGIC_VECTOR(resize(e,s));
  end;

  function to_std_logic_vector(e: signed; s:natural) return std_logic_vector is
  begin
    return STD_LOGIC_VECTOR(resize(e,s));
  end;

  function to_std_logic_vector(e: boolean; s:natural) return std_logic_vector is
  begin
    if e then
      return STD_LOGIC_VECTOR(TO_UNSIGNED(0,s-1)) & "1";
    else
      return STD_LOGIC_VECTOR(TO_UNSIGNED(0,s-1)) & "0";
    end if;
  end;

  function from_std_logic_vector(e: std_logic_vector; s:natural) return unsigned is
  begin
    -- return UNSIGNED(e(s-1 downto 0));
    -- return UNSIGNED(e(e'high downto e'high-s+1));
    return UNSIGNED(e(s-1 downto 0));  -- Changed in v2.6.2: in variants, fields are RIGHT justified
  end;

  function from_std_logic_vector(e: std_logic_vector; s:natural) return signed is
  begin
    -- return SIGNED(e(s-1 downto 0));
    -- return SIGNED(e(e'high downto e'high-s+1));
    return SIGNED(e(s-1 downto 0));  -- Changed in v2.6.2: in variants, fields are RIGHT justified
  end;

  function from_std_logic_vector(e: std_logic_vector; s:natural) return boolean is
  begin
    -- if e(e'high downto e'high) = "1" then
    if e(0 downto 0) = "1" then  -- Changed in v2.6.2: in variants, fields are RIGHT justified
      return true;
    else
      return false;
    end if;
  end;

  function from_std_logic_vector(e: std_logic_vector; s:natural) return std_logic_vector is
  begin
    return (e(s-1 downto 0));  -- Changed in v2.6.2: in variants, fields are RIGHT justified
    -- return e(e'high downto e'high-s+1);
  end;

  function to_bool(e: unsigned) return boolean is
  begin
    if e = (e'range=>'0') then return false; else return true; end if;
  end;
                                      
  function to_bool(e: signed) return boolean is
  begin
    if e = (e'range=>'0') then return false; else return true; end if;
  end;

  function to_bool(e: std_logic_vector) return boolean is
  begin
    if e = (e'range=>'0') then return false; else return true; end if;
  end;
                                      
  function conv_unsigned(e: unsigned; s: natural) return unsigned is
  begin
    return resize(e, s);
  end;
  
  function conv_unsigned(e: signed; s: natural) return unsigned is
  begin
    return resize(unsigned(e), s);
  end;
  
  function conv_unsigned(e: boolean; s: natural) return unsigned is
  begin
    if ( e ) then return to_unsigned(1,s); else return to_unsigned(0,s); end if;
  end;
  
  function conv_unsigned(e: integer; s: natural) return unsigned is
  begin
    return to_unsigned(e,s);
  end;
  
  function conv_signed(e: signed; s: natural) return signed is
  begin
    return resize(e, s);
  end;
  
  function conv_signed(e: unsigned; s: natural) return signed is
  begin
    return resize(signed('0' & e), s);
  end;
  
  function conv_signed(e: boolean; s: natural) return signed is
  begin
    if ( e ) then return to_signed(1,s); else return to_signed(0,s); end if;
  end;
  
  function conv_signed(e: integer; s: natural) return signed is
  begin
    return to_signed(e,s);
  end;

  function to_integer(e: integer) return integer is
  begin
    return e;
  end;

  -- Debug aux fns 

  function to_string(v : std_logic_vector) return string is
    variable s : string(1 to v'length) := (others => 'x');
    variable c : string(1 to 3);
    variable j : integer := 1;
  begin
      for i in v'high downto v'low loop
        c := std_logic'image(v(i));
        s(j to j) := c(2 to 2);  -- c is a 3 character string (with quotes) ! 
        j := j+1;
      end loop;
    return s;
  end to_string;

  procedure dump_slv(name: string; v: std_logic_vector) is
  begin
    report name & "[" & integer'image(v'high) & ":" & integer'image(v'low) & "]=" & to_string(v);
  end;

end package body core;
  
  
