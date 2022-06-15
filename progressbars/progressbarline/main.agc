
// Project: progressbarline 
// Created: 22-06-06

#include "progressbarline.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "progressbarline" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

pb as tProgressBarLineState
progress as integer = 0
increment as integer = 9

  pb = ProgressBarLine_Init( 1024, 100, -1024, 300 )
  ProgressBarLine_SetColor( pb, 255, 0, 255 )

pb2 as tProgressBarLineState

  pb2 = ProgressBarLine_Init( 256, 384, 128*3, 55 )

pb3 as tProgressBarLineState[]

  for i = 0 to 2
    pb3.insert( ProgressBarLine_Init( 256+i*128, 384+20, 128, 55 ))
  next i
  ProgressBarLine_SetColor( pb3[0], 255, 0, 0 )
  ProgressBarLine_SetColor( pb3[1], 0, 255, 0 )
  ProgressBarLine_SetColor( pb3[2], 0, 0, 255 )

do
  progress = progress + increment
  if progress >= 300 or progress <= 0 then increment = -increment
  
  ProgressBarLine_Update( pb, progress )
  ProgressBarLine_UpdatePercent( pb2, 100 * progress / 300.0 )
  
  for i = 0 to pb3.length
    ProgressBarLine_UpdateFraction( pb3[i], progress / 300.0 )
  next i

  Print( ScreenFPS() )
  Sync()
loop
