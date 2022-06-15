
// Project: textlist 
// Created: 22-06-08

#include "textlist.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "textlist" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

tl as tTextListState

  tl = TextList_Init( 100, 190, 824, 568, 50, 10 )
  
  TextList_AppendLine( tl, "This is a text. A very long line. A very very very very very very very very very very long line." )
  TextList_AppendLine( tl, "Also text." )

  for i = 2 to 20
    TextList_AppendLine( tl, "Text: " + str( i ) )
  next i

  TextList_AppendLine( tl, "This is a text. A very long line. A very very very very very very very very very very long long line." )

  TextList_SetSelectedBackgroundColor( tl, MakeColor( 255, 128, 0 ))
  TextList_SetSelected( tl, 1 )
  TextList_SetSelected( tl, 21 )
  TextList_SetClickToSelect( tl, 1 )

//  TextList_Delete( tl )

do
  TextList_DrawOutline( tl, MakeColor( 255, 255, 255 ))
  TextList_UpdateMouse( tl )
tl.bRedisplay = 1  // may need to redisplay when window is resized

  if TextList_GetSelected( tl, 1 )
    print( "index 1 is selected" )
  else
    print( "index 1 is not selected" )
  endif

  if TextList_GetSelected( tl, 2 )
    print( "index 2 is selected" )
  else
    print( "index 2 is not selected" )
  endif
  print( "selected: " + intarraytostring( tl.selected ) )

  Print( ScreenFPS() )
  Print( str(tl.topindex) + " " + str( tl.scrolloffset# ) + " " + str( tl.bScrollingUp ) + " " + str( tl.bShowLastLine ))
  Sync()
loop


function intarraytostring( ints as integer[] )

s$ as string

  for i = 0 to ints.length
    s$ = s$ + str( ints[i] ) + " "
  next i

endfunction s$


