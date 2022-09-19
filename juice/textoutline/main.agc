// Project: textoutline 
// Created: 22-09-11

#include "textoutline.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "textoutline" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 640, 360 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

t as tTextOutline[5]
textsize# as float : textsize# = 100 * 0.7
width# as float = 2

  // if you set width# too high, sharp corners look terrible

  t[0] = TextOutline_Init( 100, 50/2, width# )
  TextOutline_SetSize( t[0], textsize# )
  TextOutline_SetColor( t[0], MakeColor( 255, 0, 0, 255 ))
  TextOutline_SetOutlineColor( t[0], MakeColor( 0, 255, 0, 255 ))
  TextOutline_SetText( t[0], "Red" )

  t[1] = TextOutline_Init( 100, 170/2, width# )
  TextOutline_SetSize( t[1], textsize# )
  TextOutline_SetColor( t[1], MakeColor( 0, 255, 0, 255 ))
  TextOutline_SetOutlineColor( t[1], MakeColor( 255, 0, 255, 255 ))
  TextOutline_SetText( t[1], "Green" )

  t[2] = TextOutline_Init( 100, 290/2, width# )
  TextOutline_SetSize( t[2], textsize# )
  TextOutline_SetColor( t[2], MakeColor( 0, 0, 255, 255 ))
  TextOutline_SetOutlineColor( t[2], MakeColor( 255, 0, 0, 255 ))
  TextOutline_SetText( t[2], "Blue" )

  t[3] = TextOutline_Init( 100, 410/2, width# )
  TextOutline_SetSize( t[3], textsize# )
  TextOutline_SetText( t[3], "Black" )

  t[4] = TextOutline_Init( 100, 530/2, width# )
  TextOutline_SetSize( t[4], textsize# )
  TextOutline_SetColor( t[4], MakeColor( 255, 255, 255, 255 ))
  TextOutline_SetOutlineColor( t[4], MakeColor( 0, 0, 0, 255 ))
  TextOutline_SetText( t[4], "White" )

  t[5] = TextOutline_Init( 25, 0, width# )
  TextOutline_SetSize( t[5], textsize#/2 )
  TextOutline_SetColor( t[5], MakeColor( 255, 255, 255, 255 ))
  TextOutline_SetOutlineColor( t[5], MakeColor( 0, 0, 0, 255 ))
  TextOutline_SetText( t[5], "Follow" )
  TextOutline_SetDepth( t[5], 0 )
  t[5].bFollowCursor = 1
  TextOutline_SetPosition( t[5], 25, -TextOutline_GetTotalHeight( t[5] ) / 2 )


sprites as integer[40]

  for i = 0 to sprites.length
    sprites[i] = CreateSprite( 0 )
    SetSpriteColor( sprites[i], Random( 128, 255 ), Random( 128, 255 ), Random( 128, 255 ), 255 )
    SetSpritePosition( sprites[i], Random( 100, 300 ), Random( 0, 768 )) 
    SetSpriteSize( sprites[i], Random( 10, 50 ), Random( 10, 50 ))
  next i

do
  for i = 0 to sprites.length
    x# = GetSpriteX( sprites[i] )
    y# = GetSpriteY( sprites[i] )
    inc y#, Random( 1, 5 )
    if y# > 768
      x# = Random( 80, 250 )
      y# = GetScreenBoundsTop()
    endif
    SetSpritePosition( sprites[i], x#, y# )
  next i
  
  for i = 0 to t.length
    TextOutline_UpdateMouse( t[i] )
  next i

  sync()
loop

