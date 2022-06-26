// File: slider.agc
// Created: 22-06-16
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
//
// https://github.com/charlesgriffiths/agk-modules/blob/main/scrollable/slider/slider.agc


type tSliderState
  surface as integer
  pin as integer
  xrange as integer
  yrange as integer

  bActive as integer
  bVisible as integer
endtype



// initialize the state of a slider instance
function Slider_Init( surfacesprite as integer, pinsprite as integer, xrange as integer, yrange as integer )
ss as tSliderState

  ss.surface = CloneSprite( surfacesprite )
  ss.pin = CloneSprite( pinsprite )

  if xrange < 2 then xrange = 2
  if yrange < 2 then yrange = 2
  ss.xrange = xrange
  ss.yrange = yrange

  ss.bActive = 1
  ss.bVisible = 1

endfunction ss


// delete a slider
function Slider_Delete( ss ref as tSliderState )

  if ss.surface then DeleteSprite( ss.surface )
  ss.surface = 0
  if ss.pin then DeleteSprite( ss.pin )
  ss.pin = 0

endfunction


// set the x position of the pin
function Slider_SetX( ss ref as tSliderState, x as integer )

  if x < 0 then x = 0
  if x > ss.xrange then x = ss.xrange

  min# = GetSpriteX( ss.surface )
  width# = GetSpriteWidth( ss.surface ) - GetSpriteWidth( ss.pin )

  SetSpriteX( ss.pin, min# + (x * width#) / ss.xrange )

endfunction

function Slider_SetXPercent( ss ref as tSliderState, xp# as float )
  Slider_SetX( ss, ss.xrange * xp# / 100.0 )
endfunction

function Slider_SetXFraction( ss ref as tSliderState, xf# as float )
  Slider_SetX( ss, ss.xrange * xf# )
endfunction


// set the y position of the pin
function Slider_SetY( ss ref as tSliderState, y as integer )

  if y < 0 then y = 0
  if y > ss.yrange then x = ss.yrange

  min# = GetSpriteY( ss.surface )
  height# = GetSpriteHeight( ss.surface ) - GetSpriteHeight( ss.pin )

  SetSpriteY( ss.pin, min# + (y * height#) / ss.yrange )

endfunction

function Slider_SetYPercent( ss ref as tSliderState, yp# as float )
  Slider_SetY( ss, ss.yrange * yp# / 100.0 )
endfunction

function Slider_SetYFraction( ss ref as tSliderState, yf# as float )
  Slider_SetY( ss, ss.yrange * yf# )
endfunction


// get the x position of the pin
function Slider_GetX( ss ref as tSliderState )
x as integer

  min# = GetSpriteX( ss.surface )
  width# = GetSpriteWidth( ss.surface ) - GetSpriteWidth( ss.pin )

  x = (GetSpriteX( ss.pin ) - min#) * ss.xrange / width#

endfunction x

function Slider_GetXPercent( ss ref as tSliderState )
  xp# = Slider_GetX( ss ) * 100.0 / ss.xrange
endfunction xp#

function Slider_GetXFraction( ss ref as tSliderState )
  xf# = Slider_GetX( ss ) / (1.0 * ss.xrange)
endfunction xf#


// get the y position of the pin
function Slider_GetY( ss ref as tSliderState )
y as integer

  min# = GetSpriteY( ss.surface )
  height# = GetSpriteHeight( ss.surface ) - GetSpriteHeight( ss.pin )

  y = (GetSpriteY( ss.pin ) - min#) * ss.yrange / height#

endfunction y

function Slider_GetYPercent( ss ref as tSliderState )
  yp# = Slider_GetY( ss ) * 100.0 / ss.yrange
endfunction yp#

function Slider_GetYFraction( ss ref as tSliderState )
  yf# = Slider_GetY( ss ) / (1.0 * ss.yrange)
endfunction yf#


// change the depth for sprites of this slider
function Slider_SetDepth( ss ref as tSliderState, depth as integer )

  SetSpriteDepth( ss.surface, depth )
  SetSpriteDepth( ss.pin, depth-1 )

endfunction


// call Slider_Update with mouse information
function Slider_UpdateMouse( ss ref as tSliderState )
  updated = Slider_Update( ss, ScreenToWorldX(GetPointerX()), ScreenToWorldY(GetPointerY()), GetPointerPressed(), GetPointerReleased(), GetPointerState() )
endfunction updated


// call Slider_Update once per frame, or whenever the Slider should be updated
function Slider_Update( ss ref as tSliderState, x# as float, y# as float, pressed as integer, released as integer, state as integer )
updated as integer = 0

  if ss.bVisible and ss.bActive
    pinx# = GetSpriteX( ss.pin )
    piny# = GetSpriteY( ss.pin )

    if GetSpriteHitTest( ss.surface, x#, y# ) and state
      xmin# = GetSpriteX( ss.surface ) + GetSpriteWidth( ss.pin ) / 2
      if x# < xmin# then x# = xmin#
      ymin# = GetSpriteY( ss.surface ) + GetSpriteHeight( ss.pin ) / 2
      if y# < ymin# then y# = ymin#
      xmax# = xmin# + GetSpriteWidth( ss.surface ) - GetSpriteWidth( ss.pin )
      if x# > xmax# then x# = xmax#
      ymax# = ymin# + GetSpriteHeight( ss.surface ) - GetSpriteHeight( ss.pin )
      if y# > ymax# then y# = ymax#

      SetSpritePositionByOffset( ss.pin, x#, y# )
      updated = pinx# <> GetSpriteX( ss.pin ) or piny# <> GetSpriteY( ss.pin )
    endif
  endif

endfunction updated


// set slider to visible or invisible
function Slider_SetVisible( ss ref as tSliderState, bVisible as integer )

  ss.bVisible = bVisible
  Slider_SetActive( ss, bVisible )

  SetSpriteVisible( ss.surface, bVisible )
  SetSpriteVisible( ss.pin, bVisible )

endfunction


// enable/disable the slider
function Slider_SetActive( ss ref as tSliderState, bActive as integer )
  ss.bActive = bActive
endfunction

