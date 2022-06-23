
// Project: shaker 
// Created: 22-06-20

#include "shaker.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "shaker" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )


sh as tShakerState

  sh = Shaker_Init()

  text = CreateText( "One" )
  SetTextSize( text, 50 )
  SetTextPosition( text, 100, 100 )
  
  text2 = CreateText( "Two" )
  SetTextSize( text2, 40 )
  SetTextPosition( text2, 500, 120 )
  SetTextColor( text2, 255, 0, 0, 255 )
  
  text3 = CreateText( "Steady" )
  SetTextSize( text3, 30 )
  SetTextPosition( text3, 750, 110 )
  SetTextColor( text3, 0, 255, 0, 255 )
  
  sprite = CreateSprite( 0 )
  SetSpriteSize( sprite, 50, 50 )
  SetSpritePosition( sprite, 150, 200 )
  
  sprite2 = CreateSprite( 0 )
  SetSpriteSize( sprite2, 40, 40 )
  SetSpritePosition( sprite2, 550, 250 )
  SetSpriteColor( sprite2, 0, 255, 0, 255 )
  
  sprite3 = CreateSprite( 0 )
  SetSpriteSize( sprite3, 30, 30 )
  SetSpritePosition( sprite3, 800, 240 )
  SetSpriteColor( sprite3, 255, 0, 0, 255 )
  
  Shaker_AddText( sh, text )
  Shaker_AddText( sh, text2 )
  Shaker_AddSprite( sh, sprite )
  Shaker_AddSprite( sh, sprite2 )
  // text3 and sprite3 are not added to shaker so they only shake when the screen shakes

//  Shaker_ShakeTogether( sh )
  Shaker_ShakeSeparately( sh )
//  Shaker_ShakeScreen( sh )

  do
    Shaker_Update( sh )

    Print( str(sh.distance) + "  " + str(sh.seconds#,2) + "  " + str(sh.frequency#,2) + "  " + str(sh.shakeprogress#,2))
    Print( ScreenFPS() )
    Sync()
  loop

