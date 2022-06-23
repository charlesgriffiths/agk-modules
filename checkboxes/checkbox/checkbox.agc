// File: checkbox.agc
// Created: 22-05-20
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
// https://github.com/charlesgriffiths/agk-modules/blob/main/checkboxes/checkbox/checkbox.agc


#constant CheckBox_Uncheck 0
#constant CheckBox_Check 1


type tCheckBoxState
  checkedsprite as integer
  uncheckedsprite as integer

  checked as integer
  bActive as integer
endtype



// initialize the state of a checkbox instance
function CheckBox_Init( x# as float, y# as float, checkedsprite as integer, uncheckedsprite as integer )
cb as tCheckBoxState

  cb.checkedsprite = CloneSprite( checkedsprite )
  cb.uncheckedsprite = CloneSprite( uncheckedsprite )

  SetSpritePosition( cb.checkedsprite, x#, y# )
  SetSpritePosition( cb.uncheckedsprite, x#, y# )

  CheckBox_SetActive( cb, 1 )
  CheckBox_SetState( cb, CheckBox_Uncheck )

endfunction cb


// delete the checkbox
function CheckBox_Delete( cb ref as tCheckBoxState )

  if cb.checkedsprite then DeleteSprite( cb.checkedsprite )
  cb.checkedsprite = 0

  if cb.uncheckedsprite then DeleteSprite( cb.uncheckedsprite )
  cb.uncheckedsprite = 0

endfunction


// set the checked/unchecked state of the checkbox
function CheckBox_SetState( cb ref as tCheckBoxState, bChecked as integer )

  if CheckBox_Uncheck = bChecked
    SetSpriteVisible( cb.checkedsprite, 0 )
    SetSpriteVisible( cb.uncheckedsprite, 1 )
    cb.checked = CheckBox_Uncheck
  else
    SetSpriteVisible( cb.checkedsprite, 1 )
    SetSpriteVisible( cb.uncheckedsprite, 0 )
    cb.checked = CheckBox_Check
  endif

endfunction cb.checked


// get the checked/unchecked state of the checkbox
function CheckBox_GetState( cb ref as tCheckBoxState )
endfunction cb.checked


// call CheckBox_Update with mouse information
function CheckBox_UpdateMouse( cb ref as tCheckBoxState )
  changed = CheckBox_Update( cb, ScreenToWorldX(GetPointerX()), ScreenToWorldY(GetPointerY()), GetPointerPressed(), GetPointerReleased(), GetPointerState() )
endfunction changed


// call CheckBox_Update once per frame, or whenever the checkbox state should be updated
function CheckBox_Update( cb ref as tCheckBoxState, x# as float, y# as float, pressed as integer, released as integer, state as integer )
state = cb.checked

  if released and cb.bActive
    if GetSpriteHitTest( cb.checkedsprite, x#, y# )
      if CheckBox_Uncheck = cb.checked
        CheckBox_SetState( cb, CheckBox_Check )
      else
        CheckBox_SetState( cb, CheckBox_Uncheck )
      endif
    endif
  endif

endfunction state <> cb.checked


// set the checkbox to respond to or ignore screen scrolling
function CheckBox_FixSpriteToScreen( cb ref as tCheckBoxState, mode as integer )

  FixSpriteToScreen( cb.checkedsprite, mode )
  FixSpriteToScreen( cb.uncheckedsprite, mode )

endfunction


// set checkbox to visible or invisible
function CheckBox_SetVisible( cb ref as tCheckBoxState, bVisible as integer )

  CheckBox_SetActive( cb, bVisible )

  if bVisible
    CheckBox_SetState( cb, cb.checked )
  else
    SetSpriteVisible( cb.checkedsprite, 0 )
    SetSpriteVisible( cb.uncheckedsprite, 0 )
  endif

endfunction


// enable/disable the checkbox
function CheckBox_SetActive( cb ref as tCheckBoxState, bActive as integer )
  cb.bActive = bActive
endfunction


// set the display depth of the checkbox
function CheckBox_SetDepth( cb ref as tCheckBoxState, depth as integer )

  SetSpriteDepth( cb.checkedsprite, depth )
  SetSpriteDepth( cb.uncheckedsprite, depth )

endfunction

