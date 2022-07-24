// File: editboxes.agc
// Created: 22-06-24
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
// https://github.com/charlesgriffiths/agk-modules/blob/main/other/editboxes/editboxes.agc


#constant EditBoxes_AlignLeft 0
#constant EditBoxes_AlignCenter 1
#constant EditBoxes_AlignRight 2


type tEditBox
  id as integer
  text as integer
  x# as float
  y# as float
  textsize# as float
  minwidth# as float
  maxwidth# as float
  maxchars as integer
  width# as float
  text$ as string
  label$ as string
  label as integer

  bNumeric as integer
  precision as integer
  minvalue# as float
  maxvalue# as float
  allowed as string[]
  whitespace as integer
  bkcolor as integer
  textcolor as integer
  labelcolor as integer

  alignment as integer
  alignx# as float

  clickable as integer
endtype

type tEditBoxes
  x# as float
  y# as float
  boxes as tEditBox[]
  grabfocus as integer

  bFixHtmlNumlock as integer
  bVisible as integer
  bActive as integer
endtype



// initialize the state of an editboxes instance
function EditBoxes_Init( x# as float, y# as float )
ebs as tEditBoxes

  ebs.x# = x#
  ebs.y# = y#
  ebs.grabfocus = -1

  ebs.bVisible = 1
  ebs.bActive = 1

endfunction ebs


function EditBoxes_Delete( ebs ref as tEditBoxes )

  for i = 0 to ebs.boxes.length
    if ebs.boxes[i].id then DeleteEditBox( ebs.boxes[i].id )
    if ebs.boxes[i].text then DeleteText( ebs.boxes[i].text )
    if ebs.boxes[i].label then DeleteText( ebs.boxes[i].label )
    if ebs.boxes[i].whitespace then DeleteSprite( ebs.boxes[i].whitespace )
    if ebs.boxes[i].clickable then DeleteSprite( ebs.boxes[i].clickable )
  next i
  ebs.boxes.length = -1

endfunction


// add an editbox to the editboxes
function EditBoxes_AddBox( ebs ref as tEditBoxes, x# as float, y# as float, minwidth# as float, maxwidth# as float, textsize# as float, maxchars as integer )
eb as tEditBox

  eb.id = CreateEditBox()
  eb.text = CreateText( "" )
  eb.x# = x#
  eb.y# = y#
  eb.textsize# = textsize#
  eb.minwidth# = minwidth#
  eb.maxwidth# = maxwidth#
  eb.maxchars = maxchars
  eb.width# = minwidth#
  eb.bkcolor = MakeColor( 255, 255, 255, 255 )

  SetEditBoxPosition( eb.id, ebs.x# + x#, ebs.y# + y# )
  SetEditBoxSize( eb.id, minwidth# + 100, textsize# * 1.4 )
  SetEditBoxTextSize( eb.id, textsize# )
  SetEditBoxMaxChars( eb.id, maxchars )
  SetEditBoxCursorWidth( eb.id, textsize#*0.1 )
  SetEditBoxBorderSize( eb.id, 0 )

  SetTextPosition( eb.text, ebs.x# + x#, ebs.y# + y# )
  SetTextDepth( eb.text, 2+GetEditBoxDepth( eb.id ))
  SetTextSize( eb.text, textsize# )
  SetTextScissor( eb.text, ebs.x# + x#, ebs.y# + y#, ebs.x# + x# + maxwidth#, ebs.y# + y# + textsize# * 1.18 )

  ebs.boxes.insert( eb )

endfunction


// add a label that will display inside the box when the box is empty
function EditBoxes_SetLabel( ebs ref as tEditBoxes, index as integer, label$ as string )

  ebs.boxes[index].label$ = label$
  label = CreateText( label$ )
  SetTextSize( label, ebs.boxes[index].textsize# )
  if ebs.boxes[index].labelcolor
    color = ebs.boxes[index].labelcolor
    SetTextColor( label, GetColorRed( color ), GetColorGreen( color ), GetColorBlue( color ), GetColorAlpha( color ))
  else
    SetTextColor( label, 0, 0, 0, 96 )
  endif
  ymargin# = 0.5*(ebs.boxes[index].textsize#*1.18 - GetTextTotalHeight( label ))
  SetTextPosition( label, ebs.x# + ebs.boxes[index].x# + ebs.boxes[index].textsize#*0.15, ebs.y# + ebs.boxes[index].y# + ymargin# )
  ebs.boxes[index].label = label

endfunction


// create an invisible area around the textbox that will focus on the textbox if clicked
function EditBoxes_SetClickableArea( ebs ref as tEditBoxes, index as integer, width# as float, height# as float )

  if ebs.boxes[index].clickable
    DeleteSprite( ebs.boxes[index].clickable )
    ebs.boxes[index].clickable = 0
  endif
  
  if width# > 0 and height# > 0
    clickable = CreateSprite( 0 )
    SetSpriteSize( clickable, width#, height# )
    SetSpriteVisible( clickable, 0 )
    SetSpritePositionByOffset( clickable, GetEditBoxX( ebs.boxes[index].id ) + 0.5 * ebs.boxes[index].width#, GetEditBoxY( ebs.boxes[index].id ) + ebs.boxes[index].textsize# * 0.59 )
    ebs.boxes[index].clickable = clickable
  endif

endfunction


function EditBoxes_SetBackgroundColor( ebs ref as tEditBoxes, index as integer, color as integer )

  ebs.boxes[index].bkcolor = color
  SetEditBoxBackgroundColor( ebs.boxes[index].id, GetColorRed( color ), GetColorGreen( color ), GetColorBlue( color ), GetColorAlpha( color ))
  if ebs.boxes[index].whitespace then SetSpriteColor( ebs.boxes[index].whitespace, GetColorRed( color ), GetColorGreen( color ), GetColorBlue( color ), GetColorAlpha( color ))

endfunction

function EditBoxes_SetTextColor( ebs ref as tEditBoxes, index as integer, color as integer )

  ebs.boxes[index].textcolor = color
  SetEditBoxTextColor( ebs.boxes[index].id, GetColorRed( color ), GetColorGreen( color ), GetColorBlue( color ))
  if ebs.boxes[index].text then SetTextColor( ebs.boxes[index].text, GetColorRed( color ), GetColorGreen( color ), GetColorBlue( color ), GetColorAlpha( color ))

endfunction

function EditBoxes_SetLabelColor( ebs ref as tEditBoxes, index as integer, color as integer )

  ebs.boxes[index].labelcolor = color
  if ebs.boxes[index].label then SetTextColor( ebs.boxes[index].label, GetColorRed( color ), GetColorGreen( color ), GetColorBlue( color ), GetColorAlpha( color ))

endfunction


// set contents of editbox to "" (numeric does not convert to 0)
function EditBoxes_ClearText( ebs ref as tEditBoxes, index as integer )

  ebs.boxes[index].text$ = ""
  SetEditBoxText( ebs.boxes[index].id, "" )
  SetTextString( ebs.boxes[index].text, "" )

endfunction


// set the text of an editbox
function EditBoxes_SetText( ebs ref as tEditBoxes, index as integer, text$ as string )

  if ebs.boxes[index].bNumeric and len( text$ )
    val# = ValFloat( text$ )
    if val# > ebs.boxes[index].maxvalue# then val# = ebs.boxes[index].maxvalue#
    if val# < ebs.boxes[index].minvalue# then val# = ebs.boxes[index].minvalue#
    text$ = str( val#, ebs.boxes[index].precision )
    if ebs.boxes[index].precision > 0
      while len( text$ ) > 1 and CompareString( "0", right( text$, 1 ))
        text$ = left( text$, len( text$ )-1 )
      endwhile
      if CompareString( ".", right( text$, 1 )) then text$ = left( text$, len( text$ )-1 )
    endif
  endif

  SetEditBoxText( ebs.boxes[index].id, text$ )
  ebs.boxes[index].text$ = text$
  SetTextString( ebs.boxes[index].text, text$ )

endfunction

function EditBoxes_SetTexts( ebs ref as tEditBoxes, text$ ref as string[] )

  for i = 0 to ebs.boxes.length
    if i > text$.length then exit
    EditBoxes_SetText( ebs, i, text$[i] )
  next i

endfunction


// get the text of an editbox
function EditBoxes_GetText( ebs ref as tEditBoxes, index as integer )
text$ as string

  text$ = GetEditBoxText( ebs.boxes[index].id)
  ebs.boxes[index].text$ = text$

endfunction text$

function EditBoxes_GetTexts( ebs ref as tEditBoxes, text$ ref as string[] )

  if ebs.boxes.length > text$.length then text$.length = ebs.boxes.length
  for i = 0 to ebs.boxes.length
    text$[i] = EditBoxes_GetText( ebs, i )
  next i

endfunction


// gets numeric value of editbox, with range and precision
function EditBoxes_GetValue( ebs ref as tEditBoxes, index as integer )
value# as float

  value# = ValFloat( EditBoxes_GetText( ebs, index ))
  if ebs.boxes[index].bNumeric
    if value# > ebs.boxes[index].maxvalue# then value# = ebs.boxes[index].maxvalue#
    if value# < ebs.boxes[index].minvalue# then value# = ebs.boxes[index].minvalue#
    value# = ValFloat( str( value#, ebs.boxes[index].precision ))
  endif

endfunction value#


function EditBoxes_SetAlignment( ebs ref as tEditBoxes, index as integer, alignment as integer, alignx# as float )

  ebs.boxes[index].alignment = alignment
  ebs.boxes[index].alignx# = alignx#

  select alignment
    case EditBoxes_AlignLeft:
      EditBoxes_SetX( ebs, index, alignx# )
    endcase

    case EditBoxes_AlignCenter:
      EditBoxes_DoAlignCenter( ebs, index )
    endcase

    case EditBoxes_AlignRight:
      EditBoxes_DoAlignRight( ebs, index )
    endcase
  endselect

endfunction


function EditBoxes_DoAlignCenter( ebs ref as tEditBoxes, index as integer )
  EditBoxes_SetX( ebs, index, ebs.boxes[index].alignx# - 0.5 * ebs.boxes[index].width# )
endfunction


function EditBoxes_DoAlignRight( ebs ref as tEditBoxes, index as integer )
  EditBoxes_SetX( ebs, index, ebs.boxes[index].alignx# - ebs.boxes[index].width# )
endfunction


// get the current display width of an editbox
function EditBoxes_GetWidth( ebs ref as tEditBoxes, index as integer )
endfunction ebs.boxes[index].width#


// set x# relative to ebs.x#
function EditBoxes_SetX( ebs ref as tEditBoxes, index as integer, x# as float )
y# as float

  ebs.boxes[index].x# = x#
  y# = ebs.boxes[index].y#
  boxx# = ebs.x# + x#
  boxy# = ebs.y# + y#
  SetTextPosition( ebs.boxes[index].text, boxx#, boxy# )
  SetEditBoxPosition( ebs.boxes[index].id, boxx#, boxy# )
  SetEditBoxScissor( ebs.boxes[index].id, boxx#, boxy#, boxx# + ebs.boxes[index].width#, boxy# + ebs.boxes[index].textsize# * 1.18 )
  if ebs.boxes[index].label
    ymargin# = 0.5*(ebs.boxes[index].textsize#*1.18 - GetTextTotalHeight( ebs.boxes[index].label ))
    SetTextPosition( ebs.boxes[index].label, ebs.x# + ebs.boxes[index].x# + ebs.boxes[index].textsize#*0.15, ebs.y# + ebs.boxes[index].y# + ymargin# )
  endif

  if ebs.boxes[index].whitespace
    SetSpritePosition( ebs.boxes[index].whitespace, ebs.x# + ebs.boxes[index].x#, ebs.y# + ebs.boxes[index].y# )
    textwidth# = GetTextTotalWidth( ebs.boxes[index].text ) + 0.2 * ebs.boxes[index].textsize#
    if ebs.boxes[index].label and 0 = len(ebs.boxes[index].text$) then textwidth# = GetTextTotalWidth( ebs.boxes[index].label ) + 0.3 * ebs.boxes[index].textsize#
    adjust# = (ebs.boxes[index].width# - textwidth#) * 0.9
    wswidth# = GetSpriteWidth( ebs.boxes[index].whitespace )-1
    if adjust# < 0 then adjust# = 0
    if adjust# > wswidth# then adjust# = wswidth#
    SetEditBoxPosition( ebs.boxes[index].id, adjust#+GetSpriteX( ebs.boxes[index].whitespace ), GetSpriteY( ebs.boxes[index].whitespace ))
  endif
  
  if ebs.boxes[index].clickable then SetSpritePositionByOffset( ebs.boxes[index].clickable, GetEditBoxX( ebs.boxes[index].id ) + 0.5 * ebs.boxes[index].width#, GetEditBoxY( ebs.boxes[index].id ) + ebs.boxes[index].textsize# * 0.59 )

endfunction



// get the x coordinate of an editbox
function EditBoxes_GetX( ebs ref as tEditBoxes, index as integer )
x# as float

  if ebs.boxes[index].whitespace
    x# = GetSpriteX( ebs.boxes[index].whitespace )
  else
    x# = ebs.x# + ebs.boxes[index].x#
  endif

endfunction x#


// get the y coordinate of an editbox
function EditBoxes_GetY( ebs ref as tEditBoxes, index as integer )
y# as float

  y# = ebs.y# + ebs.boxes[index].y#

endfunction y#


// set an editbox to be numeric, allowing only numbers. and limiting both precision and range
function EditBoxes_SetNumeric( ebs ref as tEditBoxes, index as integer, precision as integer, minvalue# as float, maxvalue# as float )
numbers as string[10] = [ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" ]

  if precision > 0 then numbers.insert( "." )
  numbers.sort()

  ebs.boxes[index].bNumeric = 1
  ebs.boxes[index].precision = precision
  ebs.boxes[index].minvalue# = minvalue#
  ebs.boxes[index].maxvalue# = maxvalue#
  ebs.boxes[index].allowed = numbers
  SetEditBoxInputType( ebs.boxes[index].id, 1 ) // numbers only

  if not ebs.boxes[index].whitespace
    sprite = CreateSprite( 0 )
    SetSpriteColor( sprite, GetColorRed( ebs.boxes[index].bkcolor ), GetColorGreen( ebs.boxes[index].bkcolor ), GetColorBlue( ebs.boxes[index].bkcolor ), GetColorAlpha( ebs.boxes[index].bkcolor ))
    SetSpriteSize( sprite, ebs.boxes[index].minwidth#, ebs.boxes[index].textsize# * 1.18 )
    SetSpritePosition( sprite, ebs.x# + ebs.boxes[index].x#, ebs.y# + ebs.boxes[index].y# )
    SetSpriteDepth( sprite, GetEditBoxDepth( ebs.boxes[index].id )+1 )
    ebs.boxes[index].whitespace = sprite
  endif

endfunction


function EditBoxes_SetFocus( ebs ref as tEditBoxes, index as integer )

  boxid = GetCurrentEditBox()
  if boxid
    SetEditBoxFocus( boxid, 0 )  // leave the current editbox
  endif

  SetEditBoxFocus( ebs.boxes[index].id, 1 )

endfunction


function EditBoxes_GetHasFocus( ebs ref as tEditBoxes, index as integer )
  if GetCurrentEditBox() = ebs.boxes[index].id then exitfunction 1
endfunction 0


function EditBoxes_GetInputFinished( ebs ref as tEditBoxes, index as integer )
//  if not EditBoxes_GetHasFocus( ebs, index ) and len( ebs.boxes[index].text$ ) then exitfunction 1
  if GetEditBoxChanged( ebs.boxes[index].id ) and len( ebs.boxes[index].text$ ) then exitfunction 1
endfunction 0


// arrow keys can't be used because the scan codes overlap with numeric keypad in html5
function EditBoxes_ConvertHtml5Keypad( ebs ref as tEditBoxes )
s$ as string = ""
index as integer = -1

  boxid = GetCurrentEditBox()
  if not boxid then exitfunction   // 0 means no edit box has focus

  for i = 0 to ebs.boxes.length
    if boxid = ebs.boxes[i].id
      index = i
      exit
    endif
  next i
  
  if -1 = index then exitfunction  // this editbox does not belong to this editboxes instance

  if GetRawKeyReleased( 110 )
    s$ = GetCharBuffer()
    if len( s$ )
      if CompareString( ".", right( s$, 1 )) then exitfunction
    endif
    s$ = "."
  elseif GetRawKeyReleased( 45 )
    s$ = "0"
  elseif GetRawKeyReleased( 187 )
    s$ = "1"
  elseif GetRawKeyReleased( 40 )
    s$ = "2"
  elseif GetRawKeyReleased( 34 )
    s$ = "3"
  elseif GetRawKeyReleased( 37 )
    s$ = "4"
  elseif GetRawKeyReleased( 12 )
    s$ = "5"
  elseif GetRawKeyReleased( 39 )
    s$ = "6"
  elseif GetRawKeyReleased( 36 )
    s$ = "7"
  elseif GetRawKeyReleased( 38 )
    s$ = "8"
  elseif GetRawKeyReleased( 33 )
    s$ = "9"
  endif

  if not len(s$) then exitfunction

pos as integer
text$ as string

  pos = GetEditBoxCursorPosition( boxid )
  text$ = GetEditBoxText( boxid )
  
  text$ = left( text$, pos ) + s$ + right( text$, len(text$)-pos )

  SetEditBoxText( boxid, text$ )
  SetEditBoxCursorPosition( boxid, pos+1 )

endfunction


// call EditBoxes_Update with mouse information
function EditBoxes_UpdateMouse( ebs ref as tEditBoxes )
  updated = EditBoxes_Update( ebs, ScreenToWorldX(GetPointerX()), ScreenToWorldY(GetPointerY()), GetPointerPressed(), GetPointerReleased(), GetPointerState() )
endfunction updated


// call EditBoxes_Update once per frame, or whenever the editboxes should be updated
function EditBoxes_Update( ebs ref as tEditBoxes, x# as float, y# as float, pressed as integer, released as integer, state as integer )
updated as integer = 0

  if 0 = ebs.bActive or 0 = ebs.bVisible
    ebs.grabfocus = -1
    exitfunction 0
  endif

  if ebs.grabfocus >= 0  // grabbing focus back for the next editbox in the list
    EditBoxes_SetFocus( ebs, ebs.grabfocus )
    ebs.grabfocus = -1
  endif

  if ebs.bFixHtmlNumlock then EditBoxes_ConvertHtml5Keypad( ebs )

  // tab or enter to the next editbox
  if GetRawKeyPressed(9) or GetRawKeyPressed(13)
    boxid = GetCurrentEditBox()
    if boxid // 0 means no edit box has focus
      for i = 0 to ebs.boxes.length
        if boxid = ebs.boxes[i].id
          SetEditBoxFocus( boxid, 0 )
          // if there's only one editbox, don't tab from it to itself
          if ebs.boxes.length > 0
            focusindex = mod( i+1, ebs.boxes.length + 1 )
            SetEditBoxFocus( ebs.boxes[focusindex].id, 1 )
            if GetRawKeyPressed(13) then ebs.grabfocus = focusindex
          endif
          exit
        endif
      next i
    else
      SetEditBoxFocus( ebs.boxes[0].id, 1 )
    endif
    updated = 1
  endif
  
text$ as string
savetext$ as string

  for i = 0 to ebs.boxes.length
    if GetEditBoxChanged( ebs.boxes[i].id ) then updated = 1
    text$ = GetEditBoxText( ebs.boxes[i].id )
    if 0 = CompareString( text$, GetTextString( ebs.boxes[i].text )) then updated = 1

    savetext$ = text$
    SetTextString( ebs.boxes[i].text, text$ )

    textwidth# = GetTextTotalWidth( ebs.boxes[i].text ) + 0.2 * ebs.boxes[i].textsize#
    if ebs.boxes[i].label and 0 = len(text$) then textwidth# = GetTextTotalWidth( ebs.boxes[i].label ) + 0.3 * ebs.boxes[i].textsize#

    if textwidth# > ebs.boxes[i].minwidth#
      boxwidth# = textwidth#
      if boxwidth# > ebs.boxes[i].maxwidth#
        boxwidth# = ebs.boxes[i].maxwidth#
        text$ = left( text$, len(text$)-1 )
        SetEditBoxText( ebs.boxes[i].id, text$ )
      endif
    else
      boxwidth# = ebs.boxes[i].minwidth#
    endif
    boxx# = ebs.x# + ebs.boxes[i].x#
    boxy# = ebs.y# + ebs.boxes[i].y#
    SetEditBoxScissor( ebs.boxes[i].id, boxx#, boxy#, boxx# + boxwidth#, boxy# + ebs.boxes[i].textsize# * 1.18 )
    SetEditBoxSize( ebs.boxes[i].id, boxwidth# + 5*ebs.boxes[i].textsize#, ebs.boxes[i].textsize# * 1.4 )
    ebs.boxes[i].width# = boxwidth#

    select ebs.boxes[i].alignment
      case EditBoxes_AlignCenter: EditBoxes_DoAlignCenter( ebs, i ) : endcase
      case EditBoxes_AlignRight: EditBoxes_DoAlignRight( ebs, i ) : endcase
    endselect

    if ebs.boxes[i].clickable  // clicking the clickable sprite focuses the textbox
      if released and GetSpriteHitTest( ebs.boxes[i].clickable, x#, y# )
        boxid = GetCurrentEditBox()
        if boxid then SetEditBoxFocus( boxid, 0 )
        SetEditBoxFocus( ebs.boxes[i].id, 1 )
      endif
    endif

    if ebs.boxes[i].bNumeric
      if ebs.boxes[i].whitespace  // clicking the whitespace focuses the textbox
        if released and GetSpriteHitTest( ebs.boxes[i].whitespace, x#, y# )
          boxid = GetCurrentEditBox()
          if boxid then SetEditBoxFocus( boxid, 0 )
          SetEditBoxFocus( ebs.boxes[i].id, 1 )
          SetEditBoxCursorPosition( ebs.boxes[i].id, 0 )
        endif
        adjust# = (boxwidth# - textwidth#) * 0.9
        wswidth# = GetSpriteWidth( ebs.boxes[i].whitespace )-1
        if adjust# < 0 then adjust# = 0
        if adjust# > wswidth# then adjust# = wswidth#
        SetEditBoxPosition( ebs.boxes[i].id, adjust#+GetSpriteX( ebs.boxes[i].whitespace ), GetSpriteY( ebs.boxes[i].whitespace ))
      endif
      if GetEditBoxChanged( ebs.boxes[i].id )
        EditBoxes_SetText( ebs, i, text$ )
      elseif len( text$ )
        pos = GetEditBoxCursorPosition( ebs.boxes[i].id )
        for j = len( text$ ) to 1 step -1
          sub$ = mid( text$, j, 1 )
          if -1 = ebs.boxes[i].allowed.find( sub$ )
            text$ = left( text$, j-1 ) + right( text$, len( text$ )-j )
            dec pos
          endif
        next j

        SetEditBoxText( ebs.boxes[i].id, text$ )
        SetEditBoxCursorPosition( ebs.boxes[i].id, pos )
      endif
    endif
    ebs.boxes[i].text$ = text$
    SetTextString( ebs.boxes[i].text, text$ )
    if ebs.boxes[i].label
      if len(text$)
        SetTextVisible( ebs.boxes[i].label, 0 )
      else
        SetTextVisible( ebs.boxes[i].label, 1 )
      endif
    endif

    if 0 = CompareString( text$, savetext$ ) then updated = 1
  next i
  
endfunction updated


// set visibility of the editboxes. invisible editboxes must not be active
function EditBoxes_SetVisible( ebs ref as tEditBoxes, bVisible as integer )

  if not bVisible then EditBoxes_SetActive( ebs, 0 )
  ebs.bVisible = bVisible

  for i = 0 to ebs.boxes.length
    if ebs.boxes[i].id then SetEditBoxVisible( ebs.boxes[i].id, bVisible )
    if ebs.boxes[i].text then SetTextVisible( ebs.boxes[i].text, bVisible )
    if ebs.boxes[i].label and (0=len(ebs.boxes[i].text$) or not bVisible) then SetTextVisible( ebs.boxes[i].label, bVisible )
    if ebs.boxes[i].whitespace then SetSpriteVisible( ebs.boxes[i].whitespace, bVisible )
  next i

endfunction


// set the editboxes to (in)active. active editboxes must be visible
function EditBoxes_SetActive( ebs ref as tEditBoxes, bActive as integer )

  if bActive then EditBoxes_SetVisible( ebs, 1 )
  ebs.bActive = bActive

endfunction


function EditBoxes_Show( ebs ref as tEditBoxes, bShow as integer )

  EditBoxes_SetVisible( ebs, bShow )
  EditBoxes_SetActive( ebs, bShow )

endfunction

