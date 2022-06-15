
// Project: checkbox 
// Created: 22-05-20

#include "checkbox.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "checkbox" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

cb as tCheckBoxState
check as integer
uncheck as integer

  check = CreateSprite( 0 )
  SetSpriteSize( check, 50, 50 )
  uncheck = CloneSprite( check )
  SetSpriteColorAlpha( uncheck, 96 )

  cb = CheckBox_Init( 100, 384, check, uncheck )

  DeleteSprite( check )
  DeleteSprite( uncheck )

  text = CreateText( "" )
  SetTextPosition( text, 165, 384 )
  SetTextSize( text, 50 )

do
  if CheckBox_Uncheck = CheckBox_GetState( cb )
    SetTextString( text, "Check this box." )
  else
    SetTextString( text, "Good job!" )
  endif

  Print( ScreenFPS() )
    
  CheckBox_UpdateMouse( cb )
  Sync()
loop
