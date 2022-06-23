
// Project: progressbarsprite 
// Created: 22-06-15

#include "progressbarsprite.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "progressbarsprite" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

progressimage as integer
progresssprite as integer
progresstext as integer
textwidth# as float

  progresstext = CreateText( "Progress" )
  SetTextSize( progresstext, 50 )
  textwidth# = GetTextTotalWidth( progresstext )
  DeleteText( progresstext )
  
  //Create an image
  swap()
  SetPrintSize( 50 )
  SetPrintColor( 0, 255, 0 )
  Print( "Progress" )
  render()
  progressimage = GetImage( 0, 0, textwidth#, 50 )
  progresssprite = CreateSprite( progressimage )

progress as integer = 0
increment as integer = 9

pb as tProgressBarSpriteState

  SetSpritePosition( progresssprite, 100, 270 )
  pb = ProgressBarSprite_Init( progresssprite, 300 )

pb2 as tProgressBarSpriteState

  SetSpritePosition( progresssprite, 100 + textwidth# + 20, 270 )
  pb2 = ProgressBarSprite_Init( progresssprite, 300 )
  ProgressBarSprite_SetDirection( pb2, 1 )

pb3 as tProgressBarSpriteState

  SetSpritePosition( progresssprite, 100 + 2*(textwidth# + 20), 270 )
  pb3 = ProgressBarSprite_Init( progresssprite, 300 )
  ProgressBarSprite_SetAlign( pb3, 1 )

pb4 as tProgressBarSpriteState

  SetSpritePosition( progresssprite, 100 + 3*(textwidth# + 20), 270 )
  pb4 = ProgressBarSprite_Init( progresssprite, 300 )
  ProgressBarSprite_SetDirection( pb4, 1 )
  ProgressBarSprite_SetAlign( pb4, 1 )


vprogressimage as integer
vprogresssprite as integer

  //Create an image
  swap()
  SetSpriteOffset( progresssprite, 0, 0 )
  SetSpritePosition( progresssprite, 50, 0 )
  SetSpriteAngle( progresssprite, 90 )
  render()
  vprogressimage = GetImage( 0, 0, 50, textwidth# )
  vprogresssprite = CreateSprite( vprogressimage )

  SetSpriteAngle( progresssprite, 0 )

pbv as tProgressBarSpriteState

  SetSpritePosition( vprogresssprite, 170, 384 )
  pbv = ProgressBarSprite_Init( vprogresssprite, 300 )
  ProgressBarSprite_SetVertical( pbv, 1 )

pbv2 as tProgressBarSpriteState

  SetSpritePosition( vprogresssprite, 100 + 2*70, 384 )
  pbv2 = ProgressBarSprite_Init( vprogresssprite, 300 )
  ProgressBarSprite_SetVertical( pbv2, 1 )
  ProgressBarSprite_SetDirection( pbv2, 1 )

pbv3 as tProgressBarSpriteState

  SetSpritePosition( vprogresssprite, 100 + 3*70, 384 )
  pbv3 = ProgressBarSprite_Init( vprogresssprite, 300 )
  ProgressBarSprite_SetVertical( pbv3, 1 )
  ProgressBarSprite_SetAlign( pbv3, 1 )

pbv4 as tProgressBarSpriteState

  SetSpritePosition( vprogresssprite, 100 + 4*70, 384 )
  pbv4 = ProgressBarSprite_Init( vprogresssprite, 300 )
  ProgressBarSprite_SetVertical( pbv4, 1 )
  ProgressBarSprite_SetDirection( pbv4, 1 )
  ProgressBarSprite_SetAlign( pbv4, 1 )


  SetPrintColor( 255, 255, 255 )

  do
    progress = progress + increment
    if progress >= 300 or progress <= 0 then increment = -increment

    ProgressBarSprite_Update( pb, progress )
    ProgressBarSprite_Update( pb2, progress )
    ProgressBarSprite_Update( pb3, progress )
    ProgressBarSprite_Update( pb4, progress )
    ProgressBarSprite_Update( pbv, progress )
    ProgressBarSprite_Update( pbv2, progress )
    ProgressBarSprite_Update( pbv3, progress )
    ProgressBarSprite_Update( pbv4, progress )

    color = MakeColor( 255, 0, 0 )
    ProgressBarSprite_DrawOutline( pb, color )
    ProgressBarSprite_DrawOutline( pb2, color )
    ProgressBarSprite_DrawOutline( pb3, color )
    ProgressBarSprite_DrawOutline( pb4, color )
    ProgressBarSprite_DrawOutline( pbv, color )
    ProgressBarSprite_DrawOutline( pbv2, color )
    ProgressBarSprite_DrawOutline( pbv3, color )
    ProgressBarSprite_DrawOutline( pbv4, color )


    SetSpritePosition( progresssprite, 100, 200 )
    x# = GetSpriteX( progresssprite )
    y# = GetSpriteY( progresssprite )
    color = MakeColor( 255, 0, 0 )
    DrawBox( x#, y#, x#+GetSpriteWidth( progresssprite ), y#+GetSpriteHeight( progresssprite ), color, color, color, color, 0 )

    SetSpritePosition( vprogresssprite, 100, 384 )
    x# = GetSpriteX( vprogresssprite )
    y# = GetSpriteY( vprogresssprite )
    color = MakeColor( 255, 0, 0 )
    DrawBox( x#, y#, x#+GetSpriteWidth( vprogresssprite ), y#+GetSpriteHeight( vprogresssprite ), color, color, color, color, 0 )


    Print( ScreenFPS() )
//  Print( "Textwidth: " + str( textwidth# ))
    Sync()
  loop

  ProgressBarSprite_Delete( pb )
  ProgressBarSprite_Delete( pb2 )
  ProgressBarSprite_Delete( pb3 )
  ProgressBarSprite_Delete( pb4 )
  ProgressBarSprite_Delete( pbv )
  ProgressBarSprite_Delete( pbv2 )
  ProgressBarSprite_Delete( pbv3 )
  ProgressBarSprite_Delete( pbv4 )

