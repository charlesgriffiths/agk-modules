
// Project: textchoice 
// Created: 22-06-20

#include "textchoice.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "textchoice" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )


  text = CreateText( "Choose A Class" )
  SetTextSize( text, 50 )
  SetTextPosition( text, 100, 240 )

tc as tTextChoiceState

  tc = TextChoice_Init( 100, 300, 30, 3, 10, 15 )
  TextChoice_AddChoice( tc, "Paladin" )
  TextChoice_AddChoice( tc, "Monk" )
  TextChoice_AddChoice( tc, "Ninja" )
  TextChoice_AddChoice( tc, "Thief" )
  TextChoice_AddChoice( tc, "Wizard" )
  TextChoice_AddChoice( tc, "Talented" )

  TextChoice_SetSelectOnlyOne( tc, 1 )


  text = CreateText( "Choose Skills" )
  SetTextSize( text, 50 )
  SetTextPosition( text, 500, 190 )

tc2 as tTextChoiceState

  tc2 = TextChoice_Init( 550, 250, 30, 1, 0, 10 )
  TextChoice_AddChoice( tc2, "Fighting" )
  TextChoice_AddChoice( tc2, "Drinking" )
  TextChoice_AddChoice( tc2, "Chess" )
  TextChoice_AddChoice( tc2, "Sneakery" )
  TextChoice_AddChoice( tc2, "Magic" )
  TextChoice_AddChoice( tc2, "Lucky" )

  TextChoice_SetSelectedBold( tc2, 0 )
  TextChoice_SetSelectedColor( tc2, MakeColor( 255, 0, 0, 255 ))

//  TextChoice_ClearChoices( tc2 )


do
  TextChoice_UpdateMouse( tc )
  TextChoice_UpdateMouse( tc2 )

  Print( ScreenFPS() )
  Print( intarraytostring( tc.selected ))
  Print( intarraytostring( tc2.selected ))
  Sync()
loop


function intarraytostring( arr as integer[] )
str$ as string = ""

  for i = 0 to arr.length
    str$ = str$ + str( arr[i] ) + " "
  next i

endfunction str$

