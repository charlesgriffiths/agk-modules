
// Project: progressbar 
// Created: 22-06-06

#include "progressbar.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "progressbar" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

pb as tProgressBarState
progress as integer = 0
increment as integer = 9

  pb = ProgressBar_Init( 1024, 100, -1024, 24, 300, 2, 0 )
  ProgressBar_SetColor( pb, 255, 0, 0 )

pbr as tProgressBarState

  pbr = ProgressBar_Init( 0, 125, 1024, 24, 300, 2, 0 )
  ProgressBar_SetColor( pbr, 0, 255, 0 )

pbv as tProgressBarState

  pbv = ProgressBar_Init( 0, 768, 24, -768, 300, 2, 1 )
  ProgressBar_SetColor( pbv, 0, 0, 255 )

pb2 as tProgressBarState

  pb2 = ProgressBar_Init( 256, 384, 128*3, 19, 55, 1, 0 )

pb2r as tProgressBarState

  pb2r = ProgressBar_Init( 256+128*3, 384+40, -128*3, 19, 55, 1, 0 )

pb3 as tProgressBarState[]

  for i = 0 to 2
    pb3.insert( ProgressBar_Init( 256+i*128, 384+20, 128, 19, 55, 1, 0 ))
  next i
  ProgressBar_SetColor( pb3[0], 255, 0, 0 )
  ProgressBar_SetColor( pb3[1], 0, 255, 0 )
  ProgressBar_SetColor( pb3[2], 0, 0, 255 )

pb3r as tProgressBarState[]

  for i = 0 to 2
    pb3r.insert( ProgressBar_Init( 256+128+i*128, 384+60, -128, 19, 55, 1, 0 ))
  next i
  ProgressBar_SetColor( pb3r[0], 255, 0, 0 )
  ProgressBar_SetColor( pb3r[1], 0, 255, 0 )
  ProgressBar_SetColor( pb3r[2], 0, 0, 255 )


do
  progress = progress + increment
  if progress >= 300 or progress <= 0 then increment = -increment
  
  ProgressBar_Update( pb, progress )
  ProgressBar_Update( pbr, progress )
  ProgressBar_Update( pbv, progress )
  ProgressBar_UpdatePercent( pb2, 100 * progress / 300.0 )
  ProgressBar_UpdatePercent( pb2r, 100 * progress / 300.0 )
  
  for i = 0 to pb3.length
    ProgressBar_UpdateFraction( pb3[i], progress / 300.0 )
  next i

  for i = 0 to pb3r.length
    ProgressBar_UpdateFraction( pb3r[i], progress / 300.0 )
  next i

  Print( ScreenFPS() )
  Sync()
loop
