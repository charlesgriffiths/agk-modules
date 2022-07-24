
// Project: spriteroute 
// Created: 22-07-02

#include "spriteroute.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "spriteroute" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

sr as tSpriteRouteState
sprite as integer

  sprite = CreateSprite( 0 )
  SetSpriteSize( sprite, 50, 50 )

  sr = SpriteRoute_Init( sprite )
  sr.tweenseconds# = 2

tags$ as string[]  

  for i = 0 to 20
    tag$ = str( i )
    tags$.insert( tag$ )
    SetSpriteSize( sprite, Random( 5, 100 ), Random( 5, 100 ))
    SetSpritePosition( sprite, Random( 0, GetVirtualWidth()-100 ), Random( 0, GetVirtualHeight()-100 ))
    SpriteRoute_SetAsLocation( sr, tag$, sprite, TweenOvershoot())
  next i
  
  DeleteSprite( sprite )

  SpriteRoute_TweenTo( sr, tags$[Random(0,tags$.length)], 0 )
  do
    if 0 = Random( 0, 40 ) or not sr.tween then SpriteRoute_TweenTo( sr, tags$[Random(0,tags$.length)], 0 )
    SpriteRoute_Update( sr )

    Print( str(ScreenFPS(),2) + " " + sr.tag$ )
    TweenSync()
  loop
  end


function TweenSync()
  UpdateAllTweens( GetFrameTime())
  sync()
endfunction

