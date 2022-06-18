// File: multicheckbox.agc
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


type tMultiCheckBoxState
  selected as integer
  bActive as integer

  sprites as integer[]
endtype



// initialize the state of a multicheckbox instance
function MultiCheckBox_Init( x# as float, y# as float, sprites as integer[] )
mc as tMultiCheckBoxState

  for i = 0 to sprites.length
    mc.sprites.insert( CloneSprite( sprites[i] ))
    SetSpritePosition( mc.sprites[i], x#, y# )
    SetSpriteVisible( mc.sprites[i], 0 )
  next i
  
  mc.selected = 0
  SetSpriteVisible( mc.sprites[0], 1 )

  mc.bActive = 1

endfunction mc


// delete the multicheckbox
function MultiCheckBox_Delete( mc ref as tMultiCheckBoxState )

  for i = 0 to mc.sprites.length
    if mc.sprites[i] > 0 then DeleteSprite( mc.sprites[i] )
    mc.sprites[i] = 0
  next i

endfunction


// set the selected state of the multicheckbox
function MultiCheckBox_SetState( mc ref as tMultiCheckBoxState, selected as integer )

  SetSpriteVisible( mc.sprites[mc.selected], 0 )
  mc.selected = selected
  SetSpriteVisible( mc.sprites[mc.selected], 1 )

endfunction mc.selected


// increment the selected state
function MultiCheckBox_Increment( mc ref as tMultiCheckBoxState )

  selected = mc.selected + 1
  if selected > mc.sprites.length then selected = 0
  MultiCheckBox_SetState( mc, selected )

endfunction


// decrement the selected state
function MultiCheckBox_Decrement( mc ref as tMultiCheckBoxState )

  selected = mc.selected - 1
  if selected < 0 then selected = mc.sprites.length
  MultiCheckBox_SetState( mc, selected )

endfunction


// get the selected state of the multicheckbox
function MultiCheckBox_GetState( mc ref as tMultiCheckBoxState )
endfunction mc.selected


// call MultiCheckBox_Update with mouse information
function MultiCheckBox_UpdateMouse( mc ref as tMultiCheckBoxState )
  updated = MultiCheckBox_Update( mc, ScreenToWorldX(GetPointerX()), ScreenToWorldY(GetPointerY()), GetPointerPressed(), GetPointerReleased(), GetPointerState() )
endfunction updated


// call MultiCheckBox_Update once per frame, or whenever the multicheckbox state should be updated
function MultiCheckBox_Update( mc ref as tMultiCheckBoxState, x# as float, y# as float, pressed as integer, released as integer, state as integer )
selection as integer

  selection = mc.selected
  if released = 1 and mc.bActive <> 0
    if GetSpriteHitTest( mc.sprites[0], x#, y# ) then MultiCheckBox_Increment( mc )
  endif

endfunction selection <> mc.selected


// set the multicheckbox to respond to or ignore screen scrolling
function MultiCheckBox_FixSpriteToScreen( mc ref as tMultiCheckBoxState, mode as integer )

  for i = 0 to mc.sprites.length
    FixSpriteToScreen( mc.sprites[i], mode )
  next i

endfunction


// set multicheckbox to visible or invisible
function MultiCheckBox_SetVisible( mc ref as tMultiCheckBoxState, bVisible as integer )

  MultiCheckBox_SetActive( mc, bVisible )

  if bVisible = 0
    for i = 0 to mc.sprites.length
      SetSpriteVisible( mc.sprites[i], 0 )
    next i
  else
    MultiCheckBox_SetState( mc, mc.selected )
  endif

endfunction


// enable/disable the multicheckbox
function MultiCheckBox_SetActive( mc ref as tMultiCheckBoxState, bActive as integer )
  mc.bActive = bActive
endfunction


// set the display depth of the multicheckbox
function MultiCheckBox_SetDepth( mc ref as tMultiCheckBoxState, depth as integer )

  for i = 0 to mc.sprites.length
    SetSpriteDepth( mc.sprites[i], depth )
  next i

endfunction

