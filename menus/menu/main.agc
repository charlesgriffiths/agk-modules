
// Project: menu 
// Created: 22-06-15

#include "menu.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "menu" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

spritelist as integer[]

  sprite = CreateSprite( 0 )
  SetSpriteSize( sprite, 200, 50 )
  for i = 1 to 5
    s = CloneSprite( sprite )
    SetSpriteColor( s, Random( 128, 255 ), Random( 128, 255 ), Random( 128, 255 ), 255 )
    spritelist.insert( s )
  next i


m as tMenuState

  m = Menu_Init( 100, 300, 10, spritelist )

m2 as tMenuState

  m2 = Menu_Init( 450, 300, 15, spritelist )


  DeleteSprite( sprite )
  for i = 0 to spritelist.length
    DeleteSprite( spritelist[i] )
  next i

choice as integer = -1
choice2 as integer = -1

  color = MakeColor( 0, 0, 0, 255 )

  Menu_SetText( m, 0, "Right", 50, color, Menu_AlignRight, -20 )
  Menu_SetText( m, 1, "Left", 50, color, Menu_AlignLeft, 20 )
  Menu_SetText( m, 2, "Center", 50, color, Menu_Center, 0 )
  Menu_SetText( m, 3, "Center 40", 40, color, Menu_Center, 0 )
  Menu_SetText( m, 4, "This text is far far too long", 30, color, Menu_Center, 0 )

  Menu_SetText( m2, 0, "One", 50, color, Menu_Center, 0 )
  Menu_SetText( m2, 1, "Two", 50, color, Menu_Center, 0 )
  Menu_SetText( m2, 2, "Three", 50, color, Menu_Center, 0 )
  Menu_SetText( m2, 3, "Four", 50, color, Menu_Center, 0 )
  Menu_SetText( m2, 4, "Five", 50, color, Menu_Center, 0 )


//  Menu_SetVisible( m2, 0 )

  do
    ret = Menu_UpdateMouse( m )
    ret2 = Menu_UpdateMouse( m2 )

    if ret <> -1 then choice = ret
    if ret2 <> -1 then choice2 = ret2

    color = MakeColor( 255, 0, 0 )
    Menu_DrawOutline( m, color )
    Menu_DrawOutline( m2, color )

//  Menu_SetVisible( m, 0 )
//  Menu_SetVisible( m2, 1 )

    Print( ScreenFPS() )
    Print( "Recent menu choices: " + str( choice ) + " and " + str( choice2 ) )
    Sync()
  loop

  Menu_Delete( m )
  Menu_Delete( m2 )

