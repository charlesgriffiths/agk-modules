// Project: Int 
// Created: 22-09-15

#include "int.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "Int" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 5, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

n as tInt
n2 as tInt
n3 as tInt

  n2 = Int_Init( 1 )
  Int_SetPrecision( n2, 5 )

  n3 = n2

loops as integer = 0

do
  add = Random( 1, 0xffff ) + (Random( 0, 0x7fff ) << 16)
  n = Int_AddInt( n, add )
  print( Int_ToStringRaw( n ))
  print( Int_ToString10( n ))
//  print( str(add) )

  inc loops
  n2 = Int_MultiplyInt( n2, loops )
  print( Int_ToStringRaw( n2 ))
  print( str(loops) + "! " + Int_ToString10( n2 ))
  print( str(Int_Log(n2)) )
  
ndiv as tInt

  ndiv = n2
  for i = loops to 1 step -1
//    ndiv = Int_DivideInt( ndiv, i )
    ndiv = Int_Divide( ndiv, Int_Init(i) )
    print( Int_ToString10( ndiv ))
    if i < loops-3 then exit
  next i
  
  print("")

  n3 = Int_MultiplyInt( n3, 2 )
  print( Int_ToStringRaw( n3 ))
  print( Int_ToString10( n3 ))
  print( str(Int_Log(n3)) )

  print("")

nlog as tInt

  nlog = Int_Init( 0 )
  print( "0: " + Int_ToString10( nlog ) + " " + str(Int_Log(nlog),2) + " " + str(log(0),2))

  nlog = Int_Init( 1 )
  print( "1: " + Int_ToString10( nlog ) + " " + str(Int_Log(nlog),2) + " " + str(log(1),2))

  nlog = Int_Init( 10 )
  print( "10: " + Int_ToString10( nlog ) + " " + str(Int_Log(nlog),2) + " " + str(log(10),2))

  nlog = Int_Init( 1000 )
  print( "1000: " + Int_ToString10( nlog ) + " " + str(Int_Log(nlog),2) + " " + str(log(1000),2))

  nlog = Int_Init( 1000000 )
  print( "1000000: " + Int_ToString10( nlog ) + " " + str(Int_Log(nlog),2) + " " + str(log(1000000),2))


  sync()
loop

