// File: detectclick.agc
// Created: 22-07-23
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
// https://github.com/charlesgriffiths/agk-modules/blob/main/other/detectclick/detectclick.agc


#constant DetectClick_SingleClick 1
#constant DetectClick_DoubleClick 2
#constant DetectClick_LongClick 4
#constant DetectClick_ControlClick 8
#constant DetectClick_ShiftClick 16
#constant DetectClick_AltClick 32


type tDetectClickState
  x# as float
  y# as float
  width# as float
  height# as float

  bMouseDown as integer
  mousedowntime# as float
  mouseuptime# as float
  mousedownx# as float
  mousedowny# as float

  bActive as integer
  detectonly as integer
endtype


// initialize a detectclick instance
function DetectClick_Init( x# as float, y# as float, width# as float, height# as float )
dc as tDetectClickState

  dc.x# = x#
  dc.y# = y#
  dc.width# = width#
  dc.height# = height#

  dc.bActive = 1
  dc.detectonly = 63

endfunction dc


// set click detection to limited directions
function DetectClick_DetectOnly( dc ref as tDetectClickState, detectonly as integer )
  dc.detectonly = detectonly
endfunction


// call DetectClick_Update with mouse information
function DetectClick_UpdateMouse( dc ref as tDetectClickState )
  detected = DetectClick_Update( dc, ScreenToWorldX(GetPointerX()), ScreenToWorldY(GetPointerY()), GetPointerPressed(), GetPointerReleased(), GetPointerState() )
endfunction detected


// call DetectClick_Update once per frame, or whenever the state should be updated
function DetectClick_Update( dc ref as tDetectClickState, x# as float, y# as float, pressed as integer, released as integer, state as integer )
detected as integer = 0

  if dc.bActive
    if x# >= dc.x# and x# <= dc.x# + dc.width# and y# >= dc.y# and y# <= dc.y# + dc.height#
      if pressed
        dc.bMouseDown = 1
        dc.mousedowntime# = 0
        dc.mousedownx# = x#
        dc.mousedowny# = y#
      elseif released and dc.bMouseDown
        dc.bMouseDown = 0

        detected = DetectClick_SingleClick
        if dc.mouseuptime# < 0.25 then detected = detected || DetectClick_DoubleClick

// KEY_SHIFT        16
// KEY_CONTROL      17
// KEY_ALT          18        

        if GetRawKeyState( 16 ) then detected = detected || DetectClick_ShiftClick
        if GetRawKeyState( 17 ) then detected = detected || DetectClick_ControlClick
        if GetRawKeyState( 18 ) then detected = detected || DetectClick_AltClick

        dc.mousedowntime# = 0
        dc.mouseuptime# = 0
      elseif state
        inc dc.mousedowntime#, GetFrameTime()
        if dc.mousedowntime# > 1 then detected = DetectClick_LongClick
      else
        inc dc.mouseuptime#, GetFrameTime()
      endif
    else
      dc.bMouseDown = 0
    endif
  endif

  if 0 = state then dc.bMouseDown = 0

endfunction dc.detectonly && detected


// enable/disable the detectclick
function DetectClick_SetActive( dc ref as tDetectClickState, bActive as integer )
  dc.bActive = bActive
endfunction


function DetectClick_DrawBox( dc ref as tDetectClickState, color as integer )
  DrawBox( dc.x#, dc.y#, dc.x#+dc.width#, dc.y#+dc.height#, color, color, color, color, 0 )
endfunction

