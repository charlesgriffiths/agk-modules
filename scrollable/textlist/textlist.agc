// File: textlist.agc
// Created: 22-06-08
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
// https://github.com/charlesgriffiths/agk-modules/blob/main/scrollable/textlist/textlist.agc

#constant TextList_AlignLeft 0
#constant TextList_AlignRight 1
#constant TextList_AlignCenter 2
#constant TextList_BorderTop 3
#constant TextList_BorderBottom 4
#constant TextList_BorderLeft 5
#constant TextList_BorderRight 6

type tTextListLine
  text$ as string
  alt$ as string
  display as integer
  background as integer
  align as integer
endtype


type tTextListState
  x# as float
  y# as float
  width# as float
  height# as float
  spacing# as float
  inlinespacing# as float

  mousedownx# as float
  mousedowny# as float
  mousedownmove# as float

  list as tTextListLine[]
  selected as integer[]
  textdepth as integer
  textcolor as integer
  textsize as integer
  topindex as integer
  scrolloffset# as float
  dragy# as float
  selectbackgroundcolor as integer

  bActive as integer
  bVisible as integer
  bShowLastLine as integer
  bRedisplay as integer
  bScrollingUp as integer
  bClickToSelect as integer
  bScrollWheelAnywhere as integer
  bSelectOnlyOne as integer
  bSelectedAltText as integer
  bSelectedBackground as integer
endtype



// initialize the state of a textlist instance
function TextList_Init( x# as float, y# as float, width# as float, height# as float, textsize as integer, spacing# as float )
tl as tTextListState

  tl.x# = x#
  tl.y# = y#
  tl.width# = width#
  tl.height# = height#
  tl.textcolor = MakeColor( 255, 255, 255, 255 )
  tl.textsize = textsize
  tl.spacing# = spacing#
  tl.inlinespacing# = spacing#

  tl.textdepth = 9
  tl.topindex = 0
  tl.scrolloffset# = 0
  tl.bActive = 1
  tl.bVisible = 1
  tl.bShowLastLine = 0
  tl.bRedisplay = 0
  tl.bScrollingUp = 0
  tl.bClickToSelect = 0
  tl.bScrollWheelAnywhere = 1
  tl.bSelectOnlyOne = 0
  tl.bSelectedAltText = 0
  tl.bSelectedBackground = 1

endfunction tl


// delete the textlist
function TextList_Delete( tl ref as tTextListState )

  for i = 0 to tl.list.length
    if tl.list[i].display then DeleteText( tl.list[i].display )
    if tl.list[i].background then DeleteSprite( tl.list[i].background )
  next i

  tl.list.length = -1
  tl.selected.length = -1
  tl.topindex = 0
  tl.scrolloffset# = 0
  tl.bShowLastLine = 0
  tl.bRedisplay = 1

endfunction

function TextList_SetSelectedAltText( tl ref as tTextListState, b as integer )
  tl.bSelectedAltText = b
endfunction

function TextList_SetSelectedBackground( tl ref as tTextListState, b as integer )
  tl.bSelectedBackground = b
endfunction

// get total number of text lines
function TextList_GetLineCount( tl ref as tTextListState )
endfunction tl.list.length + 1


function TextList_SetLineAlignment( tl ref as tTextListState, index as integer, align as integer )
  tl.list[index].align = align
endfunction

function TextList_SetTextColor( tl ref as tTextListState, color as integer )
  tl.textcolor = color
endfunction


// append a line of text
function TextList_AppendLine( tl ref as tTextListState, text$ as string )
  TextList_InsertLine( tl, text$, tl.list.length+1 )
endfunction

function TextList_SetAltText( tl ref as tTextListState, text$ as string, index as integer )

  tl.list[index].alt$ = text$
  tl.bRedisplay = 1

endfunction


// insert a line of text
function TextList_InsertLine( tl ref as tTextListState, text$ as string, index as integer )
line as tTextListLine

  line.text$ = text$
  line.display = 0
  line.background = 0

  if index < 0 then index = 0
  if index > tl.list.length
    tl.list.insert( line )
  else
    tl.list.insert( line, index )
    for i = 0 to tl.selected.length
      if index <= tl.selected[i] then tl.selected[i] = tl.selected[i] + 1
    next i
  endif
  if tl.topindex >= index and tl.topindex < tl.list.length then tl.topindex = tl.topindex + 1
  tl.bRedisplay = 1

endfunction


function TextList_RemoveAllLines( tl ref as tTextListState )

  while tl.list.length > -1
    TextList_RemoveLine( tl, 0 )
  endwhile

endfunction


// remove a line of text
function TextList_RemoveLine( tl ref as tTextListState, index as integer )

  if index >= 0 and index <= tl.list.length
    if tl.list[index].display then DeleteText( tl.list[index].display )
    if tl.list[index].background then DeleteSprite( tl.list[index].background )
    tl.list.remove( index )
    tl.bRedisplay = 1
    if tl.topindex > 0 and tl.topindex >= index then tl.topindex = tl.topindex - 1
    for i = tl.selected.length to 0 step -1
      if index = tl.selected[i]
        tl.selected.remove( i )
      elseif index < tl.selected[i]
        tl.selected[i] = tl.selected[i] - 1
      endif
    next i
  endif

endfunction


function TextList_GetFirstSelectedIndex( tl ref as tTextListState )
index as integer = -1

  if tl.selected.length >= 0 then index = tl.selected[0]

endfunction index

function TextList_GetFirstSelectedText( tl ref as tTextListState )
text$ as string = ""

  if tl.selected.length >= 0
    if tl.bSelectedAltText
      text$ = tl.list[tl.selected[0]].alt$
    else
      text$ = tl.list[tl.selected[0]].text$
    endif
  endif

endfunction text$


function TextList_GetText( tl ref as tTextListState, index as integer )
text$ as string

  text$ = tl.list[index].text$

endfunction text$


// modify the text in a line
function TextList_ModifyItem( tl ref as tTextListState, index as integer, text$ as string )

  tl.list[index].text$ = text$
  if tl.list[index].display then DeleteText( tl.list[index].display )
  tl.list[index].display = 0
  tl.bRedisplay = 1

endfunction


function TextList_IsFirstLineAllVisible( tl ref as tTextListState )
shown as integer = 0

  if tl.list[0].display
    shown = GetTextY( tl.list[0].display ) >= tl.y#
  endif

endfunction shown

function TextList_IsLastLineAllVisible( tl ref as tTextListState )
shown as integer = 0

  last = tl.list.length
  if tl.list[last].display
    shown = GetTextY( tl.list[last].display ) + GetTextTotalHeight( tl.list[last].display ) <= tl.y# + tl.height#
  endif

endfunction shown


// call TextList_Update with mouse information
function TextList_UpdateMouse( tl ref as tTextListState )
  updated = TextList_Update( tl, ScreenToWorldX(GetPointerX()), ScreenToWorldY(GetPointerY()), GetPointerPressed(), GetPointerReleased(), GetPointerState() )
endfunction updated


// call TextList_Update once per frame, or whenever the textlist should be updated
function TextList_Update( tl ref as tTextListState, x# as float, y# as float, pressed as integer, released as integer, state as integer )
updated as integer = 0
savedtopindex as integer
savedscrolloffset# as float

  savedtopindex = tl.topindex
  savedscrolloffset# = tl.scrolloffset#

  // if the pointer is in bounds
  if tl.bActive and x# >= tl.x# and y# >= tl.y# and x# <= tl.x# + tl.width# and y# <= tl.y# + tl.height#
    if pressed > 0
      tl.dragy# = y#
      tl.mousedownx# = x#
      tl.mousedowny# = y#
      tl.mousedownmove# = 0
    elseif state > 0 and y# <> tl.dragy# and tl.dragy# >= tl.y#
      if y# > tl.dragy#
        tl.bScrollingUp = 1
        tl.bShowLastLine = 0
      else
        tl.bScrollingUp = 0
      endif

      if 0 = tl.bShowLastLine then tl.scrolloffset# = tl.scrolloffset# + tl.dragy# - y#
      tl.dragy# = y#
      tl.bRedisplay = 1
      
      tl.mousedownmove# = tl.mousedownmove# + Abs( x# - tl.mousedownx# ) + Abs( y# - tl.mousedowny# )
    elseif released > 0 and tl.mousedownmove# < tl.textsize
    // click
      if tl.bClickToSelect <> 0
        for i = tl.topindex to tl.list.length
          if tl.list[i].display > 0
            if GetTextHitTest( tl.list[i].display, 1+tl.x#, y# ) or GetTextHitTest( tl.list[i].display, x#, y# )
              updated = 1
              if TextList_GetSelected( tl, i )
                TextList_ClearSelected( tl, i )
              else
                TextList_SetSelected( tl, i )
              endif
            endif
          endif
        next i
      endif
    endif
  endif
  
  if state = 0
    tl.dragy# = tl.y# - 1
  endif

  if tl.bActive
    if tl.bScrollWheelAnywhere <> 0 or (x# >= tl.x# and y# >= tl.y# and x# <= tl.x# + tl.width# and y# <= tl.y# + tl.height#)
      if GetRawMouseWheelDelta() > 0
      // scroll up
        if tl.topindex > 0 then tl.topindex = tl.topindex - 1
        tl.scrolloffset# = 0
        tl.bShowLastLine = 0
        tl.bRedisplay = 1
        tl.bScrollingUp = 1
      elseif GetRawMouseWheelDelta() < 0
      // scroll down
        if tl.topindex < tl.list.length and tl.bShowLastLine = 0 then tl.topindex = tl.topindex + 1
        tl.scrolloffset# = 0
        tl.bRedisplay = 1
        tl.bScrollingUp = 0
      endif
    endif
  endif

// display text
  if tl.bVisible and tl.bRedisplay > 0 and tl.topindex >= 0 and tl.topindex <= tl.list.length
  ypos# as float

    tl.bRedisplay = 0

    if tl.scrolloffset# < 0
      if tl.topindex > 0
        tl.topindex = tl.topindex - 1
        TextList_SetDisplayLine( tl, tl.topindex )
        tl.scrolloffset# = tl.scrolloffset# + GetTextTotalHeight( tl.list[tl.topindex].display ) + tl.spacing#
      else
        tl.scrolloffset# = 0
      endif
    endif

    ypos# = tl.y# - tl.scrolloffset#

    for i = 0 to tl.list.length
      if i >= tl.topindex and ypos# < tl.y# + tl.height#
        TextList_SetDisplayLine( tl, i )
        select tl.list[i].align
          case TextList_AlignLeft:
            SetTextPosition( tl.list[i].display, tl.x#, ypos# )
          endcase
          case TextList_AlignRight:
            textwidth# = GetTextTotalWidth( tl.list[i].display )
            SetTextPosition( tl.list[i].display, tl.x# + tl.width# - textwidth#, ypos# )
          endcase
          case TextList_AlignCenter:
            textwidth# = GetTextTotalWidth( tl.list[i].display )
            SetTextPosition( tl.list[i].display, tl.x# + 0.5 * (tl.width# - textwidth#), ypos# )
          endcase
        endselect
        SetTextColor( tl.list[i].display, GetColorRed( tl.textcolor ), GetColorGreen( tl.textcolor ), GetColorBlue( tl.textcolor ), GetColorAlpha( tl.textcolor ))
        if tl.list[i].background > 0
          SetSpritePosition( tl.list[i].background, tl.x#, ypos# )
          SetSpriteVisible( tl.list[i].background, 1 )
          SetSpriteSize( tl.list[i].background, tl.width#, GetTextTotalHeight( tl.list[i].display ))
        endif
        ypos# = ypos# + GetTextTotalHeight( tl.list[i].display ) + tl.spacing#

        // if this is the last line and there is no scrolloffset and we are not scrolling up,
        //   set scrolloffset and show all of the last line
        if i = tl.list.length and 0 = tl.scrolloffset# and 0 = tl.bScrollingUp
          tl.scrolloffset# = ypos# - (tl.y# + tl.height#) - tl.spacing#
          if 0 = tl.scrolloffset# then tl.scrolloffset# = 0.001
          tl.bShowLastLine = 1
          tl.bRedisplay = 1
        endif
      else
        // if we are outside the window but this display is not 0, set display to 0
        if tl.list[i].display > 0
          DeleteText( tl.list[i].display )
          tl.list[i].display = 0
        endif

        if tl.list[i].background > 0
          SetSpriteVisible( tl.list[i].background, 0 )
        endif

        // if we are supposed to show last line but this display is 0, scroll down
        if tl.bShowLastLine > 0 and i >= tl.topindex
          tl.topindex = tl.topindex + 1
          tl.bRedisplay = 1
        endif
      endif
    next i

    // if we are not scrolling up and topindex was displayed outside the window, scroll down
    if 0 = tl.bScrollingUp and tl.list[tl.topindex].display > 0 and tl.scrolloffset# > GetTextTotalHeight( tl.list[tl.topindex].display ) + tl.spacing#
      tl.scrolloffset# = tl.scrolloffset# - (GetTextTotalHeight( tl.list[tl.topindex].display ) + tl.spacing#)
      tl.topindex = tl.topindex + 1
      tl.bRedisplay = 1
    endif

    // if there is empty space at the bottom of the window, trim scrolloffset and maybe scroll up
    if ypos# < tl.y# + tl.height# and tl.scrolloffset# > 0.001
      emptyspace# = tl.y# + tl.height# - ypos# + tl.spacing#
      if emptyspace# >= tl.scrolloffset#
        if tl.topindex > 0
          tl.topindex = tl.topindex - 1
          TextList_SetDisplayLine( tl, tl.topindex )
          tl.scrolloffset# = tl.scrolloffset# - emptyspace# + GetTextTotalHeight( tl.list[tl.topindex].display ) + tl.spacing#
        else
          tl.scrolloffset# = 0.001
        endif
      else
        tl.scrolloffset# = tl.scrolloffset# - emptyspace#
      endif
      tl.bRedisplay = 1
      tl.bShowLastLine = 1
    endif
  endif

endfunction updated or savedscrolloffset# <> tl.scrolloffset# or savedtopindex <> tl.topindex


// internal. make a text line ready to display
function TextList_SetDisplayLine( tl ref as tTextListState, line as integer )

  if 0 = tl.list[line].display
    if tl.bSelectedAltText and TextList_GetSelected( tl, line )
      tl.list[line].display = CreateText( tl.list[line].alt$ )
    else
      tl.list[line].display = CreateText( tl.list[line].text$ )
    endif

    SetTextDepth( tl.list[line].display, tl.textdepth )
    SetTextSize( tl.list[line].display, tl.textsize )
    SetTextScissor( tl.list[line].display, tl.x#, tl.y#, tl.x# + tl.width#, tl.y# + tl.height# )
    SetTextMaxWidth( tl.list[line].display, tl.width# )
    SetTextLineSpacing( tl.list[line].display, tl.inlinespacing# )
  endif

endfunction

// internal. make a text line ready to display
function TextList_ResetDisplayLine( tl ref as tTextListState, line as integer )

  if tl.list[line].display then DeleteText( tl.list[line].display )

  if tl.bSelectedAltText and TextList_GetSelected( tl, line )
    tl.list[line].display = CreateText( tl.list[line].alt$ )
  else
    tl.list[line].display = CreateText( tl.list[line].text$ )
  endif

  SetTextDepth( tl.list[line].display, tl.textdepth )
  SetTextSize( tl.list[line].display, tl.textsize )
  SetTextScissor( tl.list[line].display, tl.x#, tl.y#, tl.x# + tl.width#, tl.y# + tl.height# )
  SetTextMaxWidth( tl.list[line].display, tl.width# )
  SetTextLineSpacing( tl.list[line].display, tl.inlinespacing# )

endfunction


// set the background color that identifies selected items
function TextList_SetSelectedBackgroundColor( tl ref as tTextListState, color as integer )
  tl.selectbackgroundcolor = color
endfunction


// set one item to selected
function TextList_SetSelected( tl ref as tTextListState, index as integer )
sprite as integer

  if index >= 0 and index <= tl.list.length
    if tl.bSelectOnlyOne then TextList_ClearAllSelected( tl )

    if tl.bSelectedBackground
      sprite = CreateSprite( 0 )
      SetSpriteColor( sprite, GetColorRed( tl.selectbackgroundcolor ), GetColorGreen( tl.selectbackgroundcolor ), GetColorBlue( tl.selectbackgroundcolor ), GetColorAlpha( tl.selectbackgroundcolor ) )
      SetSpriteSize( sprite, tl.width#, GetTextTotalHeight( tl.list[index].display ))
      SetSpritePosition( sprite, tl.x#, GetTextY( tl.list[index].display ))
      SetSpriteScissor( sprite, tl.x#, tl.y#, tl.x# + tl.width#, tl.y# + tl.height# )
      tl.list[index].background = sprite
    endif

    tl.selected.insert( index )
    TextList_ResetDisplayLine( tl, index )
  endif
  
  tl.bRedisplay = 1

endfunction


// set one item to unselected
function TextList_ClearSelected( tl ref as tTextListState, index as integer )

  if index >= 0 and index <= tl.list.length
    if tl.list[index].background then DeleteSprite( tl.list[index].background )
    tl.list[index].background = 0

    for i = tl.selected.length to 0 step -1
      if index = tl.selected[i] then tl.selected.remove( i )
    next i
    TextList_ResetDisplayLine( tl, index )
  endif
  tl.bRedisplay = 1

endfunction


// set all items to unselected
function TextList_ClearAllSelected( tl ref as tTextListState )

  for i = 0 to tl.selected.length
    TextList_ClearSelected( tl, tl.selected[i] )
  next i
  tl.selected.length = -1

endfunction


// return selected state of an item
function TextList_GetSelected( tl ref as tTextListState, index as integer )
ret as integer = 0

  if index >= 0 and index <= tl.list.length
//   then ret = tl.list[index].background > 0
    for i = 0 to tl.selected.length
      if index = tl.selected[i] then exitfunction 1
    next i
  endif

endfunction ret


// restrict selection count to a maximum of one
function TextList_SetSelectOnlyOne( tl ref as tTextListState, bValue as integer )

  tl.bSelectOnlyOne = bValue

  if bValue
    if tl.selected.length > 0
      for i = 0 to tl.list.length
        if i <> tl.selected[0] then TextList_ClearSelected( tl, i )
      next i
      tl.selected.length = 0
    endif
    tl.bSelectOnlyOne = 1
  endif

endfunction


// allow items to be selected with a touch/mouseclick
function TextList_SetClickToSelect( tl ref as tTextListState, bClickToSelect as integer )
  tl.bClickToSelect = bClickToSelect
endfunction


// set the text display depth
function TextList_SetDepth( tl ref as tTextListState, depth as integer )

  tl.textdepth = depth
  for i = 0 to tl.list.length
    if tl.list[i].display then SetTextDepth( tl.list[i].display, depth )
    if tl.list[i].background then SetSpriteDepth( tl.list[i].background, depth+1 )
  next i

endfunction


// set the size of text characters
function TextList_SetSize( tl ref as tTextListState, size as integer )

  tl.textsize = size
  for i = 0 to tl.list.length
    if tl.list[i].display then SetTextSize( tl.list[i].display, tl.textsize )
  next i
  tl.bRedisplay = 1

endfunction


// set the spacing between text lines
function TextList_SetSpacing( tl ref as tTextListState, spacing# as float )

  tl.spacing# = spacing#
  for i = 0 to tl.list.length
    if tl.list[i].display then SetTextLineSpacing( tl.list[i].display, tl.spacing# )
  next i
  tl.bRedisplay = 1

endfunction


// set mouse bounds for scroll wheel to anywhere or within list only
function TextList_SetScrollWheelAnywhere( tl ref as tTextListState, bScrollWheelAnywhere as integer )
  tl.bScrollWheelAnywhere = bScrollWheelAnywhere
endfunction


// set textlist to visible or invisible
function TextList_SetVisible( tl ref as tTextListState, bVisible as integer )

  tl.bVisible = bVisible
  tl.bRedisplay = bVisible
  TextList_SetActive( tl, bVisible )

  if 0 = bVisible
    for i = 0 to tl.list.length
      if tl.list[i].display then DeleteText( tl.list[i].display )
      tl.list[i].display = 0

      if tl.list[i].background then SetSpriteVisible( tl.list[i].background, 0 )
    next i
  endif

endfunction


// enable/disable the textlist
function TextList_SetActive( tl ref as tTextListState, bActive as integer )
  tl.bActive = bActive
endfunction


function TextList_Show( tl ref as tTextListState, bShow as integer )

  TextList_SetActive( tl, bShow )
  TextList_SetVisible( tl, bShow )

endfunction


function TextList_DrawBorder( tl ref as tTextListState, color as integer, fraction# as float, side as integer )

  select side
    case TextList_BorderTop:
      width# = tl.width# * fraction#
      x# = tl.x# + 0.5 * (tl.width# - width#)
      DrawLine( x#, tl.y#-1, x# + width#, tl.y#-1, color, color )
    endcase

    case TextList_BorderBottom:
      width# = tl.width# * fraction#
      x# = tl.x# + 0.5 * (tl.width# - width#)
      y# = tl.y# + tl.height# + 1
      DrawLine( x#, y#, x# + width#, y#, color, color )
    endcase

    case TextList_BorderLeft:
      height# = tl.height# * fraction#
      y# = tl.y# + 0.5 * (tl.height# - height#)
      DrawLine( tl.x#, y#, tl.x#, y# + height#, color, color )
    endcase

    case TextList_BorderRight:
      height# = tl.height# * fraction#
      y# = tl.y# + 0.5 * (tl.height# - height#)
      x# = tl.x# + tl.width#
      DrawLine( x#, y#, x#, y# + height#, color, color )
    endcase
  endselect

endfunction


// draw a box around the text area
function TextList_DrawBox( tl ref as tTextListState, color as integer )
  DrawBox( tl.x#, tl.y#, tl.x#+tl.width#, tl.y#+tl.height#, color, color, color, color, 0 )
endfunction

