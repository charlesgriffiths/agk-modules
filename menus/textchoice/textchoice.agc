// File: textchoice.agc
// Created: 22-06-20
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
// https://github.com/charlesgriffiths/agk-modules/blob/main/menus/textchoice/textchoice.agc


type tTextChoiceItem
  choice$ as string
  text as integer
endtype


type tTextChoiceState
  x# as float
  y# as float
  items as tTextChoiceItem[]
  textsize# as float
  columns as integer
  verticalspacing# as float
  horizontalspacing# as float

  selected as integer[]
  normalcolor as integer
  selectedcolor as integer

  bBoldSelected as integer
  bSelectOnlyOne as integer
  bReposition as integer
endtype



// initialize the state of a textchoice instance
function TextChoice_Init( x# as float, y# as float, textsize# as float, columns as integer, verticalspacing# as float, horizontalspacing# as float )
tc as tTextChoiceState

  if columns < 1 then columns = 1

  tc.x# = x#
  tc.y# = y#
  tc.textsize# = textsize#
  tc.columns = columns
  tc.verticalspacing# = verticalspacing#
  tc.horizontalspacing# = horizontalspacing#
  tc.normalcolor = MakeColor( 255, 255, 255, 255 )
  tc.selectedcolor = MakeColor( 0, 255, 0, 255 )
  tc.bBoldSelected = 1
  tc.bReposition = 0
  tc.bSelectOnlyOne = 0

endfunction tc


// delete a textchoice
function TextChoice_Delete( tc ref as tTextChoiceState )
  TextChoice_ClearChoices( tc )
endfunction


// add a choice to the list
function TextChoice_AddChoice( tc ref as tTextChoiceState, choice$ as string )
tci as tTextChoiceItem

  tci.choice$ = choice$
  tci.text = CreateText( choice$ )
  SetTextSize( tci.text, tc.textsize# )
  SetTextColor( tci.text, GetColorRed( tc.normalcolor ), GetColorGreen( tc.normalcolor ), GetColorBlue( tc.normalcolor ), GetColorAlpha( tc.normalcolor ))
  tc.items.insert( tci )

  tc.bReposition = 1

endfunction

function TextChoice_AddChoices( tc ref as tTextChoiceState, choices$ ref as string[] )

  for i = 0 to choices$.length
    TextChoice_AddChoice( tc, choices$[i] )
  next i

endfunction


// remove all choices from the list
function TextChoice_ClearChoices( tc ref as tTextChoiceState )

  for i = 0 to tc.items.length
    if tc.items[i].text then DeleteText( tc.items[i].text )
  next i
  tc.items.length = -1
  tc.selected.length = -1
  tc.bReposition = 1

endfunction


// call TextChoice_Update with mouse information
function TextChoice_UpdateMouse( tc ref as tTextChoiceState )
  updated = TextChoice_Update( tc, ScreenToWorldX(GetPointerX()), ScreenToWorldY(GetPointerY()), GetPointerPressed(), GetPointerReleased(), GetPointerState() )
endfunction updated


// call TextChoice_Update once per frame, or whenever the textchoice should be updated
function TextChoice_Update( tc ref as tTextChoiceState, x# as float, y# as float, pressed as integer, released as integer, state as integer )
updated as integer = 0
columnwidth# as float[]
rowheight# as float = 0

  if tc.bReposition
    columnwidth#.length = tc.columns-1
    tc.bReposition = 0

    for i = 0 to tc.items.length
      column = mod( i, tc.columns )
      SetTextString( tc.items[i].text, tc.items[i].choice$ )
      SetTextBold( tc.items[i].text, 0 )
      SetTextColor( tc.items[i].text, GetColorRed( tc.normalcolor ), GetColorGreen( tc.normalcolor ), GetColorBlue( tc.normalcolor ), GetColorAlpha( tc.normalcolor ))
      width# = GetTextTotalWidth( tc.items[i].text ) + tc.horizontalspacing#
      if columnwidth#[column] < width# then columnwidth#[column] = width#
    next i

    rowheight# = tc.textsize# + tc.verticalspacing#
    textx# = tc.x#
    texty# = tc.y#
    for i = 0 to tc.items.length
      column = mod( i, tc.columns )
      if i > 0 and 0 = column
        textx# = tc.x#
        texty# = texty# + rowheight#
      elseif column > 0
        textx# = textx# + columnwidth#[column-1]
      endif
      
      SetTextPosition( tc.items[i].text, textx#, texty# )
    next i
    
    for i = 0 to tc.selected.length
      SetTextColor( tc.items[tc.selected[i]].text, GetColorRed( tc.selectedcolor ), GetColorGreen( tc.selectedcolor ), GetColorBlue( tc.selectedcolor ), GetColorAlpha( tc.selectedcolor ))
      if tc.bBoldSelected then SetTextBold( tc.items[tc.selected[i]].text, 1 )
    next i
  endif

  for i = 0 to tc.items.length
    if pressed
      if GetTextHitTest( tc.items[i].text, x#, y# )
        if TextChoice_IsItemSelected( tc, i )
          TextChoice_SetUnselected( tc, i )
        else
          TextChoice_SetSelected( tc, i )
        endif
        updated = 1
      endif
    endif
    
  next i

endfunction updated


// is this item selected?
function TextChoice_IsItemSelected( tc ref as tTextChoiceState, index as integer )

  for i = 0 to tc.selected.length
    if index = tc.selected[i] then exitfunction 1
  next i

endfunction 0


// set this item to selected
function TextChoice_SetSelected( tc ref as tTextChoiceState, index as integer )

  if tc.bSelectOnlyOne
    TextChoice_UnselectAll( tc )
  endif

  if index < 0 or index > tc.items.length then exitfunction
  SetTextColor( tc.items[index].text, GetColorRed( tc.selectedcolor ), GetColorGreen( tc.selectedcolor ), GetColorBlue( tc.selectedcolor ), GetColorAlpha( tc.selectedcolor ))
  if tc.bBoldSelected then SetTextBold( tc.items[index].text, 1 )

  for i = 0 to tc.selected.length
    if index = tc.selected[i] then exitfunction
  next i

  tc.selected.insert( index )

endfunction


// unselect all items
function TextChoice_UnselectAll( tc ref as tTextChoiceState )

  for i = 0 to tc.items.length
    TextChoice_SetUnselected( tc, i )
  next i
  tc.selected.length = -1

endfunction


// set this item to unselected
function TextChoice_SetUnselected( tc ref as tTextChoiceState, index as integer )

  if index < 0 or index > tc.items.length then exitfunction
  SetTextColor( tc.items[index].text, GetColorRed( tc.normalcolor ), GetColorGreen( tc.normalcolor ), GetColorBlue( tc.normalcolor ), GetColorAlpha( tc.selectedcolor ))
  SetTextBold( tc.items[index].text, 0 )

  for i = tc.selected.length to 0 step -1
    if index = tc.selected[i] then tc.selected.remove( i )
  next i

endfunction


// restrict selection count to a maximum of one
function TextChoice_SetSelectOnlyOne( tc ref as tTextChoiceState, bValue as integer )

  tc.bSelectOnlyOne = bValue

  if bValue
    if tc.selected.length > 0
      for i = 0 to tc.items.length
        if i <> tc.selected[0] then TextChoice_SetUnselected( tc, i )
      next i
      tc.selected.length = 0
    endif
    tc.bSelectOnlyOne = 1
  endif

endfunction


// set text size
function TextChoice_SetTextSize( tc ref as tTextChoiceState, textsize# as float )

  tc.textsize# = textsize#
  tc.bReposition = 1

endfunction


// set vertical spacing
function TextChoice_SetVerticalSpacing( tc ref as tTextChoiceState, verticalspacing# as float )

  tc.verticalspacing# = verticalspacing#
  tc.bReposition = 1

endfunction


// set horizontal spacing
function TextChoice_SetHorizontalSpacing( tc ref as tTextChoiceState, horizontalspacing# as float )

  tc.horizontalspacing# = horizontalspacing#
  tc.bReposition = 1

endfunction


// set columns
function TextChoice_SetColumns( tc ref as tTextChoiceState, columns as integer )

  if columns < 1 then columns = 1
  tc.columns = columns
  tc.bReposition = 1

endfunction


// set normal color
function TextChoice_SetColor( tc ref as tTextChoiceState, color as integer )

  tc.normalcolor = color
  tc.bReposition = 1

endfunction


// set selected color
function TextChoice_SetSelectedColor( tc ref as tTextChoiceState, color as integer )

  tc.selectedcolor = color
  tc.bReposition = 1

endfunction


// set selected bold
function TextChoice_SetSelectedBold( tc ref as tTextChoiceState, bBold as integer )

  tc.bBoldSelected = bBold
  tc.bReposition = 1

endfunction


// set position
function TextChoice_SetPosition( tc ref as tTextChoiceState, x# as float, y# as float )

  tc.x# = x#
  tc.y# = y#
  tc.bReposition = 1

endfunction

