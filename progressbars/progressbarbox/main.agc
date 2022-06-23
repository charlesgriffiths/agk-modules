
// Project: progressbarbox 
// Created: 22-06-06

#include "progressbarbox.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "progressbarbox" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

pb as tProgressBarBoxState
progress as integer = 0
increment as integer = 9

  pb = ProgressBarBox_Init( 1024, 100, -1024, 20, 300 )
  ProgressBarBox_SetColor( pb, 255, 0, 255 )

pbv as tProgressBarBoxState

  pbv = ProgressBarBox_Init( 1004, 768, 20, -768, 300 )
  ProgressBarBox_SetVertical( pbv, 1 )
  ProgressBarBox_SetColor( pbv, 255, 0, 255 )

pb2 as tProgressBarBoxState

  pb2 = ProgressBarBox_Init( 256, 384, 128*3, 5, 55 )

pb2v as tProgressBarBoxState

  pb2v = ProgressBarBox_Init( 256, 384, 5, 128*3, 55 )
  ProgressBarBox_SetVertical( pb2v, 1 )


pb3 as tProgressBarBoxState[]
pb3v as tProgressBarBoxState[]

  for i = 0 to 2
    pb3.insert( ProgressBarBox_Init( 256+i*128, 384+20, 128, 5, 55 ))
    pb3v.insert( ProgressBarBox_Init( 256+i*128, 384+20, 5, 128, 55 ))
    ProgressBarBox_SetVertical( pb3v[i], 1 )
  next i
  ProgressBarBox_SetColor( pb3[0], 255, 0, 0 )
  ProgressBarBox_SetColor( pb3[1], 0, 255, 0 )
  ProgressBarBox_SetColor( pb3[2], 0, 0, 255 )

  ProgressBarBox_SetColor( pb3v[0], 255, 0, 0 )
  ProgressBarBox_SetColor( pb3v[1], 0, 255, 0 )
  ProgressBarBox_SetColor( pb3v[2], 0, 0, 255 )

  do
    progress = progress + increment
    if progress >= 300 or progress <= 0 then increment = -increment

    ProgressBarBox_Update( pb, progress )
    ProgressBarBox_Update( pbv, progress )
    ProgressBarBox_UpdatePercent( pb2, 100 * progress / 300.0 )
    ProgressBarBox_UpdatePercent( pb2v, 100 * progress / 300.0 )

    for i = 0 to pb3.length
      ProgressBarBox_UpdateFraction( pb3[i], progress / 300.0 )
    next i

    for i = 0 to pb3v.length
      ProgressBarBox_UpdateFraction( pb3v[i], progress / 300.0 )
    next i

    Print( ScreenFPS() )
    Sync()
  loop

