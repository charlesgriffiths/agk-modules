
// Project: multicheckbox 
// Created: 22-06-07

#include "multicheckbox.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "multicheckbox" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

mc as tMultiCheckBoxState
sprites as integer[]

  sprites.insert( CreateSprite( 0 ))
  SetSpriteSize( sprites[0], 50, 50 )
  
  sprites.insert( CloneSprite( sprites[0] ))
  SetSpriteColorAlpha( sprites[1], 96 )

  sprites.insert( CloneSprite( sprites[0] ))
  SetSpriteColorRed( sprites[2], 0 )
  
  sprites.insert( CloneSprite( sprites[0] ))
  SetSpriteColorGreen( sprites[3], 0 )
  
  sprites.insert( CloneSprite( sprites[0] ))
  SetSpriteColorBlue( sprites[4], 0 )
  
  
  mc = MultiCheckBox_Init( 100, 384, sprites )

  for i = 0 to sprites.length
    DeleteSprite( sprites[i] )
  next i

  text = CreateText( "Check this box." )
  SetTextPosition( text, 165, 384 )
  SetTextSize( text, 50 )

  do
    MultiCheckBox_UpdateMouse( mc )

    Print( ScreenFPS() )
    Sync()
  loop

  MultiCheckBox_Delete( mc )

