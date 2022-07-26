
// Project: DetectSwipe 
// Created: 22-07-01

#include "detectswipe.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "DetectSwipe" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

ds as tDetectSwipeState

  ds = DetectSwipe_Init( 100, 100, 500, 500 )

//  DetectSwipe_DetectOnly( ds, DetectSwipe_UP || DetectSwipe_DOWN )

printdetection$ as string = ""

  do
    detected = DetectSwipe_UpdateMouse( ds )

    if detected
      printdetection$ = ""
      if DetectSwipe_LEFT && detected then printdetection$ = printdetection$ + "Left "
      if DetectSwipe_RIGHT && detected then printdetection$ = printdetection$ + "Right "
      if DetectSwipe_UP && detected then printdetection$ = printdetection$ + "Up "
      if DetectSwipe_DOWN && detected then printdetection$ = printdetection$ + "Down "
    endif    

    DetectSwipe_DrawBox( ds, MakeColor( 255, 0, 0 ))

    Print( ScreenFPS() )
    print( printdetection$ )
    Sync()
  loop

