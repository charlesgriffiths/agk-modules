
// Project: pane 
// Created: 22-06-27

#include "pane.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "pane" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )


p as tPaneState

  p = Pane_Init( 500, 500 )
  Pane_SetColor( p, MakeColor( 255, 255, 255, 0 ))

sprite as integer

  sprite = CreateSprite( 0 )
  SetSpriteSize( sprite, 50, 50 )
  SetSpriteColor( sprite, 0, 255, 255, 255 )

  Pane_AddSprite( p, CloneSprite( sprite ), 0, 0 )
  Pane_AddSprite( p, CloneSprite( sprite ), 0, 450 )
  Pane_AddSprite( p, CloneSprite( sprite ), 450, 0 )
  Pane_AddSprite( p, CloneSprite( sprite ), 450, 450 )

  Pane_SetCurrentLocation( p, "in", TweenLinear() )
  Pane_SetLocation( p, "out", GetVirtualWidth(), p.y#, TweenLinear() )
  Pane_SetLocation( p, "up", p.x#, -500, TweenLinear() )
  Pane_SetLocation( p, "left", -500, p.y#, TweenLinear() )
  Pane_SetLocation( p, "down", p.x#, GetVirtualHeight(), TweenLinear() )

in as integer = 1

  do
    if 0 = Pane_IsTweening( p )
      if in
        select( Random( 1, 4 ))
          case 1:
            Pane_TweenOut( p, 1 )
          endcase

          case 2:
            Pane_TweenTo( p, "up", 1 )
          endcase

          case 3:
            Pane_TweenTo( p, "down", 1 )
          endcase

          case 4:
            Pane_TweenTo( p, "left", 1 )
          endcase
        endselect
        in = 0
      else
        Pane_TweenIn( p, 1 )
        in = 1
      endif
    endif

    Pane_Update( p )

    Pane_DrawBox( p, MakeColor( 255, 0, 0, 255 ))
    UpdateAllTweens( GetFrameTime())
    Print( ScreenFPS())
    Sync()
  loop

  Pane_Delete( p )

