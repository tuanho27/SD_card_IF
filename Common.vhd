----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2018 01:10:44 PM
-- Design Name: 
-- Module Name: Common - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
package CommonPckg is

  constant YES  : std_logic := '1';
  constant NO   : std_logic := '0';
  constant HI   : std_logic := '1';
  constant LO   : std_logic := '0';
  constant ONE  : std_logic := '1';
  constant ZERO : std_logic := '0';
  constant HIZ  : std_logic := 'Z';

  -- FPGA chip families.
  --type FpgaFamily_t is (KINTEX-7);

  -- work FPGA boards.
  --type XessBoard_t is (KC-705);

  -- Convert a Boolean to a std_logic.
  function BooleanToStdLogic(b : in boolean) return std_logic;

  -- Find the base-2 logarithm of a number.
  function Log2(v : in natural) return natural;

  -- Select one of two integers based on a Boolean.
  function IntSelect(s : in boolean; a : in integer; b : in integer) return integer;

  -- Select one of two reals based on a Boolean.
  function RealSelect(s : in boolean; a : in real; b : in real) return real;

  -- Convert a binary number to a graycode number.
  function BinaryToGray(b : in std_logic_vector) return std_logic_vector;

  -- Convert a graycode number to a binary number.
  function GrayToBinary(g : in std_logic_vector) return std_logic_vector;

  -- Find the maximum of two integers.
  function IntMax(a : in integer; b : in integer) return integer;
  -- Add----------------------------------------------------------
  -- Find max real number
  function REALMAX(X, Y : in REAL ) return REAL;
  
  --Floor
  function FLOOR (X : in REAL ) return REAL;
  
  --Ceil
  function CEIL (X : in REAL ) return REAL;
  
  -- Round number
  function ROUND (X : in REAL) return REAL;

  --Uniform
  procedure UNIFORM(variable SEED1, SEED2 : inout POSITIVE; variable X : out REAL);
  
end package;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


package body CommonPckg is

  -- Convert a Boolean to a std_logic.
  function BooleanToStdLogic(b : in boolean) return std_logic is
    variable s : std_logic;
  begin
    if b then
      s := '1';
    else
      s := '0';
    end if;
    return s;
  end function BooleanToStdLogic;

  -- Find the base 2 logarithm of a number.
  function Log2(v : in natural) return natural is
    variable n    : natural;
    variable logn : natural;
  begin
    n := 1;
    for i in 0 to 128 loop
      logn := i;
      exit when (n >= v);
      n    := n * 2;
    end loop;
    return logn;
  end function Log2;

  -- Select one of two integers based on a Boolean.
  function IntSelect(s : in boolean; a : in integer; b : in integer) return integer is
  begin
    if s then
      return a;
    else
      return b;
    end if;
    return a;
  end function IntSelect;

  -- Select one of two reals based on a Boolean.
  function RealSelect(s : in boolean; a : in real; b : in real) return real is
  begin
    if s then
      return a;
    else
      return b;
    end if;
    return a;
  end function RealSelect;

  -- Convert a binary number to a graycode number.
  function BinaryToGray(b : in std_logic_vector) return std_logic_vector is
    variable g : std_logic_vector(b'range);
  begin
    for i in b'low to b'high-1 loop
      g(i) := b(i) xor b(i+1);
    end loop;
    g(b'high) := b(b'high);
    return g;
  end function BinaryToGray;

  -- Convert a graycode number to a binary number.
  function GrayToBinary(g : in std_logic_vector) return std_logic_vector is
    variable b : std_logic_vector(g'range);
  begin
    b(b'high) := g(b'high);
    for i in g'high-1 downto g'low loop
      b(i) := b(i+1) xor g(i);
    end loop;
    return b;
  end function GrayToBinary;

  -- Find the maximum of two integers.
  function IntMax(a : in integer; b : in integer) return integer is
  begin
    if a > b then
      return a;
    else
      return b;
    end if;
    return a;
  end function IntMax;
  -- work Add --------------------------------------------------------
  --Floor
      function FLOOR (X : in REAL ) return REAL is
      -- Description:
      --        See function declaration in IEEE Std 1076.2-1996
      -- Notes:
      --        a) No conversion to an INTEGER type is expected, so truncate
      --           cannot overflow for large arguments
      --        b) The domain supported by this function is ABS(X) <= LARGE
      --        c) Returns X if ABS(X) >= LARGE

      constant LARGE: REAL  := REAL(INTEGER'HIGH);
      variable RD: REAL;

  begin
      if ABS( X ) >= LARGE then
                  return X;
      end if;

      RD := REAL ( INTEGER(X));
      if RD = X then
              return X;
      end if;

      if X > 0.0 then
                    if RD <= X then
                                return RD;
                     else
                                return RD - 1.0;
                     end if;
      elsif  X = 0.0  then
              return 0.0;
      else
                 if RD >= X then
                                return RD - 1.0;
                 else
                                return RD;
                 end if;
      end if;
  end function FLOOR;
  --Cecil
     function CEIL (X : in REAL ) return REAL is
       -- Description:
       --        See function declaration in IEEE Std 1076.2-1996
       -- Notes:
       --        a) No conversion to an INTEGER type is expected, so truncate
       --           cannot overflow for large arguments
       --        b) The domain supported by this function is X <= LARGE
       --        c) Returns X if ABS(X) >= LARGE

       constant LARGE: REAL  := REAL(INTEGER'HIGH);
       variable RD: REAL;

   begin
        if ABS(X) >= LARGE then
              return X;
        end if;

        RD := REAL ( INTEGER(X));
        if RD = X then
           return X;
        end if;

           if X > 0.0 then
                      if RD >= X then
                                 return RD;
                      else
                                 return RD + 1.0;
                      end if;
           elsif  X = 0.0  then
               return 0.0;
           else
                      if RD <= X then
                                 return RD + 1.0;
                      else
                                 return RD;
                      end if;
           end if;
   end function CEIL;

  -- Round number
  function ROUND (X : in REAL ) return REAL is
          -- Description:
          --        See function declaration in IEEE Std 1076.2-1996
          -- Notes:
          --         a) Returns 0.0 if X = 0.0
          --         b) Returns FLOOR(X + 0.5) if X > 0
          --         c) Returns CEIL(X - 0.5) if X < 0
  
      begin
             if  X > 0.0  then
                  return FLOOR(X + 0.5);
             elsif  X < 0.0  then
                  return CEIL( X - 0.5);
             else
                  return 0.0;
             end if;
      end function ROUND;
      
  -- Find real maximum number
      function REALMAX (X, Y : in REAL ) return REAL is
      -- Description:
      --        See function declaration in IEEE Std 1076.2-1996
      -- Notes:
      --        a) REALMAX(X,Y) = X when X = Y
      --
  begin
      if X >= Y then
         return X;
      else
         return Y;
      end if;
  end function REALMAX;

   procedure UNIFORM(variable SEED1,SEED2:inout POSITIVE;variable X:out REAL)
                                                                         is
        -- Description:
        --        See function declaration in IEEE Std 1076.2-1996
        -- Notes:
        --        a) Returns 0.0 on error
        --
        variable Z, K: INTEGER;
        variable TSEED1 : INTEGER := INTEGER'(SEED1);
        variable TSEED2 : INTEGER := INTEGER'(SEED2);
    begin
        -- Check validity of arguments
        if SEED1 > 2147483562 then
                assert FALSE
                        report "SEED1 > 2147483562 in UNIFORM"
                        severity ERROR;
                X := 0.0;
                return;
        end if;

        if SEED2 > 2147483398 then
                assert FALSE
                        report "SEED2 > 2147483398 in UNIFORM"
                        severity ERROR;
                X := 0.0;
                return;
        end if;

        -- Compute new seed values and pseudo-random number
        K := TSEED1/53668;
        TSEED1 := 40014 * (TSEED1 - K * 53668) - K * 12211;

        if TSEED1 < 0  then
                TSEED1 := TSEED1 + 2147483563;
        end if;

        K := TSEED2/52774;
        TSEED2 := 40692 * (TSEED2 - K * 52774) - K * 3791;

        if TSEED2 < 0  then
                TSEED2 := TSEED2 + 2147483399;
        end if;

        Z := TSEED1 - TSEED2;
        if Z < 1 then
                Z := Z + 2147483562;
        end if;

        -- Get output values
        SEED1 := POSITIVE'(TSEED1);
        SEED2 := POSITIVE'(TSEED2);
        X :=  REAL(Z)*4.656613e-10;
    end procedure UNIFORM;

  
end package body;

