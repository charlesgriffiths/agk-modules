
// Project: SV 
// Created: 22-07-30

#include "SV.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "SV" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 512, 384 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )


  TextButton = 1
  AddVirtualButton( TextButton, 32, 32, 64 )
  SetVirtualButtonText( TextButton, "Text" )

  ClipboardButton = 2
  AddVirtualButton( ClipboardButton, 96, 32, 64 )
  SetVirtualButtonText( ClipboardButton, "Clipboard" )

  LoadImageButton = 3
  AddVirtualButton( LoadImageButton, 160, 32, 64 )
  SetVirtualButtonText( LoadImageButton, "Load"+chr(10)+"Image" )

  SaveImageButton = 4
  AddVirtualButton( SaveImageButton, 224, 32, 64 )
  SetVirtualButtonText( SaveImageButton, "Save"+chr(10)+"Image" )
  
  FullScreenButton = 5
  AddVirtualButton( FullScreenButton, 288, 32, 64 )
  SetVirtualButtonText( FullScreenButton, "Fullscreen" )


text as integer

  text = CreateText( "" )
  SetTextSize( text, 25 )
  SetTextPosition( text, 10, 100 )
  SetTextVisible( text, 1 )
  SetTextMaxWidth( text, 490 )

sprite as integer

  sprite = CreateSprite( 0 )
  SetSpriteSize( sprite, 256, 256 )
  SetSpritePosition( sprite, 10, 100 )
  SetSpriteVisible( sprite, 0 )
  
image as integer = 0

sv as tSV

  sv = SV_Init()

  SetTextString( text, SV_GetArgs( sv ))

readtextpoll as integer = 0
readclipboardpoll as integer = 0
readimagepoll as integer = 0
convertimagepoll as integer = 0
copytoclipboard$ as string = ""

  do
    if len( SV_LastKeyDown( sv ))
      SetTextString( text, "Key pressed: " + sv.text$ )
      SetTextVisible( text, 1 )
      SetSpriteVisible( sprite, 0 )
    endif
  
    if GetVirtualButtonReleased( TextButton )
      SV_OpenTextFile( sv )
      readtextpoll = 1
      ResetTimer()
    endif
    
    if readtextpoll
      if Timer() > 60 then readtextpoll = 0
      if SV_ReadTextFile( sv )
        SetTextString( text, "Your file: " + sv.text$ )
        SetTextVisible( text, 1 )
        SetSpriteVisible( sprite, 0 )
        readtextpoll = 0
        SV_DownloadTextFile( sv, sv.filename$, sv.text$ )
      endif
    endif


    if GetVirtualButtonReleased( ClipboardButton )
      copytoclipboard$ = "This message gets copied to your clipboard."
      SV_CopyToClipboard( sv, copytoclipboard$ )
      SV_RequestPasteFromClipboard( sv )
      readclipboardpoll = 1
      ResetTimer()
    endif
    
    if readclipboardpoll
      if Timer() > 30 then readclipboardpoll = 0
      if SV_GetClipboardData( sv )
        SetTextString( text, "To clipboard: " + copytoclipboard$ + chr(10) + "From clipboard: " + sv.text$ )
        SetTextVisible( text, 1 )
        SetSpriteVisible( sprite, 0 )
        readclipboardpoll = 0
      endif
    endif

    if GetVirtualButtonReleased( LoadImageButton )
      SV_OpenBinaryFileType( sv, ".png" )
      readimagepoll = 1
      ResetTimer()
    endif

    if readimagepoll
      if Timer() > 60 then readimagepoll = 0
      if SV_ConvertImagePng( sv )
        readimagepoll = 0
        convertimagepoll = 1
        ResetTimer()
      endif
    endif
    
    if convertimagepoll
      if image
        SetSpriteImage( sprite, 0 )
        DeleteImage( image )
        image = 0
      endif
      if Timer() > 30 then convertimagepoll = 0
      image = SV_GetImage( sv )
      if image
        SetSpriteImage( sprite, image )
        SetTextVisible( text, 0 )
        SetSpriteVisible( sprite, 1 )
        convertimagepoll = 0
      endif
    endif

    if GetVirtualButtonReleased( SaveImageButton )
      if image
        SetSpriteImage( sprite, 0 )
        DeleteImage( image )
        image = 0
      endif
      SetSpriteVisible( sprite, 0 )
      image = getNoiseImage()
      SV_DownloadImagePng( sv, "noiseimage.png", image )
      SetSpriteImage( sprite, image )
      SetTextVisible( text, 0 )
      SetSpriteVisible( sprite, 1 )
    endif

    if GetVirtualButtonReleased( FullScreenButton )
      SV_FullScreen( sv )
    endif

    sync()
  loop



// the following is from https://forum.thegamecreators.com/thread/228529#msg2670935
// VirtualNomad said it was fine to include it here
function getNoiseImage()
SetupNoise ( random ( 1, 100 ) / 1000.0, random ( 1, 100 ) / 100.0, random ( 1, 5 ), 1.0 / 2.0 )
 
    data as integer [ 196608 ]
 
    fr as float
    f as float
 
    k = 1
    fr = random ( 1, 10 )
 
    for x = 1 to 256
        for y = 1 to 256
 
            f = GetFractalXY ( fr, x, y )
 
            f = AdjustValue ( f, -1, 1, 0, 255 )
 
            data [ k ] = f
            k = k + 1
 
            f = GetFractalXY ( fr, x, y )
            f = AdjustValue ( f, -1, 1, 0, 255 )
            data [ k ] = f
            k = k + 1
 
            f = GetFractalXY ( fr, x, y )
            f = AdjustValue ( f, -1, 1, 0, 255 )
            data [ k ] = f
            k = k + 1
 
        next y
    next x
 
    a = img_create_RGBA ( 256, 256, data )
 
endfunction a

function AdjustValue ( value as float, minFrom as float, maxFrom as float, minTo as float, maxTo as float )
    ret as float
    ret = minTo + ( maxTo - minTo ) * ( ( value - minFrom ) / ( maxFrom - minFrom ) )
endfunction ret

function img_create_RGBA(www,hhh, data as integer[])
//creates an image of 'www' by 'hhh' pixels with defined color
 
 size = 12 +www *hhh *4  // memblock //'size' is summary of image width (integer, 4 bytes), image height (integer, 4 bytes), image depth (integer, 4 bytes) - that is 12 bytes - and raw image data (the number of pixels multiplied by 4 bytes)
  mmm = createMemblock(size)
 
   setMemblockInt(mmm, 0, www)  //writing starts with offset 0
   setMemblockInt(mmm, 4, hhh)  //variable 'www' occupies 4 bytes, so now offset 0 +4 = 4
   setMemblockInt(mmm, 8, 32)   //variable 'hhh' occupies 4 bytes, so now offset 4 +4 = 8
 
 dec size  //since writing starts with offset 0, it ends at one stage earlier than the memblock 'size'
  
 k = 1
  
  for nnn = 12 to size
    setMemblockByte(mmm, nnn, data[k])
    k = k + 1
   inc nnn
    setMemblockByte(mmm, nnn, data[k])
    k = k + 1
   inc nnn
    setMemblockByte(mmm, nnn, data[k])
    k = k + 1
   inc nnn
    setMemblockByte(mmm, nnn, 255)
 
  next nnn
 
 
   nnn = createImageFromMemblock(mmm)
    deleteMemblock(mmm)
 
endfunction nnn

