// File: progressbarbox.agc
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


type tProgressBarBoxState
  x# as float
  y# as float
  width# as float
  height# as float
  color1 as integer
  color2 as integer
  color3 as integer
  color4 as integer
  maxprogress as integer

  bVisible as integer
  bFilled as integer
  bVertical as integer
endtype



// initialize the state of a progressbar instance
function ProgressBarBox_Init( x# as float, y# as float, width# as float, height# as float, maxprogress as integer )
pb as tProgressBarBoxState

  if maxprogress<2 then maxprogress = 2

  pb.x# = x#
  pb.y# = y#
  pb.width# = width#
  pb.height# = height#
  pb.maxprogress = maxprogress

  pb.bVisible = 1
  pb.color1 = MakeColor( 255, 255, 255 )
  pb.color2 = MakeColor( 255, 255, 255 )
  pb.color3 = MakeColor( 255, 255, 255 )
  pb.color4 = MakeColor( 255, 255, 255 )
  pb.bFilled = 1
  pb.bVertical = 0

endfunction pb



// call ProgressBarLine_Update once per frame, or whenever the progressbar should be drawn
function ProgressBarBox_Update( pb ref as tProgressBarBoxState, progress as integer )

  if progress < 0 then progress = 0
  if progress > pb.maxprogress then progress = pb.maxprogress

  if pb.bVisible <> 0 
    if pb.bVertical = 0
      DrawBox( pb.x#, pb.y#, pb.x# + (progress * pb.width#)/pb.maxprogress, pb.y# + pb.height#, pb.color1, pb.color2, pb.color3, pb.color4, pb.bFilled )
    else
      DrawBox( pb.x#, pb.y#, pb.x# + pb.width#, pb.y# + (progress * pb.height#)/pb.maxprogress, pb.color1, pb.color2, pb.color3, pb.color4, pb.bFilled )
    endif
  endif

endfunction


function ProgressBarBox_UpdatePercent( pb ref as tProgressBarBoxState, percent# as float )
  ProgressBarBox_Update( pb, percent# * pb.maxprogress * 0.01 )
endfunction


function ProgressBarBox_UpdateFraction( pb ref as tProgressBarBoxState, fraction# as float )
  ProgressBarBox_Update( pb, fraction# * pb.maxprogress )
endfunction


// hide/show progressbar
function ProgressBarBox_SetVisible( pb ref as tProgressBarBoxState, bVisible as integer )
  pb.bVisible = bVisible
endfunction


// set color of progressbar
function ProgressBarBox_SetColor( pb ref as tProgressBarBoxState, red as integer, green as integer, blue as integer )

  pb.color1 = MakeColor( red, green, blue )
  pb.color2 = MakeColor( red, green, blue )
  pb.color3 = MakeColor( red, green, blue )
  pb.color4 = MakeColor( red, green, blue )

endfunction


function ProgressBarBox_SetColor1( pb ref as tProgressBarBoxState, red as integer, green as integer, blue as integer )
  pb.color1 = MakeColor( red, green, blue )
endfunction


function ProgressBarBox_SetColor2( pb ref as tProgressBarBoxState, red as integer, green as integer, blue as integer )
  pb.color2 = MakeColor( red, green, blue )
endfunction


function ProgressBarBox_SetColor3( pb ref as tProgressBarBoxState, red as integer, green as integer, blue as integer )
  pb.color3 = MakeColor( red, green, blue )
endfunction


function ProgressBarBox_SetColor4( pb ref as tProgressBarBoxState, red as integer, green as integer, blue as integer )
  pb.color4 = MakeColor( red, green, blue )
endfunction


// set filled/unfilled progressbar
function ProgressBarBox_SetFilled( pb ref as tProgressBarBoxState, bFilled as integer )
  pb.bFilled = bFilled
endfunction


// set vertical/horizontal progressbar
function ProgressBarBox_SetVertical( pb ref as tProgressBarBoxState, bVertical as integer )
  pb.bVertical = bVertical
endfunction

