
// Project: spritelist 
// Created: 22-06-15

#include "spritelist.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "spritelist" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

sl as tSpriteListState

  sl = SpriteList_Init( 100, 300, 200, 350, 5 )

sl2 as tSpriteListState

  sl2 = SpriteList_Init( 350, 300, 200, 400, 5 )

sl3 as tSpriteListState

  sl3 = SpriteList_Init( 600, 300, 200, 450, 5 )


  sprite = CreateSprite( 0 )
  SetSpriteSize( sprite, 200, 50 )
  for i = 0 to 20
    SetSpriteColor( sprite, Random( 128, 255 ), Random( 128, 255 ), Random( 128, 255 ), 255 )
    SpriteList_AppendSprite( sl, sprite )
    SpriteList_InsertSprite( sl2, sprite, 0 )
  next i

  sl2.topindex = 0

  SpriteList_AppendSprite( sl3, sprite )

//  SpriteList_SetActive( sl2, 0 )
//  SpriteList_SetVisible( sl3, 0 )
  
do
    SpriteList_UpdateMouse( sl )
    SpriteList_UpdateMouse( sl2 )
    SpriteList_UpdateMouse( sl3 )


    color = MakeColor( 255, 0, 0 )
    SpriteList_DrawOutline( sl, color )
    SpriteList_DrawOutline( sl2, color )
    SpriteList_DrawOutline( sl3, color )

    SetSpritePosition( sprite, 100, 200 )
    x# = GetSpriteX( sprite )
    y# = GetSpriteY( sprite )
    color = MakeColor( 255, 0, 0 )
    DrawBox( x#, y#, x#+GetSpriteWidth( sprite ), y#+GetSpriteHeight( sprite ), color, color, color, color, 0 )


    Print( ScreenFPS() )
    Sync()
  loop

  SpriteList_Delete( sl )
  SpriteList_Delete( sl2 )
  SpriteList_Delete( sl3 )

