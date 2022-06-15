
// Project: progresscircle 
// Created: 22-06-06

#include "progresscircle.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "progresscircle" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

pc as tProgressCircleState
progress as integer = 0
increment as integer = 9

  pc = ProgressCircle_Init( 512, 384, -1024, 384, 300, 1, 7 )
  ProgressCircle_SetColor( pc, 255, 0, 255 )

pc2 as tProgressCircleState

  pc2 = ProgressCircle_Init( 512, 384, 256, 192, 133, 1, 5 )

pc3 as tProgressCircleState[]

  for i = 0 to 2
    pc3.insert( ProgressCircle_Init( 512-128+i*128, 384, 128, -96, 55, 1, 3 ))
  next i
  ProgressCircle_SetColor( pc3[0], 255, 0, 0 )
  ProgressCircle_SetColor( pc3[1], 0, 255, 0 )
  ProgressCircle_SetColor( pc3[2], 0, 0, 255 )

do
  progress = progress + increment
  if progress >= 300 or progress <= 0 then increment = -increment
  
  ProgressCircle_Update( pc, progress )
  ProgressCircle_UpdatePercent( pc2, 100 * progress / 300.0 )
  
  for i = 0 to pc3.length
    ProgressCircle_UpdateFraction( pc3[i], progress / 300.0 )
  next i

  Print( ScreenFPS() )
  Sync()
loop

