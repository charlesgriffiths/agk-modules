
// Project: cursor 
// Created: 22-06-16

#include "cursor.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "cursor" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )


c as tCursorState

  sprite = CreateSprite( 0 )
  SetSpriteSize( sprite, 50, 5 )
  SetSpritePosition( sprite, 10, 500 )

  c = Cursor_Init( sprite )
  SetSpriteColorAlpha( sprite, 0 )
  Cursor_AddChange( c, 1.8, -1, 0, sprite )
  SetSpriteColorAlpha( sprite, 255 )
  Cursor_AddChange( c, 0.2, -1, 0, sprite )
  text = CreateText( "1" )
  SetTextSize( text, 50 )
  SetTextPosition( text, 25, 530 )

c2 as tCursorState

  SetSpritePosition( sprite, 80, 500 )
  c2 = Cursor_Init( sprite )
  Cursor_AddChange( c2, 1, TweenLinear(), 180, sprite )
  text = CreateText( "2" )
  SetTextSize( text, 50 )
  SetTextPosition( text, 95, 530 )

c3 as tCursorState

  SetSpritePosition( sprite, 150, 500 )
  c3 = Cursor_Init( sprite )
  SetSpritePosition( sprite, 150, 480 )
  Cursor_AddChange( c3, 1, TweenLinear(), 0, sprite )
  Cursor_ChangeRestore( c3, 1, TweenLinear(), 0 )
  text = CreateText( "3" )
  SetTextSize( text, 50 )
  SetTextPosition( text, 165, 530 )

c4 as tCursorState

  SetSpritePosition( sprite, 220, 500 )
  c4 = Cursor_Init( sprite )
  Cursor_AddChange( c4, 1, TweenLinear(), -360, sprite )
  text = CreateText( "4" )
  SetTextSize( text, 50 )
  SetTextPosition( text, 235, 530 )

c5 as tCursorState

  SetSpritePosition( sprite, 290, 500 )
  c5 = Cursor_Init( sprite )
  SetSpritePosition( sprite, 310, 470 )
  Cursor_AddChange( c5, 1, TweenEaseOut1(), 0, sprite )
  SetSpritePosition( sprite, 330, 500 )
  Cursor_AddChange( c5, 1, TweenEaseIn1(), 0, sprite )
  SetSpritePosition( sprite, 310, 470 )
  Cursor_AddChange( c5, 1, TweenEaseOut1(), 0, sprite )
  Cursor_ChangeRestore( c5, 1, TweenEaseIn1(), 0 )
  text = CreateText( "5" )
  SetTextSize( text, 50 )
  SetTextPosition( text, 325, 530 )

c6 as tCursorState

  SetSpritePosition( sprite, 400, 500 )
  c6 = Cursor_Init( sprite )
  SetSpriteColorRed( sprite, 0 )
  Cursor_AddChange( c6, 2, TweenSmooth1(), 0, sprite )
  Cursor_ChangeRestore( c6, 2, TweenSmooth1(), 0 )
  text = CreateText( "6" )
  SetTextSize( text, 50 )
  SetTextPosition( text, 415, 530 )

c7 as tCursorState

  SetSpritePosition( sprite, 470, 500 )
  c7 = Cursor_Init( sprite )
  SetSpriteColorBlue( sprite, 0 )
  Cursor_AddChange( c7, 1, TweenSmooth1(), 0, sprite )
  SetSpriteColorRed( sprite, 255 )
  Cursor_AddChange( c7, 1, TweenSmooth1(), 0, sprite )
  Cursor_ChangeRestore( c7, 1, TweenSmooth1(), 0 )
  text = CreateText( "7" )
  SetTextSize( text, 50 )
  SetTextPosition( text, 485, 530 )

c8 as tCursorState

  SetSpritePosition( sprite, 540, 500 )
  c8 = Cursor_Init( sprite )
  SetSpriteColorGreen( sprite, 0 )
  Cursor_AddChange( c8, 1, -1, 0, sprite )
  Cursor_ChangeRestore( c8, 1, -1, 0 )
  text = CreateText( "8" )
  SetTextSize( text, 50 )
  SetTextPosition( text, 555, 530 )



  DeleteSprite( sprite )

//  Cursor_SetVisible( c6, 0 )
//  Cursor_SetActive( c5, 0 )

do
  Cursor_Update( c )
  Cursor_Update( c2 )
  Cursor_Update( c3 )
  Cursor_Update( c4 )
  Cursor_Update( c5 )
  Cursor_Update( c6 )
  Cursor_Update( c7 )
  Cursor_Update( c8 )

  UpdateAllTweens(GetFrameTime())
  Print( ScreenFPS() )
  Sync()
loop
