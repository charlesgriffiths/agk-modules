// File: progressbarsprite.agc
// Created: 22-06-15
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


type tProgressBarSpriteState
  sprite as integer
  maxprogress as integer
  progress as integer

  x# as float
  y# as float
  width# as float
  height# as float

  bVertical as integer
  bDirection as integer
  bAlign as integer
  bActive as integer
endtype



// initialize the state of a progressbar instance
function ProgressBarSprite_Init( sprite as integer, maxprogress as integer )
pb as tProgressBarSpriteState

  if maxprogress < 2 then maxprogress = 1024

  pb.sprite = CloneSprite( sprite )
  pb.maxprogress = maxprogress
  pb.progress = 0

  pb.x# = GetSpriteX( sprite )
  pb.y# = GetSpriteY( sprite )
  pb.width# = GetSpriteWidth( sprite )
  pb.height# = GetSpriteHeight( sprite )

  pb.bVertical = 0
  pb.bDirection = 0
  pb.bAlign = 0
  pb.bActive = 1

endfunction pb


// delete a progressbar
function ProgressBarSprite_Delete( pb ref as tProgressBarSpriteState )

  if pb.sprite <> 0 then DeleteSprite( pb.sprite )
  pb.sprite = 0

endfunction


// call ProgressBar_Update once per frame, or whenever the progressbar state should be updated
function ProgressBarSprite_Update( pb ref as tProgressBarSpriteState, progress as integer )

  if 0 = pb.bActive then exitfunction

  if progress < 0 then progress = 0
  if progress > pb.maxprogress then progress = pb.maxprogress

  spritex# = pb.x#
  spritey# = pb.y#
  barx# = pb.x#
  bary# = pb.y#
  width# = pb.width#
  height# = pb.height#
  
  if pb.bVertical = 0 // horizontal
    width# = (pb.width# * progress) / pb.maxprogress

    if pb.bDirection <> 0 then barx# = barx# + pb.width# - width#
    if pb.bAlign <> 0 and pb.bDirection <> 0 then spritex# = spritex# + pb.width# - width#
    if pb.bAlign <> 0 and pb.bDirection = 0 then spritex# = spritex# - pb.width# + width#
  else // vertical
    height# = (pb.height# * progress) / pb.maxprogress

    if pb.bDirection <> 0 then bary# = bary# + pb.height# - height#
    if pb.bAlign <> 0 and pb.bDirection <> 0 then spritey# = spritey# + pb.height# - height#
    if pb.bAlign <> 0 and pb.bDirection = 0 then spritey# = spritey# - pb.height# + height#
  endif

  SetSpritePosition( pb.sprite, spritex#, spritey# )
  SetSpriteScissor( pb.sprite, barx#, bary#, barx#+width#, bary#+height# )
  updated = progress <> pb.progress
  pb.progress = progress

endfunction updated


function ProgressBarSprite_UpdatePercent( pb ref as tProgressBarSpriteState, percent# as float )
  ProgressBarSprite_Update( pb, percent# * pb.maxprogress * 0.01 )
endfunction


function ProgressBarSprite_UpdateFraction( pb ref as tProgressBarSpriteState, fraction# as float )
  ProgressBarSprite_Update( pb, fraction# * pb.maxprogress )
endfunction


// set sprite in progressbar to mode
function ProgressBarSprite_FixToScreen( pb ref as tProgressBarSpriteState, mode as integer )
  FixSpriteToScreen( pb.sprite, mode )
endfunction


// hide/show sprite in progressbar
function ProgressBarSprite_SetVisible( pb ref as tProgressBarSpriteState, bVisible as integer )
  SetSpriteVisible( pb.sprite, bVisible )
endfunction


// set depth of sprite in progressbar
function ProgressBarSprite_SetDepth( pb ref as tProgressBarSpriteState, depth as integer )
  SetSpriteDepth( pb.sprite, depth )
endfunction


// set the progressbar to vertical/horizontal
function ProgressBarSprite_SetVertical( pb ref as tProgressBarSpriteState, bVertical as integer )
  pb.bVertical = bVertical
endfunction


// set the progressbar to expand in the positive or negative direction
function ProgressBarSprite_SetDirection( pb ref as tProgressBarSpriteState, bDirection as integer )
  pb.bDirection = bDirection
endfunction


// set the progressbar to align at right/left or top/bottom
function ProgressBarSprite_SetAlign( pb ref as tProgressBarSpriteState, bAlign as integer )
  pb.bAlign = bAlign
endfunction


// activate/deactivate the progressbar
function ProgressBarSprite_SetActive( pb ref as tProgressBarSpriteState, bActive as integer )
  pb.bActive = bActive
endfunction


// draw a box around the progressbar area
function ProgressBarSprite_DrawOutline( pb ref as tProgressBarSpriteState, color as integer )
  DrawBox( pb.x#, pb.y#, pb.x#+pb.width#, pb.y#+pb.height#, color, color, color, color, 0 )
endfunction

