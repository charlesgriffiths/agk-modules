
// Project: radiobutton 
// Created: 22-06-07

#include "radiobutton.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "radiobutton" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )


rb as tRadioButtonState
check as integer
uncheck as integer

  check = CreateSprite( 0 )
  SetSpriteSize( check, 50, 50 )
  uncheck = CloneSprite( check )
  SetSpriteColorAlpha( uncheck, 96 )

  rb = RadioButton_Init( 100, 384, 55, 4, check, uncheck )

  DeleteSprite( check )
  DeleteSprite( uncheck )

  text = CreateText( "Check a box." )
  SetTextPosition( text, 165, 384 )
  SetTextSize( text, 50 )

  RadioButton_SetState( rb, 0 )
  RadioButton_SetAllowUnselect( rb, 0 )

do
    Print( ScreenFPS() )
    
    RadioButton_UpdateMouse( rb )
    Sync()
loop

