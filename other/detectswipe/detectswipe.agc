// File: detectswipe.agc
// Created: 22-07-01
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
// https://github.com/charlesgriffiths/agk-modules/blob/main/other/detectswipe/detectswipe.agc



#constant DetectSwipe_UP 1
#constant DetectSwipe_DOWN 2
#constant DetectSwipe_RIGHT 4
#constant DetectSwipe_LEFT 8


type tDetectSwipeState
  x# as float
  y# as float
  width# as float
  height# as float

  bMouseDown as integer
  mousedownx# as float
  mousedowny# as float
  swipedistance# as float

  bActive as integer
  bOneSwipePerPress as integer
  detectonly as integer
endtype


// initialize a detectswipe instance
function DetectSwipe_Init( x# as float, y# as float, width# as float, height# as float )
ds as tDetectSwipeState

  ds.x# = x#
  ds.y# = y#
  ds.width# = width#
  ds.height# = height#
  ds.swipedistance# = 0

  ds.bActive = 1
  ds.detectonly = 15

endfunction ds


// control the sensitivity of swipe detection
function DetectSwipe_SetSwipeDistance( ds ref as tDetectSwipeState, distance# as float )
  ds.swipedistance# = distance#
endfunction


// set swipe detection to limited directions
function DetectSwipe_DetectOnly( ds ref as tDetectSwipeState, detectonly as integer )
  ds.detectonly = detectonly
endfunction


// call DetectSwipe_Update with mouse information
function DetectSwipe_UpdateMouse( ds ref as tDetectSwipeState )
  detected = DetectSwipe_Update( ds, ScreenToWorldX(GetPointerX()), ScreenToWorldY(GetPointerY()), GetPointerPressed(), GetPointerReleased(), GetPointerState() )
endfunction detected


// call DetectSwipe_Update once per frame, or whenever the state should be updated
function DetectSwipe_Update( ds ref as tDetectSwipeState, x# as float, y# as float, pressed as integer, released as integer, state as integer )
detected as integer = 0

  if ds.bActive
    if x# >= ds.x# and x# <= ds.x# + ds.width# and y# >= ds.y# and y# <= ds.y# + ds.height#
      if pressed
        ds.bMouseDown = 1
        ds.mousedownx# = x#
        ds.mousedowny# = y#
      elseif ds.bMouseDown

        if ds.swipedistance# > 0
          if x# - ds.mousedownx# > ds.swipedistance# then detected = detected || DetectSwipe_RIGHT
          if ds.mousedownx# - x# > ds.swipedistance# then detected = detected || DetectSwipe_LEFT
          if y# - ds.mousedowny# > ds.swipedistance# then detected = detected || DetectSwipe_DOWN
          if ds.mousedowny# - y# > ds.swipedistance# then detected = detected || DetectSwipe_UP
        else
          if ds.mousedownx# - ds.x# < ds.width#/2
            if x# - ds.x# > ds.width#/2 then detected = detected || DetectSwipe_RIGHT
          else
            if x# - ds.x# < ds.width#/2 then detected = detected || DetectSwipe_LEFT
          endif
          if ds.mousedowny# - ds.y# < ds.height#/2
           if y# - ds.y# > ds.height#/2 then detected = detected || DetectSwipe_DOWN
          else
            if y# - ds.y# < ds.height#/2 then detected = detected || DetectSwipe_UP
          endif

          if x# - ds.mousedownx# > ds.width#/10 then detected = detected || DetectSwipe_RIGHT
          if ds.mousedownx# - x# > ds.width#/10 then detected = detected || DetectSwipe_LEFT
          if y# - ds.mousedowny# > ds.height#/10 then detected = detected || DetectSwipe_DOWN
          if ds.mousedowny# - y# > ds.height#/10 then detected = detected || DetectSwipe_UP
        endif
      endif
    else
      ds.bMouseDown = 0
    endif
  endif

  if 0 = state then ds.bMouseDown = 0

  detected = detected && ds.detectonly
  if detected
    if ds.bOneSwipePerPress
      ds.bMouseDown = 0
    else
      ds.mousedownx# = x#
      ds.mousedowny# = y#
    endif
  endif

endfunction detected


// enable/disable the detectswipe
function DetectSwipe_SetActive( ds ref as tDetectSwipeState, bActive as integer )
  ds.bActive = bActive
endfunction


function DetectSwipe_DrawBox( ds ref as tDetectSwipeState, color as integer )
  DrawBox( ds.x#, ds.y#, ds.x#+ds.width#, ds.y#+ds.height#, color, color, color, color, 0 )
endfunction

