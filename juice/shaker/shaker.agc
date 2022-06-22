// File: shaker.agc
// Created: 22-06-20
//
//  Copyright 2022 Charles Griffiths
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.


#constant ShakerModeStill 0
#constant ShakerModeShaking 1
#constant ShakerModeShakeTogether 2
#constant ShakerModeCamera 3
#constant ShakerModeView 4


type tShakeText
  id as integer
  shaking as integer
endtype

type tShakeSprite
  id as integer
  shaking as integer
endtype


type tShakerState
  texts as tShakeText[]
  sprites as tShakeSprite[]

  seconds# as float
  frequency# as float
  distance as integer
  mode as integer
  shakeprogress# as float
  savex# as float
  savey# as float
  savez# as float
endtype



// initialize a shaker instance
function Shaker_Init()
sh as tShakerState

  sh.seconds# = 5
  sh.frequency# = 5.5
  sh.distance = Round( 0.02 * (GetVirtualWidth() + GetVirtualHeight()))
  sh.mode = ShakerModeStill
  sh.shakeprogress# = 0

endfunction sh


// add text to be shaken
function Shaker_AddText( sh ref as tShakerState, text as integer )
st as tShakeText

  st.id = text
  st.shaking = 0
  sh.texts.insert( st )

endfunction


// add a sprite to be shaken
function Shaker_AddSprite( sh ref as tShakerState, sprite as integer )
ss as tShakeSprite

  ss.id = sprite
  ss.shaking = 0
  sh.sprites.insert( ss )

endfunction


// call Shaker_Update once per frame to continue any shaking in progress
function Shaker_Update( sh ref as tShakerState )

  if ShakerModeStill = sh.mode then exitfunction

  shakes = Floor( sh.shakeprogress# * sh.frequency# )
  sh.shakeprogress# = sh.shakeprogress# + GetFrameTime()

  if sh.shakeprogress# > sh.seconds#
    Shaker_StopShaking( sh )
  elseif shakes < Floor( sh.shakeprogress# * sh.frequency# )
    select sh.mode
      case ShakerModeShaking:

        for i = 0 to sh.texts.length
          if sh.texts[i].shaking
            dx# = Random( -sh.distance, sh.distance )
            dy# = Random( -sh.distance, sh.distance )
            SetTextPosition( sh.texts[i].shaking, dx# + GetTextX( sh.texts[i].id ), dy# + GetTextY( sh.texts[i].id ))
          endif
        next i

        for i = 0 to sh.sprites.length
          if sh.sprites[i].shaking
            dx# = Random( -sh.distance, sh.distance )
            dy# = Random( -sh.distance, sh.distance )
            SetSpritePosition( sh.sprites[i].shaking, dx# + GetSpriteX( sh.sprites[i].id ), dy# + GetSpriteY( sh.sprites[i].id ))
          endif
        next i
      endcase

      case ShakerModeShakeTogether:
        dx# = Random( -sh.distance, sh.distance )
        dy# = Random( -sh.distance, sh.distance )

        for i = 0 to sh.texts.length
          if sh.texts[i].shaking
            SetTextPosition( sh.texts[i].shaking, dx# + GetTextX( sh.texts[i].id ), dy# + GetTextY( sh.texts[i].id ))
          endif
        next i

        for i = 0 to sh.sprites.length
          if sh.sprites[i].shaking
            SetSpritePosition( sh.sprites[i].shaking, dx# + GetSpriteX( sh.sprites[i].id ), dy# + GetSpriteY( sh.sprites[i].id ))
          endif
        next i
      endcase

      case ShakerModeCamera:
        SetCameraPosition( 1, sh.savex# + Random( -sh.distance, sh.distance ), sh.savey# + Random( -sh.distance, sh.distance ), sh.savez# + Random( -sh.distance, sh.distance ))
      endcase

      case ShakerModeView:
        SetViewOffset( sh.savex# + Random( -sh.distance, sh.distance ), sh.savey# + Random( -sh.distance, sh.distance ))
      endcase
    endselect
  endif

endfunction


// stop shaking
function Shaker_StopShaking( sh ref as tShakerState )

  if ShakerModeCamera = sh.mode
    SetCameraPosition( 1, sh.savex#, sh.savey#, sh.savez# )
  endif

  if ShakerModeView = sh.mode
    SetViewOffset( sh.savex#, sh.savey# )
  endif

  if ShakerModeShaking = sh.mode or ShakerModeShakeTogether = sh.mode
    for i = 0 to sh.texts.length
      if sh.texts[i].shaking
        SetTextVisible( sh.texts[i].id, 1 )
        DeleteText( sh.texts[i].shaking )
        sh.texts[i].shaking = 0
      endif
    next i

    for i = 0 to sh.sprites.length
      if sh.sprites[i].shaking
        SetSpriteVisible( sh.sprites[i].id, 1 )
        DeleteSprite( sh.sprites[i].shaking )
        sh.sprites[i].shaking = 0
      endif
    next i
  endif

  sh.mode = ShakerModeStill
  sh.shakeprogress# = 0

endfunction


// set duration of shaking
function Shaker_SetShakeTime( sh ref as tShakerState, seconds# as float )
  sh.seconds# = seconds#
endfunction


// set number of shakes per second
function Shaker_SetShakeFrequency( sh ref as tShakerState, frequency# as float )
  sh.frequency# = frequency#
endfunction


// set the maximum distance to shake from the starting position
function Shaker_SetShakeDistance( sh ref as tShakerState, distance as integer )
  sh.distance = distance
endfunction


// shake all the items together
function Shaker_ShakeTogether( sh ref as tShakerState )

  Shaker_StartShaking( sh )
  sh.mode = ShakerModeShakeTogether

endfunction


// shake all the items separately
function Shaker_ShakeSeparately( sh ref as tShakerState )

  Shaker_StartShaking( sh )
  sh.mode = ShakerModeShaking

endfunction


// internal helper function to start shaking, sets mode to ShakerModeShaking in case it is called externally by accident
function Shaker_StartShaking( sh ref as tShakerState )

  if ShakerModeStill <> sh.mode then Shaker_StopShaking( sh )
  sh.mode = ShakerModeShaking
  sh.shakeprogress# = 0

  for i = 0 to sh.texts.length
    if GetTextVisible( sh.texts[i].id )
      sh.texts[i].shaking = Shaker_CloneText( sh.texts[i].id )
      SetTextVisible( sh.texts[i].id, 0 )
    else
      sh.texts[i].shaking = 0
    endif
  next i

  for i = 0 to sh.sprites.length
    if GetSpriteVisible( sh.sprites[i].id )
      sh.sprites[i].shaking = CloneSprite( sh.sprites[i].id )
      SetSpriteVisible( sh.sprites[i].id, 0 )
    else
      sh.sprites[i].shaking = 0
    endif
  next i

endfunction


// internal helper function to copy a text object (which for some reason cannot be cloned)
function Shaker_CloneText( text as integer )
id as integer

  id = CreateText( GetTextString( text ))
  
  SetTextColor( id, GetTextColorRed( text ), GetTextColorGreen( text ), GetTextColorBlue( text ), GetTextColorAlpha( text ))
  SetTextDepth( id, GetTextDepth( text ))
  SetTextLineSpacing( id, GetTextLineSpacing( text ))
  SetTextPosition( id, GetTextX( text ), GetTextY( text ))
  SetTextSize( id, GetTextSize( text ))
  SetTextSpacing( id, GetTextSpacing( text ))

  // bold?
  if GetTextTotalWidth( text ) > GetTextTotalWidth( id ) then SetTextBold( id, 1 )

endfunction id


// shake camera one
function Shaker_ShakeCamera( sh ref as tShakerState )

  if ShakerModeStill <> sh.mode then Shaker_StopShaking( sh )
  sh.mode = ShakerModeCamera
  sh.shakeprogress# = 0
  sh.savex# = GetCameraX( 1 )
  sh.savey# = GetCameraY( 1 )
  sh.savez# = GetCameraZ( 1 )

endfunction


// shake the screen view
function Shaker_ShakeScreen( sh ref as tShakerState )

  if ShakerModeStill <> sh.mode then Shaker_StopShaking( sh )
  sh.mode = ShakerModeView
  sh.shakeprogress# = 0
  sh.savex# = GetViewOffsetX()
  sh.savey# = GetViewOffsetY()

endfunction

