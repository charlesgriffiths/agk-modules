// File: pane.agc
// Created: 22-06-27
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
// https://github.com/charlesgriffiths/agk-modules/blob/main/juice/pane/pane.agc


type tPaneLocation
  x# as float
  y# as float
  tag$ as string
  easing as integer
endtype

type tPaneSprite
  id as integer
  x# as float
  y# as float
endtype

type tPaneText
  id as integer
  x# as float
  y# as float
endtype

type tPaneEditBox
  id as integer
  x# as float
  y# as float
endtype


type tPaneState
  x# as float
  y# as float
  width# as float
  height# as float
  sprite as integer
  color as integer

  locations as tPaneLocation[]
  sprites as tPaneSprite[]
  texts as tPaneText[]
  editboxes as tPaneEditBox[]

  tween as integer
  tweenseconds# as float

  bActive as integer
  bVisible as integer
endtype


// initialize a pane instance
function Pane_Init( width# as float, height# as float )
p as tPaneState

  p.width# = width#
  p.height# = height#

  p.sprite = CreateSprite( 0 )
  SetSpriteSize( p.sprite, width#, height# )
  SetSpritePositionByOffset( p.sprite, GetVirtualWidth()/2, GetVirtualHeight()/2 )
  p.x# = GetSpriteX( p.sprite )
  p.y# = GetSpriteY( p.sprite )
  
  if width# > 1 or height# > 1
    p.color = MakeColor( 255, 255, 255, 255 )
  else
    p.color = MakeColor( 0, 0, 0, 0 )
    SetSpriteColor( p.sprite, 0, 0, 0, 0 )
  endif

  p.tween = 0
  p.tweenseconds# = 0.5
  p.bActive = 1
  p.bVisible = 1

endfunction p


function Pane_Delete( p ref as tPaneState )

  Pane_TweenStop( p )
  if p.sprite then DeleteSprite( p.sprite )
  p.sprite = 0

endfunction


function Pane_SetBackground( p ref as tPaneState, sprite as integer )
x# as float
y# as float

  Pane_TweenStop( p )
  if p.sprite
    x# = GetSpriteX( p.sprite )
    y# = GetSpriteY( p.sprite )
    DeleteSprite( p.sprite )
    p.sprite = 0
  else
    x# = p.x#
    y# = p.y#
  endif

  if sprite > 0
    p.sprite = CloneSprite( sprite )
  else
    p.sprite = CreateSprite( 0 )
    SetSpriteColor( p.sprite, GetColorRed( p.color ), GetColorGreen( p.color ), GetColorBlue( p.color ), GetColorAlpha( p.color ))
  endif

  SetSpriteSize( p.sprite, p.width#, p.height# )
  SetSpritePosition( p.sprite, x#, y# )

endfunction


function Pane_SetColor( p ref as tPaneState, color as integer )

  p.color = color
  if p.sprite then SetSpriteColor( p.sprite, GetColorRed( color ), GetColorGreen( color ), GetColorBlue( color ), GetColorAlpha( color ))

endfunction


function Pane_AddSpriteCurrent( p ref as tPaneState, sprite as integer )
  Pane_AddSprite( p, sprite, GetSpriteX( sprite ), GetSpriteY( sprite ))
endfunction

function Pane_AddSprite( p ref as tPaneState, sprite as integer, x# as float, y# as float )
ps as tPaneSprite

  ps.id = sprite
  ps.x# = x#
  ps.y# = y#

  SetSpritePosition( sprite, p.x# + x#, p.y# + y# )

  p.sprites.insert( ps )

endfunction


function Pane_AddTextCurrent( p ref as tPaneState, text as integer )
  Pane_AddText( p, text, GetTextX( text ), GetTextY( text ))
endfunction

function Pane_AddText( p ref as tPaneState, text as integer, x# as float, y# as float )
pt as tPaneText

  pt.id = text
  pt.x# = x#
  pt.y# = y#

  SetTextPosition( text, p.x# + x#, p.y# + y# )

  p.texts.insert( pt )

endfunction



function Pane_Update( p ref as tPaneState )
x# as float
y# as float

  if not p.bActive then exitfunction

  x# = GetSpriteX( p.sprite )
  y# = GetSpriteY( p.sprite )

  if x# <> p.x# or y# <> p.y#
    p.x# = x#
    p.y# = y#

    for i = 0 to p.sprites.length
      SetSpritePosition( p.sprites[i].id, x# + p.sprites[i].x#, y# + p.sprites[i].y# )
    next i

    for i = 0 to p.texts.length
      SetTextPosition( p.texts[i].id, x# + p.texts[i].x#, y# + p.texts[i].y# )
    next i

    for i = 0 to p.editboxes.length
      SetEditBoxPosition( p.editboxes[i].id, x# + p.editboxes[i].x#, y# + p.editboxes[i].y# )
    next i
  endif

endfunction


function Pane_SetCurrentLocation( p ref as tPaneState, tag$ as string, easing as integer )
  Pane_SetLocation( p , tag$, GetSpriteX( p.sprite ), GetSpriteY( p.sprite ), easing )
endfunction


function Pane_SetLocation( p ref as tPaneState, tag$ as string, x# as float, y# as float, easing as integer )
pl as tPaneLocation

  pl.x# = x#
  pl.y# = y#
  pl.tag$ = tag$
  pl.easing = easing

  for i = p.locations.length to 0 step -1
    if CompareString( tag$, p.locations[i].tag$ ) then p.locations.remove( i )
  next i

  p.locations.insert( pl )

endfunction


function Pane_IsTweening( p ref as tPaneState )
  playing = GetTweenSpritePlaying( p.tween, p.sprite )
endfunction playing


function Pane_TweenStop( p ref as tPaneState )

  if p.tween
    if GetTweenSpritePlaying( p.tween, p.sprite ) then StopTweenSprite( p.tween, p.sprite )
    DeleteTween( p.tween )
    p.tween = 0
  endif

endfunction


function Pane_MoveTo( p ref as tPaneState, tag$ as string )

  Pane_TweenStop( p )
  for i = 0 to p.locations.length
    if CompareString( tag$, p.locations[i].tag$ )
      SetSpritePosition( p.sprite, p.locations[i].x#, p.locations[i].y# )
      Pane_Update( p )
      exit
    endif
  next i

endfunction


function Pane_TweenTo( p ref as tPaneState, tag$ as string, delay# as float )

  Pane_TweenStop( p )
  for i = 0 to p.locations.length
    if CompareString( tag$, p.locations[i].tag$ )
      p.tween = CreateTweenSprite( p.tweenseconds# )
      SetTweenSpriteX( p.tween, p.x#, p.locations[i].x#, p.locations[i].easing )
      SetTweenSpriteY( p.tween, p.y#, p.locations[i].y#, p.locations[i].easing )
      PlayTweenSprite( p.tween, p.sprite, delay# )
      exit
    endif
  next i

endfunction


function Pane_TweenIn( p ref as tPaneState, delay# as float )
  Pane_TweenTo( p, "in", delay# )
endfunction


function Pane_TweenOut( p ref as tPaneState, delay# as float )
  Pane_TweenTo( p, "out", delay# )
endfunction


function Pane_SetVisible( p ref as tPaneState, bVisible as integer )

  p.bVisible = bVisible
  
  SetSpriteVisible( p.sprite, bVisible )

  for i = 0 to p.sprites.length
    SetSpriteVisible( p.sprites[i].id, bVisible )
  next i

  for i = 0 to p.texts.length
    SetTextVisible( p.texts[i].id, bVisible )
  next i

  for i = 0 to p.editboxes.length
    SetEditBoxVisible( p.editboxes[i].id, bVisible )
  next i

endfunction


function Pane_SetActive( p ref as tPaneState, bActive as integer )

  p.bActive = bActive

  if bActive
    ResumeTweenSprite( p.tween, p.sprite )
  else
    PauseTweenSprite( p.tween, p.sprite )
  endif

endfunction


function Pane_Show( p ref as tPaneState, bShow as integer )

  Pane_SetActive( p, bShow )
  Pane_SetVisible( p, bShow )

endfunction


function Pane_DrawBox( p ref as tPaneState, color as integer )
  DrawBox( p.x#, p.y#, p.x# + p.width#, p.y# + p.height#, color, color, color, color, 0 )
endfunction

