// File: progressbarline.agc
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


type tProgressBarLineState
  x# as float
  y# as float
  length# as float
  bVisible as integer
  bVertical as integer
  red as integer
  green as integer
  blue as integer
  maxprogress as integer
endtype



// initialize the state of a progressbar instance
function ProgressBarLine_Init( x# as float, y# as float, length# as float, maxprogress as integer )
pb as tProgressBarLineState

  if maxprogress<1 then maxprogress = 1

  pb.x# = x#
  pb.y# = y#
  pb.length# = length#
  pb.maxprogress = maxprogress

  pb.bVisible = 1
  pb.bVertical = 0
  pb.red = 255
  pb.green = 255
  pb.blue = 255

endfunction pb


// call ProgressBarLine_Update once per frame, or whenever the progressbar should be drawn
function ProgressBarLine_Update( pb ref as tProgressBarLineState, progress as integer )

  if progress < 0 then progress = 0
  if progress > pb.maxprogress then progress = pb.maxprogress

  if pb.bVisible <> 0 
    if pb.bVertical = 0
      DrawLine( pb.x#, pb.y#, pb.x# + (progress * pb.length#)/pb.maxprogress, pb.y#, pb.red, pb.green, pb.blue )
    else
      DrawLine( pb.x#, pb.y#, pb.x#, pb.y# + (progress * pb.length#)/pb.maxprogress, pb.red, pb.green, pb.blue )
    endif
  endif
endfunction


function ProgressBarLine_UpdatePercent( pb ref as tProgressBarLineState, percent# as float )
  ProgressBarLine_Update( pb, percent# * pb.maxprogress * 0.01 )
endfunction


function ProgressBarLine_UpdateFraction( pb ref as tProgressBarLineState, fraction# as float )
  ProgressBarLine_Update( pb, fraction# * pb.maxprogress )
endfunction


// hide/show progressbar
function ProgressBarLine_SetVisible( pb ref as tProgressBarLineState, bVisible as integer )
  pb.bVisible = bVisible
endfunction


// set color of progressbar
function ProgressBarLine_SetColor( pb ref as tProgressBarLineState, red as integer, green as integer, blue as integer )

  pb.red = red
  pb.green = green
  pb.blue = blue

endfunction


// set vertical/horizontal
function ProgressBarLine_SetVertical( pb ref as tProgressBarLineState, bVertical as integer )
  pb.bVertical = bVertical
endfunction

