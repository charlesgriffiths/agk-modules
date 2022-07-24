
// Project: mapdisplay 
// Created: 22-06-25

#include "mapdisplay.agc"
#include "../slider/slider.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "mapdisplay" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

md as tMapDisplay

  md = MapDisplay_Init( 0, 0, 1024*3, 768*3 )

  MapDisplay_SetViewportSize( md, 768/4, 768/4 )
  MapDisplay_SetViewportPosition( md, 0, 0 )
  MapDisplay_SetViewportScreenPosition( md, 0, 768/4, 3*768/4, 3*768/4 )

sprite as integer

  sprite = CreateSprite( 0 )
//  SetSpriteColor( sprite, 0, 255, 0, 255 )
SetSpriteColor( sprite, 255, 0, 0, 255 )
  SetSpriteSize( sprite, 2, 2 )

  b = CreateSprite( 0 )
  SetSpriteColor( b, 0, 255, 0, 255 )
  SetSpriteSize( b, 3, 3 )

  for i=1 to 100
    MapDisplay_AddItemB( md, Random( Floor(md.x#+5), Floor(md.x#+md.width#-5) ), Random( Floor(md.y#+5), Floor(md.y#+md.height#-5) ), sprite, b )
  next i


//  MapDisplay_Reposition( md )
  DeleteSprite( sprite )
  DeleteSprite( b )


red = MakeColor( 255, 0, 0, 255 )

  //Create an image
  swap()
  MapDisplay_SetViewportScreenPosition( md, 0, 0, 1024/4, 768/4 )
  MapDisplay_SetViewportSize( md, md.width#, md.height# )
  MapDisplay_SetViewportPositionFraction( md, 0, 0 )
  MapDisplay_Reposition( md )
  render()
  mapimage = GetImage( 0, 0, 1024/4, 768/4 )
  sprite = CreateSprite( mapimage )


  SetSpriteSize( sprite, 1024/4, 768/4 )
  SetSpritePosition( sprite, 3*768/4 + 5, 768/4-1 )

//SetSpriteColor( sprite, 255, 255, 255, 255 )

pin as integer

  pin = CreateSprite( 0 )
  SetSpriteSize( pin, GetSpriteWidth(sprite) / 4, GetSpriteHeight(sprite) / 4 )
//  SetSpriteColor( pin, 0, 255, 255, 255 )
  SetSpriteColor( pin, 255, 0, 0, 255 )


sl as tSliderState

  sl = Slider_Init( sprite, pin, 1000, 1000 )

  Slider_SetXFraction( sl, .5 )
  Slider_SetYFraction( sl, .5 )
  Slider_SetPinBox( sl, 1 )


zsprite as integer
zpin as integer
  zsprite = CreateSprite( 0 )
  SetSpriteColor( zsprite, 255, 255, 255, 255 )
  SetSpriteSize( zsprite, 15, 768/4 - 30 )
  SetSpritePosition( zsprite, 1024 - 170, 768/4 + 15 )
  
  zpin = CreateSprite( 0 )
  SetSpriteColor( zpin, 0, 255, 255, 255 )
  SetSpriteSize( zpin, 15, 15 )
  
slz as tSliderState

  slz = Slider_Init( zsprite, zpin, 0, 768/8 * 6 )
  Slider_SetYFraction( slz, 0.5 )
//  Slider_SetPinBox( slz, 1 )

  DeleteSprite( zsprite )
  DeleteSprite( zpin )


  SetSpriteVisible( sprite, 0 )
  SetSpriteVisible( pin, 0 )

minzoom# as float
  minzoom# = 768/4

  MapDisplay_SetViewportSize( md, minzoom# + Slider_GetY( slz ), minzoom# + Slider_GetY( slz ))
  Slider_SetPinSize( sl, GetSpriteWidth(sprite) * md.viewport.width# / md.width#, GetSpriteHeight(sprite) * md.viewport.height# / md.height# )
  post$ = str( Slider_GetXFraction( sl ) ) + " " + str( Slider_GetYFraction( sl ))
  MapDisplay_SetViewportPositionFraction( md, Slider_GetXFraction( sl ), Slider_GetYFraction( sl ))
  MapDisplay_SetViewportScreenPosition( md, 1, 768/4-1, 3*768/4, 3*768/4 )
  MapDisplay_Reposition( md )

//  MapDisplay_SetSelectOnlyOne( md, 1 )

  MapDisplay_SetDragSelectMode( md, 1 )

do
sliderpositionchanged as integer
zoompositionchanged as integer
mdpositionchanged as integer

  sliderpositionchanged = Slider_UpdateMouse( sl )
  zoompositionchanged = Slider_UpdateMouse( slz )

  if zoompositionchanged
    MapDisplay_SetViewportSize( md, minzoom# + Slider_GetY( slz ), minzoom# + Slider_GetY( slz ))
    Slider_SetPinSize( sl, GetSpriteWidth(sprite) * md.viewport.width# / md.width#, GetSpriteHeight(sprite) * md.viewport.height# / md.height# )
  endif

  if sliderpositionchanged or zoompositionchanged
    MapDisplay_SetViewportPositionFraction( md, Slider_GetXFraction( sl ), Slider_GetYFraction( sl ))
    MapDisplay_Reposition( md )
  endif

  mdpositionchanged = MapDisplay_UpdateMouse( md )

  if mdpositionchanged
    MapDisplay_Reposition( md )
    Slider_SetXFraction( sl, MapDisplay_GetViewportXFraction( md ))
    Slider_SetYFraction( sl, MapDisplay_GetViewportYFraction( md ))
  endif

//  color = MakeColor( 0, 255, 255 )
  color = MakeColor( 255, 0, 0 )
  MapDisplay_DrawViewportBox( md, color )
  Slider_DrawBox( sl, color )
  Slider_DrawBox( slz, color )

  print( "slider: " + str(Slider_GetXFraction( sl )) + " " + str(Slider_GetYFraction( sl )))
  print( str(md.x# + Slider_GetXFraction( sl ) * (md.width# - md.viewport.width#)))
  print( "viewport: " + str( md.viewport.x# ) + " " + str( md.viewport.y# ))

  for i = 0 to md.selected.length
    print( str( md.items[md.selected[i]].x# ) + " " + str( md.items[md.selected[i]].y# ))
  next i

/*
  if md.selected.length > -1
    MapDisplay_SetViewportCenter( md, md.items[md.selected[0]].x#, md.items[md.selected[0]].y# )
    MapDisplay_Reposition( md )
    Slider_SetXFraction( sl, MapDisplay_GetViewportXFraction( md ))
    Slider_SetYFraction( sl, MapDisplay_GetViewportYFraction( md ))
  endif
/**/

  Print( ScreenFPS() )
  Sync()
loop

