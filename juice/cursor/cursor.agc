// File: cursor.agc
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


// all information needed to recreate the tweenchain
type tCursorChange
  interpolate as integer
  seconds# as float
  rotate# as float
  sprite as integer
  tween as integer
endtype


type tCursorState
  sprite as integer
  restoresprite as integer
  change as tCursorChange[]
  tweenchain as integer

  bStarted as integer
  bLoop as integer
  bActive as integer
endtype



// initialize the state of a cursor instance
function Cursor_Init( sprite as integer )
c as tCursorState

  c.sprite = CloneSprite( sprite )
  c.restoresprite = CloneSprite( sprite )
  SetSpriteVisible( c.restoresprite, 0 )

  c.tweenchain = CreateTweenChain()
  c.bStarted = 0
  c.bLoop = 1
  c.bActive = 1

endfunction c


// delete this cursor
function Cursor_Delete( c ref as tCursorState )

  if 0 <> c.sprite then DeleteSprite( c.sprite )
  c.sprite = 0
  if 0 <> c.restoresprite then DeleteSprite( c.restoresprite )
  c.restoresprite = 0

  if 0 <> c.tweenchain then DeleteTweenChain( c.tweenchain )
  c.tweenchain = 0

  Cursor_ClearChanges( c )

endfunction


// clear all changes for this cursor
function Cursor_ClearChanges( c ref as tCursorState )

  if 0 <> c.tweenchain
    DeleteTweenChain( c.tweenchain )
    c.tweenchain = CreateTweenChain()
  endif

  for i = 0 to c.change.length
    if c.change[i].sprite <> 0 then DeleteSprite( c.change[i].sprite )
    if 0 <> c.change[i].tween then DeleteTween( c.change[i].tween )
  next i

  c.change.length = -1

  if 0 <> c.restoresprite
    if 0 <> c.sprite then DeleteSprite( c.sprite )
    c.sprite = CloneSprite( c.restoresprite )
    SetSpriteVisible( c.sprite, 1 )
  endif

endfunction


// add a change to the cursor, interpolate = -1 for a sudden change
function Cursor_AddChange( c ref as tCursorState, seconds# as float, interpolate as integer, rotate# as float, sprite as integer )
change as tCursorChange
delay# as float = 0

  if seconds# < 0.1 then seconds# = 0.1

  change.interpolate = interpolate
  change.seconds# = seconds#

  if -1 = interpolate
    interpolate = TweenLinear()
    delay# = seconds# - 0.01
    seconds# = 0.01
  endif

  change.rotate# = rotate#
  change.sprite = CloneSprite( sprite )
  SetSpriteVisible( change.sprite, 0 )

  tween = CreateTweenSprite( seconds# )
  change.tween = tween

  c.change.insert( change )

startsprite as integer

  if c.change.length = 0
    startsprite = c.sprite
  else
    startsprite = c.change[c.change.length-1].sprite
  endif

  if rotate# <> 0 then SetTweenSpriteAngle( tween, GetSpriteAngle( startsprite ), GetSpriteAngle( startsprite ) + rotate#, interpolate )

  start = GetSpriteColorAlpha( startsprite )
  finish = GetSpriteColorAlpha( sprite )
  if start <> finish then SetTweenSpriteAlpha( tween, start, finish, interpolate )

  start = GetSpriteColorRed( startsprite )
  finish = GetSpriteColorRed( sprite )
  if start <> finish then SetTweenSpriteRed( tween, start, finish, interpolate )

  start = GetSpriteColorGreen( startsprite )
  finish = GetSpriteColorGreen( sprite )
  if start <> finish then SetTweenSpriteGreen( tween, start, finish, interpolate )

  start = GetSpriteColorBlue( startsprite )
  finish = GetSpriteColorBlue( sprite )
  if start <> finish then SetTweenSpriteBlue( tween, start, finish, interpolate )

  start = GetSpriteWidth( startsprite )
  finish = GetSpriteWidth( sprite )
  if start <> finish then SetTweenSpriteSizeX( tween, start, finish, interpolate )

  start = GetSpriteHeight( startsprite )
  finish = GetSpriteHeight( sprite )
  if start <> finish then SetTweenSpriteSizeY( tween, start, finish, interpolate )

  start = GetSpriteX( startsprite )
  finish = GetSpriteX( sprite )
  if start <> finish then SetTweenSpriteX( tween, start, finish, interpolate )

  start = GetSpriteY( startsprite )
  finish = GetSpriteY( sprite )
  if start <> finish then SetTweenSpriteY( tween, start, finish, interpolate )

  AddTweenChainSprite( c.tweenchain, tween, c.sprite, delay# )

endfunction


// change cursor back to original state
function Cursor_ChangeRestore( c ref as tCursorState, seconds# as float, interpolate as integer, rotate# as float )
  Cursor_AddChange( c, seconds#, interpolate, rotate#, c.restoresprite )
endfunction


// call Cursor_Update once per frame, or whenever the cursor should be updated
function Cursor_Update( c ref as tCursorState )

  if 0 = c.bActive
    StopTweenChain( c.tweenchain )
    c.bStarted = 0
    exitfunction
  endif

  if 1 = c.bLoop or 0 = c.bStarted then PlayTweenChain( c.tweenchain )
  c.bStarted = 1

endfunction


// advance the cursor animation
function Cursor_AdvanceTime( c ref as tCursorState, seconds# as float )
  UpdateTweenChain( c.tweenchain, seconds# )
endfunction


// change the depth for this cursor
function Cursor_SetDepth( c ref as tCursorState, depth as integer )

  SetSpriteDepth( c.sprite, depth )
  SetSpriteDepth( c.restoresprite, depth )

  for i = 0 to c.change.length
    SetSpriteDepth( c.change[i].sprite, depth )
  next i

endfunction


// set cursor to visible or invisible
function Cursor_SetVisible( c ref as tCursorState, bVisible as integer )
  SetSpriteVisible( c.sprite, bVisible )
endfunction


// set cursor to active or inactive
function Cursor_SetActive( c ref as tCursorState, bActive as integer )
  c.bActive = bActive
endfunction


// set cursor to loop or play only once (cursor will start playing and loop continuously by default)
function Cursor_SetLoop( c ref as tCursorState, bLoop as integer )
  c.bLoop = bLoop
endfunction


// start playing the cursor (cursor will start playing and loop continuously by default)
function Cursor_StartPlaying( c ref as tCursorState )
  c.bStarted = 0
endfunction

