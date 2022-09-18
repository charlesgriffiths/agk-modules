// Project: ref 
// Created: 22-09-15

#include "ref.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "ref" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

  for i = Random(10,50) to 0 step -1
    Ref_Init()  // simulate adding refs
  next i


type tType
  a as tRef
  b as tRef
endtype

a as tType
b as tType

  a = Type_Init()
  b = a

  // set variables in a
  Ref_SetInt( a.a, 1 )
  Ref_SetFloat( a.a, 1.1 )
  Ref_SetString( a.a, "this is a.a" )

  // set variables in b
  Ref_SetInt( b.b, 2 )
  Ref_SetFloat( b.b, 2.2 )
  Ref_SetString( b.b, "this is b.b" )

  for i = 0 to 99
    Ref_Init()  // what if there were 100 more refs
  next i

sum# as float = 1
floats# as float[]

  for i = 0 to 10
    floats#.insert( i + 1.1 )
  next i

  start = GetMilliseconds()
  for i = 0 to 1000000
    sum# = sum# + floats#[mod(i,floats#.length)]
  next i
  finish = GetMilliseconds()
  arraylooptime = finish-start
  
  start = GetMilliseconds()
  for i = 0 to 1000000
    sum# = sum# + Ref_GetFloat( a.a )
  next i
  finish = GetMilliseconds()
  reflooptime = finish-start


do
  print( "times: " + str(arraylooptime * 0.001,2) + " vs " + str(reflooptime * 0.001,2))
  print( str((reflooptime-arraylooptime) * 0.001, 2) + " microseconds difference" )

  print( "" )
  print( "a.b: " + Ref_ToString( a.b ))
  print( "b.a: " + Ref_ToString( b.a ))

  sync()
loop


function Type_Init()
t as tType

  t.a = Ref_Init()
  t.b = Ref_Init()

endfunction t

