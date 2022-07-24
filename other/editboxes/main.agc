
// Project: editboxes 
// Created: 22-06-29

#include "editboxes.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "editboxes" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )


textsize# as float = 50
eb as tEditBoxes

  eb = EditBoxes_Init( 100, 20 )

//alignment as integer = EditBoxes_AlignLeft
alignment as integer = EditBoxes_AlignCenter
//alignment as integer = EditBoxes_AlignRight

//EditBoxes_AddBox( ebs ref as tEditBoxes, x# as float, y# as float, minwidth# as float, maxwidth# as float, textsize# as float, maxchars as integer )
  EditBoxes_AddBox( eb, 0, 0, 0.5*textsize#, 10*textsize#, textsize#, 20 )
  EditBoxes_SetAlignment( eb, 0, alignment, 6 * textsize# )
  EditBoxes_SetClickableArea( eb, 0, 500, 100 )

  EditBoxes_AddBox( eb, 5*textsize#, 15 + (textsize# * 1.3), 0.5 * textsize#, 5*textsize#, textsize#, 6 )
  EditBoxes_SetNumeric( eb, 1, 2, 0, 10 )
  EditBoxes_SetAlignment( eb, 1, alignment, 6 * textsize# )

  EditBoxes_AddBox( eb, 5*textsize#, 15 + 2*(textsize# * 1.3), 0.5*textsize#, 5*textsize#, textsize#, 6 )
  EditBoxes_SetNumeric( eb, 2, 2, 0, 10 )
  EditBoxes_SetAlignment( eb, 2, alignment, 6 * textsize# )

  EditBoxes_AddBox( eb, 5*textsize#, 15 + 3*(textsize# * 1.3), 0.5*textsize#, 5*textsize#, textsize#, 6 )
  EditBoxes_SetNumeric( eb, 3, 2, 0, 10 )
  EditBoxes_SetAlignment( eb, 3, alignment, 6 * textsize# )

  EditBoxes_AddBox( eb, 5*textsize#, 15 + 4*(textsize# * 1.3), 0.5*textsize#, 5*textsize#, textsize#, 6 )
  EditBoxes_SetNumeric( eb, 4, 2, 0, 10 )
  EditBoxes_SetAlignment( eb, 4, alignment, 6 * textsize# )


//EditBoxes_SetLabel( ebs ref as tEditBoxes, index as integer, label$ as string )
  Editboxes_SetLabel( eb, 0, "Design Name" )
  Editboxes_SetLabel( eb, 1, "Drive" )
  Editboxes_SetLabel( eb, 2, "Weapon" )
  Editboxes_SetLabel( eb, 3, "Shield" )
  Editboxes_SetLabel( eb, 4, "Cargo" )

//  EditBoxes_UpdateMouse( eb )
//  EditBoxes_SetActive( eb, 0 )
//  EditBoxes_SetVisible( eb, 0 )

  if CompareString( "html5", GetDeviceBaseName()) then eb.bFixHtmlNumlock = 1

  do
    EditBoxes_UpdateMouse( eb )
    Print( ScreenFPS() )
    Sync()
  loop

  EditBoxes_Delete( eb )

