// File: progresscircle.agc
// Created: 22-06-06
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


type tProgressCircleState
  sprites as integer[]
  progress as integer
endtype



// initialize the state of a progresscircle instance
function ProgressCircle_Init( x# as float, y# as float, width# as float, height# as float, count as integer, barwidth# as float, barlength# as float )
pc as tProgressCircleState

  if count<1 then count = 1
  pc.sprites.length = count-1

offset as float = 0.0
sign as float = 1.0

  if height# < 0
    offset = 180.0
    sign = -sign
  endif

  if width# < 0 then sign = -sign

  for i = 0 to pc.sprites.length
    pc.sprites[i] = CreateSprite(0)
    angle# = i * 360.0/count
    SetSpriteColorAlpha( pc.sprites[i], 96 )
    SetSpriteSize( pc.sprites[i], barwidth#, barlength# )
    SetSpriteAngle( pc.sprites[i], sign * (offset + angle#) )
    SetSpritePositionByOffset( pc.sprites[i], x# + sin( angle# ) * width# * 0.5, y# - cos( angle# ) * height# * 0.5 )
  next

  pc.progress = 0

endfunction pc


// delete a progresscircle
function ProgressCircle_Delete( pc ref as tProgressCircleState )

  for i = 0 to pc.sprites.length
    DeleteSprite( pc.sprites[i] )
  next i

  pc.sprites.length = -1

endfunction



// call ProgressCircle_Update once per frame, or whenever the progresscircle state should be updated
function ProgressCircle_Update( pc ref as tProgressCircleState, progress as integer )
state as integer

  state = pc.progress

  if progress < 0 then progress = 0
  if progress > pc.sprites.length then progress = pc.sprites.length+1

  if pc.sprites.length >= 0

    if progress > pc.progress
      for i = pc.progress to progress-1
        SetSpriteColorAlpha( pc.sprites[i], 255 )
      next i
    elseif progress < pc.progress
      for i = progress to pc.progress-1
        SetSpriteColorAlpha( pc.sprites[i], 96 )
      next i
    endif

    pc.progress = progress
  endif

endfunction state <> pc.progress


function ProgressCircle_UpdatePercent( pc ref as tProgressCircleState, percent# as float )
  ProgressCircle_Update( pc, percent# * (pc.sprites.length+1) * 0.01 )
endfunction


function ProgressCircle_UpdateFraction( pc ref as tProgressCircleState, fraction# as float )
  ProgressCircle_Update( pc, fraction# * (pc.sprites.length+1) )
endfunction


// set all sprites in progress circle to mode
function ProgressCircle_FixToScreen( pc ref as tProgressCircleState, mode as integer )

  for i = 0 to pc.sprites.length
    FixSpriteToScreen( pc.sprites[i], mode )
  next i

endfunction


// hide/show all sprites in progress circle
function ProgressCircle_SetVisible( pc ref as tProgressCircleState, bVisible as integer )

  for i = 0 to pc.sprites.length
    SetSpriteVisible( pc.sprites[i], bVisible )
  next i

endfunction


// set depth of all sprites in progress circle
function ProgressCircle_SetDepth( pc ref as tProgressCircleState, depth as integer )

  for i = 0 to pc.sprites.length
    SetSpriteDepth( pc.sprites[i], depth )
  next i

endfunction


// set color of all sprites in progress circle
function ProgressCircle_SetColor( pc ref as tProgressCircleState, red as integer, green as integer, blue as integer )

  for i = 0 to pc.sprites.length
    SetSpriteColor( pc.sprites[i], red, green, blue, GetSpriteColorAlpha( pc.sprites[i] ))
  next

endfunction

