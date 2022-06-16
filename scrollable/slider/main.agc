
// Project: slider 
// Created: 22-06-16

#include "slider.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "slider" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

surface as integer
pin as integer

  surface = CreateSprite( 0 )
  SetSpriteDepth( surface, 10 )
  pin = CreateSprite( 0 )
  SetSpriteColorRed( pin, 0 )
  SetSpriteDepth( pin, 9 )
  
  SetSpriteSize( surface, 512, 40 )
  SetSpriteSize( pin, 40, 40 )
  
  SetSpritePosition( surface, 300, 150 )
  SetSpritePosition( pin, 300, 150 )

sl as tSliderState

  sl = Slider_Init( surface, pin, 1024, 0 )


  SetSpriteSize( surface, 40, 512 )
  SetSpritePosition( surface, 250, 200 )
  SetSpritePosition( pin, 250, 200 )

sl2 as tSliderState

  sl2 = Slider_Init( surface, pin, 0, 1024 )


  SetSpriteSize( surface, 512, 512 )
  SetSpritePosition( surface, 300, 200 )
  SetSpritePosition( pin, 300, 200 )
  
sl3 as tSliderState

  sl3 = Slider_Init( surface, pin, 1024, 1024 )

  DeleteSprite( surface )
  DeleteSprite( pin )

text as integer
text2 as integer
text3x as integer
text3y as integer

  text = CreateText( "t1" )
  text2 = CreateText( "t2" )
  text3x = CreateText( "t3x" )
  text3y = CreateText( "t3y" )

  SetTextSize( text, 40 )
  SetTextSize( text2, 40 )
  SetTextSize( text3x, 40 )
  SetTextSize( text3y, 40 )

  SetTextPosition( text, 500, 100 )
  SetTextPosition( text2, 50, 400 )
  SetTextPosition( text3x, 820, 400 )
  SetTextPosition( text3y, 820, 450 )

 
  Slider_SetXPercent( sl, 50 ) 
  Slider_SetY( sl2, 1000 )
  Slider_SetXFraction( sl3, 0.333 )
  Slider_SetYFraction( sl3, 0.777 )

do

  Slider_UpdateMouse( sl )
  Slider_UpdateMouse( sl2 )
  Slider_UpdateMouse( sl3 )

  SetTextString( text, str(Slider_GetX( sl )) + " " + str(Slider_GetXPercent( sl ),1) + "%" )
  SetTextString( text2, str(Slider_GetY( sl2 )) + " " + str(Slider_GetYPercent( sl2 ),1) + "%" )
  SetTextString( text3x, "x " + str(Slider_GetX( sl3 )) + " " + str(Slider_GetXPercent( sl3 ),1) + "%" )
  SetTextString( text3y, "y " + str(Slider_GetY( sl3 )) + " " + str(Slider_GetYPercent( sl3 ),1) + "%" )

  Print( ScreenFPS() )
  Sync()
loop

