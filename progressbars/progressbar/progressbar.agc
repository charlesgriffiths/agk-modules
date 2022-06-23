// File: progressbar.agc
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
//
// https://github.com/charlesgriffiths/agk-modules/blob/main/progressbars/progressbar/progressbar.agc


type tProgressBarState
  sprites as integer[]
  progress as integer
endtype



// initialize the state of a progressbar instance
function ProgressBar_Init( x# as float, y# as float, width# as float, height# as float, count as integer, barwidth# as float, bVertical as integer )
pb as tProgressBarState

  if count<2 then count = 2
  pb.sprites.length = count-1

  if 0 = bVertical and width# < 0
    x# = x# - barwidth#
    width# = width# + 2*barwidth#
  endif
  
  if bVertical and height# < 0
    y# = y# - barwidth#
    height# = height# + 2*barwidth#
  endif

  for i = 0 to pb.sprites.length
    pb.sprites[i] = CreateSprite(0)
    SetSpriteColorAlpha( pb.sprites[i], 96 )
    if bVertical = 0
      SetSpriteSize( pb.sprites[i], barwidth#, height# )
      SetSpritePosition( pb.sprites[i], x# + i*(width#-barwidth#)/(count-1), y# )
    else
      SetSpriteSize( pb.sprites[i], width#, barwidth# )
      SetSpritePosition( pb.sprites[i], x#, y# + i*(height#-barwidth#)/(count-1) )
    endif
  next

  pb.progress = 0

endfunction pb


// delete a progressbar
function ProgressBar_Delete( pb ref as tProgressBarState )

  for i = 0 to pb.sprites.length
    DeleteSprite( pb.sprites[i] )
  next i

  pb.sprites.length = -1

endfunction


// call ProgressBar_Update once per frame, or whenever the progressbar state should be updated
function ProgressBar_Update( pb ref as tProgressBarState, progress as integer )
state as integer

  state = pb.progress
  if progress < 0 then progress = 0
  if progress > pb.sprites.length then progress = pb.sprites.length+1

  if pb.sprites.length >= 0
    if progress > pb.progress
      for i = pb.progress to progress-1
        SetSpriteColorAlpha( pb.sprites[i], 255 )
      next i
    elseif progress < pb.progress
      for i = progress to pb.progress-1
        SetSpriteColorAlpha( pb.sprites[i], 96 )
      next i
    endif

    pb.progress = progress
  endif

endfunction state <> pb.progress


function ProgressBar_UpdatePercent( pb ref as tProgressBarState, percent# as float )
  ProgressBar_Update( pb, percent# * (pb.sprites.length+1) * 0.01 )
endfunction


function ProgressBar_UpdateFraction( pb ref as tProgressBarState, fraction# as float )
  ProgressBar_Update( pb, fraction# * (pb.sprites.length+1) )
endfunction


// set all sprites in progressbar to mode
function ProgressBar_FixToScreen( pb ref as tProgressBarState, mode as integer )

  for i = 0 to pb.sprites.length
    FixSpriteToScreen( pb.sprites[i], mode )
  next i

endfunction


// hide/show all sprites in progressbar
function ProgressBar_SetVisible( pb ref as tProgressBarState, bVisible as integer )

  for i = 0 to pb.sprites.length
    SetSpriteVisible( pb.sprites[i], bVisible )
  next i

endfunction


// set depth of all sprites in progressbar
function ProgressBar_SetDepth( pb ref as tProgressBarState, depth as integer )

  for i = 0 to pb.sprites.length
    SetSpriteDepth( pb.sprites[i], depth )
  next i

endfunction


// set color of all sprites in progressbar
function ProgressBar_SetColor( pb ref as tProgressBarState, red as integer, green as integer, blue as integer )

  for i = 0 to pb.sprites.length
    SetSpriteColor( pb.sprites[i], red, green, blue, GetSpriteColorAlpha( pb.sprites[i] ))
  next

endfunction

