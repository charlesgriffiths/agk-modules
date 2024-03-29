// File: int.agc
// Created: 22-09-15
//
//  Copyright 2022 Charles Griffiths
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//
// https://github.com/charlesgriffiths/agk-modules/blob/main/other/int/int.agc


type tInt
  digits as integer[]
  power as integer
  precision as integer
  bNegative as integer
endtype

type tIntBase
  digits as integer[]
  power as integer
  precision as integer
  base as integer
  bNegative as integer
endtype


function Int_Init( value as integer )
n as tInt

  if value >= 0
    Int_AddDigit( n, 0, value )
  else
    part = value/2
    Int_AddDigit( n, 0, Abs(part))
    dec value, part
    Int_AddDigit( n, 0, Abs(value))
    n.bNegative = 1
  endif

endfunction n


function Int_Init$( value$ as string )
n as tInt

  for i = 1 to len(value$)
    char$ = mid( value$, i, 1 )
    if CompareString( "-", char$ ) and Int_EqualsInt( n, 0 )
      n.bNegative = 1
    else
      n = Int_MultiplyInt( n, 10 )
      Int_AddDigit( n, 0, Val(char$))
    endif
  next i

endfunction n


function Int_Init#( value# as float )
n as tInt
bNegative as integer
floats# as float[]
ints as tInt[]

  if value# < 0 then bNegative = 1
  value# = Abs( value# )

  ints.insert( Int_Init( 1 ))
  floats#.insert( 1.0 )

  while value# > floats#[floats#.length]
    floats#.insert( 2 * floats#[floats#.length] )
    ints.insert( Int_MultiplyInt( ints[ints.length], 2 ))
  endwhile

  for i = ints.length to 0 step -1
    if value# >= floats#[i]
      dec value#, floats#[i]
      n = Int_Add( n, ints[i] )
    endif
  next i

  n.bNegative = bNegative

endfunction n


function Int_SetPrecision( n ref as tInt, precision as integer )

  if precision > 0
    while n.digits.length + 1 > precision
      inc n.power
      n.digits.remove( 0 )
    endwhile
    n.precision = precision
  else
    n.precision = 0
  endif

  while n.digits.length >= 0
    if not n.digits[n.digits.length]
      n.digits.remove( n.digits.length )
    else
      exit
    endif
  endwhile

  Int_RemoveLeadingZeros( n )

endfunction


function Int_RemoveLeadingZeros( n ref as tInt )

  while n.digits.length >= 0
    if not n.digits[0]
      inc n.power
      n.digits.remove( 0 )
    else
      exit
    endif
  endwhile

endfunction


function Int_Equals( n1 ref as tInt, n2 ref as tInt )
index as integer

  index = n1.power + n1.digits.length + 1
  if index < n2.power + n2.digits.length + 1 then index = n2.power + n2.digits.length + 1
  
  while index >= n1.power or index >= n2.power
    if Int_DigitAt( n1, index ) <> Int_DigitAt( n2, index ) then exitfunction 0
    dec index
  endwhile

endfunction 1


function Int_EqualsInt( n1 ref as tInt, n2 as integer )
  exitfunction Int_Equals( n1, Int_Init(n2))
endfunction 0


function Int_GT( n1 ref as tInt, n2 ref as tInt )
index as integer

  index = n1.power + n1.digits.length
  if index < n2.power + n2.digits.length then index = n2.power + n2.digits.length
  inc index

  while index >= n1.power or index >= n2.power
    a = Int_DigitAt( n1, index )
    b = Int_DigitAt( n2, index )
    if a > b then exitfunction 1
    if a < b then exitfunction 0
    dec index
  endwhile

endfunction 0


function Int_GE( n1 ref as tInt, n2 ref as tInt )
  exitfunction not Int_LT( n1, n2 )
endfunction 0


function Int_LT( n1 ref as tInt, n2 ref as tInt )
index as integer

  index = n1.power + n1.digits.length
  if index < n2.power + n2.digits.length then index = n2.power + n2.digits.length
  inc index

  while index >= n1.power or index >= n2.power
    a = Int_DigitAt( n1, index )
    b = Int_DigitAt( n2, index )
    if a < b then exitfunction 1
    if a > b then exitfunction 0
    dec index
  endwhile

endfunction 0


function Int_LE( n1 ref as tInt, n2 ref as tInt )
  exitfunction not Int_GT( n1, n2 )
endfunction 0


function Int_DigitAt( n ref as tInt, place as integer )
digit as integer = 0

  dec place, n.power
  if place >= 0 and place <= n.digits.length then digit = n.digits[place]

endfunction digit


function Int_AddDigit( n ref as tInt, place as integer, value as integer )

  while n.digits.length >= 0
    if not n.digits[n.digits.length]
      n.digits.remove( n.digits.length )
    else
      exit
    endif
  endwhile
  
  if value
    index = place - n.power

    while index < 0 and n.power > 0
      inc index
      dec n.power
      if -1 = n.digits.length
        n.digits.insert( 0 )
      else
        n.digits.insert( 0, 0 )
      endif
      if n.precision > 0 and n.digits.length > n.precision+2 then exit
    endwhile

    if index > n.digits.length then n.digits.length = index
    if index < 0 then exitfunction
    inc value, n.digits[index]
    if value < 0
      borrow = 0
      while value < 0
        inc borrow
        inc value, 0x10000
      endwhile
      n.digits[index] = value
      Int_AddDigit( n, place+1, -borrow )
    else
      n.digits[index] = value && 0xffff
      value = (value >> 16) && 0xffff
      if value then Int_AddDigit( n, place+1, value )
    endif
  endif

endfunction


function Int_Negate( n ref as tInt )
neg as tInt

  neg = n
  neg.bNegative = not n.bNegative

endfunction neg


function Int_Add( n1 ref as tInt, n2 ref as tInt )
n as tInt

  if n1.bNegative and n2.bNegative  // both negative
  a as tInt
  b as tInt

    a = n1 : a.bNegative = 0
    b = n2 : b.bNegative = 0
    n = Int_Add( a, b )
    n.bNegative = 1
    exitfunction n
  endif

  if n1.bNegative and not n2.bNegative  // negative adding positive
    n = n1
    n.bNegative = 0
    n = Int_Subtract( n, n2 )
    exitfunction Int_Negate( n )
  endif

  if n2.bNegative   // positive adding negative
    n = n2
    n.bNegative = 0
    exitfunction Int_Subtract( n1, n )
  endif

  n = n1
  for i = 0 to n2.digits.length
    Int_AddDigit( n, i+n2.power, n2.digits[i] )
  next i

  Int_SetPrecision( n, n1.precision )

endfunction n


function Int_AddInt( n1 ref as tInt, n2 as integer )
n as tInt

  n = Int_Add( n1, Int_Init( n2 ))

endfunction n


function Int_Subtract( n1 ref as tInt, n2 ref as tInt )
n as tInt

  if n1.bNegative and n2.bNegative  // both negative
  a as tInt
  b as tInt

    a = n1 : a.bNegative = 0
    b = n2 : b.bNegative = 0
    n = Int_Subtract( a, b )
    n.bNegative = not n.bNegative
    exitfunction n
  endif

  if n1.bNegative and not n2.bNegative  // negative subtracting positive
    n = n1
    n.bNegative = 0
    n = Int_Add( n, n2 )
    n.bNegative = 1
    exitfunction n
  endif

  if n2.bNegative  // positive subtracting negative
    n = n2
    n.bNegative = 0
    exitfunction Int_Add( n1, n )
  endif

  // not n1.bNegative and not n2.bNegative
  if Int_GE( n1, n2 )    // both positive
    n = n1
    for i = 0 to n2.digits.length
      Int_AddDigit( n, n2.power + i, -n2.digits[i] )
    next i
    Int_SetPrecision( n, n1.precision )
  else
    n = Int_Subtract( n2, n1 )
    n.bNegative = 1
  endif

endfunction n


function Int_SubtractInt( n1 ref as tInt, n2 as integer )
n as tInt

  n = Int_Subtract( n1, Int_Init( n2 ))

endfunction n



function Int_Multiply( n1 ref as tInt, n2 ref as tInt )
n as tInt

  n.power = n1.power + n2.power
  for i = 0 to n1.digits.length
    for j = 0 to n2.digits.length
      product = n1.digits[i] * n2.digits[j]
      Int_AddDigit( n, n.power + i + j, product && 0xffff )
      Int_AddDigit( n, n.power + i + j + 1, (product >> 16) && 0xffff )
    next j
  next i

  if n1.bNegative then n.bNegative = not n.bNegative
  if n2.bNegative then n.bNegative = not n.bNegative
  Int_SetPrecision( n, n1.precision )

endfunction n


function Int_MultiplyInt( n1 ref as tInt, n2 as integer )
n as tInt

  n = Int_Multiply( n1, Int_Init( n2 ))

endfunction n


function Int_Divide( n1 ref as tInt, n2 as tInt )
n as tInt
values as tInt[]
adds as tInt[]
remainder as tInt
n2negative as integer

  if Int_EqualsInt( n2, 0 ) then exitfunction n
  n2negative = n2.bNegative
  n2.bNegative = 0

  values.insert( n2 )
  adds.insert( Int_Init( 1 ))
  while Int_GT( n1, values[values.length] )
    values.insert( Int_MultiplyInt( values[values.length], 2 ))
    adds.insert( Int_MultiplyInt( adds[adds.length], 2 ))
  endwhile

  remainder = n1
  remainder.bNegative = 0
  for i = values.length to 0 step -1
    if Int_GE( remainder, values[i] )
      remainder = Int_Subtract( remainder, values[i] )
      n = Int_Add( n, adds[i] )
    endif
  next i

  if n1.bNegative then n.bNegative = not n.bNegative
  if n2negative then n.bNegative = not n.bNegative

  Int_SetPrecision( n, n1.precision )

endfunction n


function Int_DivideInt( n1 ref as tInt, n2 as integer )
n as tInt

  n = Int_Divide( n1, Int_Init( n2 ))

endfunction n


function Int_Mod( n1 ref as tInt, n2 as tInt )
n as tInt
values as tInt[]
adds as tInt[]
remainder as tInt
n2negative as integer

  if Int_EqualsInt( n2, 0 ) then exitfunction n
  n2negative = 1
  n2.bNegative = 0

  values.insert( n2 )
  adds.insert( Int_Init( 1 ))
  while Int_GT( n1, values[values.length] )
    values.insert( Int_MultiplyInt( values[values.length], 2 ))
    adds.insert( Int_MultiplyInt( adds[adds.length], 2 ))
  endwhile

  remainder = n1
  remainder.bNegative = 0
  for i = values.length to 0 step -1
    if Int_GE( remainder, values[i] )
      remainder = Int_Subtract( remainder, values[i] )
      n = Int_Add( n, adds[i] )
    endif
  next i

  if n1.bNegative < 0 then remainder.bNegative = not remainder.bNegative
  if n2negative then remainder.bNegative = not remainder.bNegative

endfunction remainder


function Int_ModInt( n1 ref as tInt, n2 as integer )
remainder as tInt

  remainder = Int_Mod( n1, Int_Init( n2 ))

endfunction remainder


function Int_Pow( n1 ref as tInt, n2 as integer )
factors as tInt[]
powers as integer[]
n as tInt

  n = Int_Init( 1 )
  factors.insert( n1 )
  powers.insert( 1 )
  while powers[powers.length] < n2
    factors.insert( Int_Multiply( factors[factors.length], factors[factors.length] ))
    powers.insert( 2 * powers[powers.length] )
  endwhile

  for i = factors.length to 0 step -1
    if n2 >= powers[i]
      n = Int_Multiply( n, factors[i] )
      dec n2, powers[i]
    endif
  next i

  Int_SetPrecision( n, n1.precision )

endfunction n


// for negative n, return the log of Abs(n)
function Int_Log( n ref as tInt )

  Int_RemoveLeadingZeros( n )

  if -1 = n.digits.length
    exitfunction log( 0 )
  elseif 0 = n.digits.length
    exitfunction log( n.digits[0] ) + n.power * log( 65536 )
  else
    exitfunction log( n.digits[n.digits.length] + n.digits[n.digits.length-1]/65536.0 ) + (n.power + n.digits.length) * log( 65536 )
  endif

endfunction 0.0


function Int_ToString10( n ref as tInt )
values as tInt[]
digits as integer[]
remainder as tInt

  values.insert( Int_Init( 1 ))
  while Int_GT( n, values[values.length] )
    values.insert( Int_MultiplyInt( values[values.length], 10 ))
  endwhile

  remainder = n
  remainder.bNegative = 0
  digits.length = values.length
  for i = values.length to 0 step -1
    while Int_GE( remainder, values[i] )
      remainder = Int_Subtract( remainder, values[i] )
      inc digits[i]
    endwhile
  next i

  while digits.length > 0
    if not digits[digits.length]
      digits.remove( digits.length )
    else
      exit
    endif
  endwhile

s$ as string = ""

  if n.bNegative then s$ = "-"

  for i = digits.length to 0 step -1
    s$ = s$ + str(digits[i])
  next i

endfunction s$


function Int_ConvertBase( n ref as tInt, base as integer, precision as integer )
values as tInt[]
remainder as tInt
conversion as tIntBase

  conversion.bNegative = n.bNegative
  if precision < 1 then precision = 1
  conversion.digits.length = precision-1
  conversion.precision = precision
  conversion.base = base

  values.insert( Int_Init( 1 ))
  while Int_GT( n, values[values.length] )
    values.insert( Int_MultiplyInt( values[values.length], base ))
  endwhile

  remainder = n
  remainder.bNegative = 0

digit as integer = 0

  for i = values.length to 0 step -1
    while Int_GE( remainder, values[i] )
      remainder = Int_Subtract( remainder, values[i] )
      inc conversion.digits[digit]
    endwhile
    if i > 0 and (digit > 0 or conversion.digits[digit] > 0) then inc digit
    if digit > conversion.digits.length
      conversion.power = i
      exit
    endif
  next i
  if digit < conversion.digits.length then conversion.digits.length = digit

endfunction conversion


function Int_ToStringRaw( n ref as tInt )
s$ as string

  if n.bNegative then s$ = "- "
  s$ = s$ + "precision: " + str(n.precision) + " "
  for i = 0 to n.digits.length
    s$ = s$ + str( n.digits[i] ) + " "
  next i
  s$ = s$ + "e" + str(n.power)

endfunction s$


function Int_ToStringRawB( n ref as tIntBase )
s$ as string

  if n.bNegative then s$ = "- "
  s$ = s$ + "precision: " + str(n.precision) + " "
  s$ = s$ + "base: " + str(n.base) + " ( "
  for i = 0 to n.digits.length
    s$ = s$ + str( n.digits[i] ) + " "
  next i
  s$ = s$ + ") e" + str(n.power)

endfunction s$

