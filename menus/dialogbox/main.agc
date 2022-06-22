
// Project: dialogbox 
// Created: 22-06-22

#include "dialogbox.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "dialogbox" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

SetViewOffset( 100, 100 )

rectangle = CreateSprite( 0 )
SetSpriteColor( rectangle, 255, 255, 0, 255 )
SetSpriteSize( rectangle, 100, 50 )


// a dialogbox is displayed on depths 0 1 2 and 3 so these depths should be clear before displaying
db as tDialogBoxState

  // position of the dialogbox is fixed to the screen
  db = DialogBox_Init( 100, 100, 412, 284, MakeColor( 127, 127, 255, 255 ), 0 )
  // x,y locations for prompts and choices are relative to the position of the dialogbox
  DialogBox_AddTextPrompt( db, 30, 10, "Click ok.", 50, MakeColor( 255, 127, 127 ))
  DialogBox_AddSpritePrompt( db, 206 - 50, 142 - 25, rectangle )

  DialogBox_Display( db )


db2 as tDialogBoxState

  db2 = DialogBox_Init( 100, 100, 412, 284, MakeColor( 127, 127, 255, 255 ), 0 )
//  DialogBox_SetBoldHoverText( db2, 0 )
  DialogBox_AddTextPrompt( db2, 30, 15, "Click yes or no.", 50, MakeColor( 255, 127, 127 ))
  DialogBox_AddSpritePrompt( db2, 206 - 50, 142 - 25, rectangle )
  // -x means right justify the text
  // -y means position text from the lower edge of the dialogbox
  DialogBox_AddTextChoice( db2, 30, -15, "Yes", 50, MakeColor( 255, 255, 255 ))
  DialogBox_AddTextChoice( db2, -30, -15, "No", 50, MakeColor( 255, 255, 255 ))

  DialogBox_Display( db2 )

// dialog boxes can be displayed more than once after they are initialized and before they are deleted
//  sync()
//  DialogBox_Display( db )
//  sync()
//  DialogBox_Display( db2 )


  DialogBox_Delete( db )
  DialogBox_Delete( db2 )

do
  // choices are returned from DialogBox_Display() and retained in .choice
  Print( "First choice index: " + str( db.choice ))
  Print( "Second choice index: " + str( db2.choice ))
  Print( ScreenFPS() )
  Sync()
loop

