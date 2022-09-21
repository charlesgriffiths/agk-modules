// Project: DetectClick 
// Created: 22-07-23

#include "detectclick.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "DetectClick" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

dc as tDetectClickState

  dc = DetectClick_Init( 100, 150, 200, 200 )

dcreset as tDetectClickState

  dcreset = DetectClick_Init( 350, 150, 200, 200 )
  
bClickDetected as integer
bDoubleClickDetected as integer
bLongClickDetected as integer
bControlClickDetected as integer
bShiftClickDetected as integer
bAltClickDetected as integer

  green = MakeColor( 0, 255, 0, 255 )
  red = MakeColor( 255, 0, 0, 255 )

do
  detectedclick = DetectClick_UpdateMouse( dc )  

  if DetectClick_SingleClick && detectedclick then bClickDetected = 1
  if DetectClick_DoubleClick && detectedclick then bDoubleClickDetected = 1
  if DetectClick_LongClick && detectedclick then bLongClickDetected = 1
  if DetectClick_ControlClick && detectedclick then bControlClickDetected = 1
  if DetectClick_ShiftClick && detectedclick then bShiftClickDetected = 1
  if DetectClick_AltClick && detectedclick then bAltClickDetected = 1

  if DetectClick_UpdateMouse( dcreset )
    bClickDetected = 0
    bDoubleClickDetected = 0
    bControlClickDetected = 0
    bShiftClickDetected = 0
    bAltClickDetected = 0
    bLongClickDetected = 0
  endif

  DetectClick_DrawBox( dc, green )
  DetectClick_DrawBox( dcreset, red )
  Print( "Clicks detected in the green box, click in the red box to reset." )
  Print( ScreenFPS() )
  Print( "1 2 L C S A  (Single Double Long Control Shift Alt)" )
  Print( str(bClickDetected) + " " + str(bDoubleClickDetected) + " " + str(bLongClickDetected) + " " + str(bControlClickDetected) + " " + str(bShiftClickDetected) + " " + str(bAltClickDetected) )
  Sync()
loop

