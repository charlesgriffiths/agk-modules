// File: radiobutton.agc
// Created: 22-06-07
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


type tRadioButtonState
  selected as integer
  bActive as integer
  bAllowUnselect as integer

  selectedsprite as integer
  unselectedsprites as integer[]
endtype



// initialize the state of a radiobutton instance
function RadioButton_Init( x# as float, y# as float, spacing# as float, count as integer, selectedsprite as integer, unselectedsprite as integer )
rb as tRadioButtonState

  if count < 1 then count = 1
  
  for i = 0 to count-1
    sprite = CloneSprite( unselectedsprite )
    rb.unselectedsprites.insert( sprite )
    SetSpritePosition( sprite, x#, y# + i * spacing# )
    SetSpriteVisible( sprite, 1 )
  next i
  
  rb.selectedsprite = CloneSprite( selectedsprite )
  rb.selected = -1
  rb.bActive = 1
  rb.bAllowUnselect = 1

  SetSpriteVisible( rb.selectedsprite, 0 )  

endfunction rb


// delete the radiobutton
function RadioButton_Delete( rb ref as tRadioButtonState )

  if rb.selectedsprite > 0 then DeleteSprite( rb.selectedsprite )
  rb.selectedsprite = 0

  for i = 0 to rb.unselectedsprites.length
    if rb.unselectedsprites[i] > 0 then DeleteSprite( rb.unselectedsprites[i] )
    rb.unselectedsprites[i] = 0
  next i

endfunction


// set whether the radiobutton can be unselected
function RadioButton_SetAllowUnselect( rb ref as tRadioButtonState, bAllowUnselect as integer )
  rb.bAllowUnselect = bAllowUnselect
endfunction


// set the selected state of the radiobutton
function RadioButton_SetState( rb ref as tRadioButtonState, selected as integer )

  if selected < 0 and rb.bAllowUnselect <> 0 and rb.selected >= 0
    SetSpriteVisible( rb.unselectedsprites[rb.selected], 1 )
    SetSpriteVisible( rb.selectedsprite, 0 )
    rb.selected = -1
  endif
  
  if selected >= 0 and selected <= rb.unselectedsprites.length
    if rb.selected >= 0 then SetSpriteVisible( rb.unselectedsprites[rb.selected], 1 )
    SetSpriteVisible( rb.unselectedsprites[selected], 0 )
    SetSpriteVisible( rb.selectedsprite, 1 )
    rb.selected = selected
    SetSpritePosition( rb.selectedsprite, GetSpriteX( rb.unselectedsprites[selected] ), GetSpriteY( rb.unselectedsprites[selected] ))
  endif

endfunction rb.selected


// increment the selected state
function RadioButton_Increment( rb ref as tRadioButtonState )

  selected = rb.selected + 1
  if selected > rb.unselectedsprites.length then selected = 0
  RadioButton_SetState( rb, selected )

endfunction


// decrement the selected state
function RadioButton_Decrement( rb ref as tRadioButtonState )

  selected = rb.selected - 1
  if selected < 0 then selected = rb.unselectedsprites.length
  RadioButton_SetState( rb, selected )

endfunction


// get the selected state of the radiobutton
function RadioButton_GetState( rb ref as tRadioButtonState )
endfunction rb.selected


// call RadioButton_Update with mouse information
function RadioButton_UpdateMouse( rb ref as tRadioButtonState )
  RadioButton_Update( rb, ScreenToWorldX(GetPointerX()), ScreenToWorldY(GetPointerY()), GetPointerPressed(), GetPointerReleased(), GetPointerState() )
endfunction


// call RadioButton_Update once per frame, or whenever the radiobutton state should be updated
function RadioButton_Update( rb ref as tRadioButtonState, x# as float, y# as float, pressed as integer, released as integer, state as integer )

  if released = 1 and rb.bActive <> 0
    for i = 0 to rb.unselectedsprites.length
      if GetSpriteHitTest( rb.unselectedsprites[i], x#, y# )
        if rb.bAllowUnselect and i = rb.selected
          RadioButton_SetState( rb, -1 )
        else
          RadioButton_SetState( rb, i )
        endif
      endif
    next i
  endif

endfunction rb.selected


// set the radiobutton to respond to or ignore screen scrolling
function RadioButton_FixSpriteToScreen( rb ref as tRadioButtonState, mode as integer )

  for i = 0 to rb.unselectedsprites.length
    FixSpriteToScreen( rb.unselectedsprites[i], mode )
  next i

  FixSpriteToScreen( rb.selectedsprite, mode )

endfunction


// set radiobutton to visible or invisible
function RadioButton_SetVisible( rb ref as tRadioButtonState, bVisible as integer )

  RadioButton_SetActive( rb, bVisible )

  if bVisible = 0
    for i = 0 to rb.unselectedsprites.length
      SetSpriteVisible( rb.unselectedsprites[i], 0 )
    next i
    SetSpriteVisible( rb.selectedsprite, 0 )
  else
    for i = 0 to rb.unselectedsprites.length
      SetSpriteVisible( rb.unselectedsprites[i], 1 )
    next i
    RadioButton_SetState( rb, rb.selected )
  endif

endfunction


// enable/disable the radiobutton
function RadioButton_SetActive( rb ref as tRadioButtonState, bActive as integer )
  rb.bActive = bActive
endfunction


// set the display depth of the radiobutton
function RadioButton_SetDepth( rb ref as tRadioButtonState, depth as integer )

  for i = 0 to rb.unselectedsprites.length
    SetSpriteDepth( rb.unselectedsprites[i], depth )
  next i
  SetSpriteDepth( rb.selectedsprite, depth )

endfunction

