// File: mapdisplay.agc
// Created: 22-06-25
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
// https://github.com/charlesgriffiths/agk-modules/blob/main/scrollable/mapdisplay/mapdisplay.agc


type tMapItem
  x# as float
  y# as float
  sprite as integer
  selectbackground as integer
  spriteunselected as integer
endtype

type tMapViewport
  x# as float
  y# as float
  width# as float
  height# as float
  
  screenx# as float
  screeny# as float
  screenwidth# as float
  screenheight# as float

  scale# as float
endtype

type tMapDisplay
  x# as float
  y# as float
  width# as float
  height# as float
  viewport as tMapViewport
  items as tMapItem[]

  savemousex# as float
  savemousey# as float
  dragx# as float
  dragy# as float
  mousedownx# as float
  mousedowny# as float
  mousedownmove# as float

  selected as integer[]
  selectcolor as integer
  selectboxcolor as integer
  bSelectedColorMode as integer

  bClickToSelect as integer
  bActive as integer
  bVisible as integer
  bSelectOnlyOne as integer
  bDragScrollMode as integer
  bDragSelectMode as integer
  bDragUnselectMode as integer
  bIsDragDrawingBox as integer   // is the mouse being dragged to draw a select/unselect box right now
endtype


// initialize a mapdisplay instance
function MapDisplay_Init( x# as float, y# as float, width# as float, height# as float )
md as tMapDisplay

  md.x# = x#
  md.y# = y#
  md.width# = width#
  md.height# = height#
  md.selectboxcolor = MakeColor( 0, 255, 255, 255 )

  md.bClickToSelect = 1
  md.bActive = 1
  md.bVisible = 1
  md.bDragScrollMode = 1

endfunction md


function MapDisplay_Delete( md ref as tMapDisplay )

  for i = 0 to md.items.length
    if md.items[i].sprite then DeleteSprite( md.items[i].sprite )
    if md.items[i].spriteunselected then DeleteSprite( md.items[i].spriteunselected )
    if md.items[i].selectbackground then DeleteSprite( md.items[i].selectbackground )
  next i
  md.items.length = -1

endfunction


function MapDisplay_SetSelectColorMode( md ref as tMapDisplay, bMode as integer, color as integer )

  md.bSelectedColorMode = bMode
  md.selectcolor = color

endfunction


function MapDisplay_SetDragScrollMode( md ref as tMapDisplay, bMode as integer )

  md.bDragScrollMode = bMode
  if bMode
    md.bDragSelectMode = 0
    md.bDragUnselectMode = 0
  endif

endfunction

function MapDisplay_SetDragSelectMode( md ref as tMapDisplay, bMode as integer )

  md.bDragSelectMode = bMode
  if bMode
    md.bDragScrollMode = 0
    md.bDragUnselectMode = 0
  endif

endfunction

function MapDisplay_SetDragUnselectMode( md ref as tMapDisplay, bMode as integer )

  md.bDragUnselectMode = bMode
  if bMode
    md.bDragSelectMode = 0
    md.bDragScrollMode = 0
  endif

endfunction


// add an item to the mapdisplay
function MapDisplay_AddItem( md ref as tMapDisplay, x# as float, y# as float, sprite as integer )
mi as tMapItem

  mi.x# = x#
  mi.y# = y#
  mi.sprite = CloneSprite( sprite )
  mi.spriteunselected = CloneSprite( sprite )
  SetSpriteVisible( mi.spriteunselected, 0 )

  md.items.insert( mi )

endfunction

function MapDisplay_AddItemB( md ref as tMapDisplay, x# as float, y# as float, sprite as integer, selectbackground as integer )
mi as tMapItem

  mi.x# = x#
  mi.y# = y#
  mi.sprite = CloneSprite( sprite )
  mi.spriteunselected = CloneSprite( sprite )
  SetSpriteVisible( mi.spriteunselected, 0 )
  mi.selectbackground = CloneSprite( selectbackground )
  SetSpriteVisible( mi.selectbackground, 0 )

  md.items.insert( mi )

endfunction


function MapDisplay_Reposition( md ref as tMapDisplay )
scissorx# as float
scissory# as float
scissorx2# as float
scissory2# as float

  scissorx# = md.viewport.screenx#
  scissory# = md.viewport.screeny#
  scissorx2# = md.viewport.screenx# + md.viewport.screenwidth#
  scissory2# = md.viewport.screeny# + md.viewport.screenheight#

  for i = 0 to md.items.length
    if md.bSelectedColorMode
      if MapDisplay_GetSelected( md, i )
        SetSpriteColor( md.items[i].sprite, GetColorRed( md.selectcolor ), GetColorGreen( md.selectcolor ), GetColorBlue( md.selectcolor ), GetColorAlpha( md.selectcolor ))
      else
        if md.items[i].sprite then DeleteSprite( md.items[i].sprite )
        md.items[i].sprite = CloneSprite( md.items[i].spriteunselected )
      endif
    else
      if md.items[i].sprite then DeleteSprite( md.items[i].sprite )
      md.items[i].sprite = CloneSprite( md.items[i].spriteunselected )
    endif

    SetSpriteScale( md.items[i].sprite, md.viewport.scale#, md.viewport.scale# )
    SetSpritePositionByOffset( md.items[i].sprite, MapDisplay_MapToScreenCoordinateX( md.items[i].x#, md.viewport ), MapDisplay_MapToScreenCoordinateY( md.items[i].y#, md.viewport ))
    SetSpriteScissor( md.items[i].sprite, scissorx#, scissory#, scissorx2#, scissory2# )

    if MapDisplay_GetSelected( md, i )
      if md.items[i].selectbackground
        SetSpriteScale( md.items[i].selectbackground, md.viewport.scale#, md.viewport.scale# )
        SetSpritePositionByOffset( md.items[i].selectbackground, MapDisplay_MapToScreenCoordinateX( md.items[i].x#, md.viewport ), MapDisplay_MapToScreenCoordinateY( md.items[i].y#, md.viewport ))
        SetSpriteScissor( md.items[i].selectbackground, scissorx#, scissory#, scissorx2#, scissory2# )
        SetSpriteVisible( md.items[i].selectbackground, 1 )
      endif
    else
      if md.items[i].selectbackground then SetSpriteVisible( md.items[i].selectbackground, 0 )
    endif
    SetSpriteVisible( md.items[i].sprite, md.bVisible )
  next i

endfunction


function MapDisplay_MapToScreenCoordinateX( x# as float, v ref as tMapViewport )
screenx# as float

  screenx# = v.screenx# + v.screenwidth# * (x# - v.x#) / v.width#

endfunction screenx#

function MapDisplay_MapToScreenCoordinateY( y# as float, v ref as tMapViewport )
screeny# as float

  screeny# = v.screeny# + v.screenheight# * (y# - v.y#) / v.height#

endfunction screeny#



function MapDisplay_SetViewportPosition( md ref as tMapDisplay, x# as float, y# as float )

  if x# < md.x# - md.viewport.width#/2 then x# = md.x# - md.viewport.width#/2
  if y# < md.y# - md.viewport.height#/2 then y# = md.y# - md.viewport.height#/2

  if x# > md.x# + md.width# - md.viewport.width#/2 then x# = md.x# + md.width# - md.viewport.width#/2
  if y# > md.y# + md.height# - md.viewport.height#/2 then y# = md.y# + md.height# - md.viewport.height#/2

  md.viewport.x# = x#
  md.viewport.y# = y#

endfunction


function MapDisplay_SetViewportScreenPosition( md ref as tMapDisplay, x# as float, y# as float, width# as float, height# as float )

  md.viewport.screenx# = x#
  md.viewport.screeny# = y#
  md.viewport.screenwidth# = width#
  md.viewport.screenheight# = height#

endfunction


function MapDisplay_SetViewportPositionFraction( md ref as tMapDisplay, x# as float, y# as float )

  xrange# = md.width# - md.viewport.width#
  yrange# = md.height# - md.viewport.height#
  
  MapDisplay_SetViewportPosition( md, md.x# + x# * xrange#, md.y# + y# * yrange# )

endfunction


function MapDisplay_SetViewportCenter( md ref as tMapDisplay, x# as float, y# as float )
  MapDisplay_SetViewportPosition( md, x# - md.viewport.width#/2, y# - md.viewport.height#/2 )
endfunction


function MapDisplay_SetViewportSize( md ref as tMapDisplay, width# as float, height# as float )

  md.viewport.width# = width#
  md.viewport.height# = height#

  md.viewport.scale# = sqrt( (md.width# * md.height#) / (width# * height#))

endfunction


function MapDisplay_GetViewportXFraction( md ref as tMapDisplay )
  fraction# = (md.viewport.x# - md.x#) / (md.width# - md.viewport.width#)
endfunction fraction#

function MapDisplay_GetViewportYFraction( md ref as tMapDisplay )
  fraction# = (md.viewport.y# - md.y#) / (md.height# - md.viewport.height#)
endfunction fraction#


function MapDisplay_GetSelected( md ref as tMapDisplay, index as integer )

  for i = 0 to md.selected.length
    if index = md.selected[i] then exitfunction 1
  next i

endfunction 0


function MapDisplay_SetSelected( md ref as tMapDisplay, index as integer )

  if md.bSelectOnlyOne then MapDisplay_ClearAllSelected( md )
  for i = 0 to md.selected.length
    if index = md.selected[i] then exitfunction
  next i

  md.selected.insert( index )

endfunction


function MapDisplay_SetSelectedBox( md ref as tMapDisplay, x# as float, y# as float, x2# as float, y2# as float )

  if x# > x2#
    tmp# = x#
    x# = x2#
    x2# = tmp#
  endif
  
  if y# > y2#
    tmp# = y#
    y# = y2#
    y2# = tmp#
  endif
  
  for i = 0 to md.items.length
    if GetSpriteVisible( md.items[i].sprite )
      sx# = GetSpriteX( md.items[i].sprite )
      if sx# >= x# and sx# <= x2#
        sy# = GetSpriteY( md.items[i].sprite )
        if sy# >= y# and sy# <= y2# then MapDisplay_SetSelected( md, i )
      endif
    endif
  next i

endfunction


function MapDisplay_ClearSelectedBox( md ref as tMapDisplay, x# as float, y# as float, x2# as float, y2# as float )

  if x# > x2#
    tmp# = x#
    x# = x2#
    x2# = tmp#
  endif
  
  if y# > y2#
    tmp# = y#
    y# = y2#
    y2# = tmp#
  endif
  
  for i = 0 to md.items.length
    if GetSpriteVisible( md.items[i].sprite )
      sx# = GetSpriteX( md.items[i].sprite )
      if sx# >= x# and sx# <= x2#
        sy# = GetSpriteY( md.items[i].sprite )
        if sy# >= y# and sy# <= y2# then MapDisplay_ClearSelected( md, i )
      endif
    endif
  next i

endfunction


function MapDisplay_ClearSelected( md ref as tMapDisplay, index as integer )

  for i = md.selected.length to 0 step -1
    if index = md.selected[i] then md.selected.remove( i )
  next i

endfunction


function MapDisplay_ClearAllSelected( md ref as tMapDisplay )

  for i = 0 to md.items.length
    MapDisplay_ClearSelected( md, i )
  next i

endfunction


// restrict selection count to a maximum of one
function MapDisplay_SetSelectOnlyOne( md ref as tMapDisplay, bValue as integer )

  md.bSelectOnlyOne = bValue

  if bValue
    if md.selected.length > 0
      for i = 0 to md.items.length
        if i <> md.selected[0] then MapDisplay_ClearSelected( md, i )
      next i
      md.selected.length = 0
    endif
    md.bSelectOnlyOne = 1
  endif

endfunction


function MapDisplay_GetHoverIndex( md ref as tMapDisplay )

  for i = 0 to md.items.length
    if GetSpriteVisible( md.items[i].sprite )
      if GetSpriteHitTest( md.items[i].sprite, md.savemousex#, md.savemousey# )
        exitfunction i
      endif
    endif
  next i

endfunction -1

function MapDisplay_GetHoverIndexB( md ref as tMapDisplay )

  for i = 0 to md.items.length
    if md.items[i].selectbackground
      if GetSpriteVisible( md.items[i].selectbackground )
        if GetSpriteHitTest( md.items[i].selectbackground, md.savemousex#, md.savemousey# )
          exitfunction i
        endif
      endif
    endif
  next i

endfunction -1


function MapDisplay_GetIsDragSelecting( md ref as tMapDisplay )
endfunction md.bIsDragDrawingBox


// call MapDisplay_Update with mouse information
function MapDisplay_UpdateMouse( md ref as tMapDisplay )
  updated = MapDisplay_Update( md, ScreenToWorldX(GetPointerX()), ScreenToWorldY(GetPointerY()), GetPointerPressed(), GetPointerReleased(), GetPointerState() )
endfunction updated


// call MapDisplay_Update once per frame, or whenever the mapdisplay should be updated
function MapDisplay_Update( md ref as tMapDisplay, x# as float, y# as float, pressed as integer, released as integer, state as integer )
updated as integer = 0

  md.bIsDragDrawingBox = 0

  if md.bActive
    md.savemousex# = x#
    md.savemousey# = y#
  endif

  // if the pointer is in bounds
  if md.bActive and x# >= md.viewport.screenx# and y# >= md.viewport.screeny# and x# <= md.viewport.screenx# + md.viewport.screenwidth# and y# <= md.viewport.screeny# + md.viewport.screenheight#
    if pressed
      md.dragx# = x#
      md.dragy# = y#
      md.mousedownx# = x#
      md.mousedowny# = y#
      md.mousedownmove# = 0
    elseif state and (y# <> md.dragy# or x# <> md.dragx#) and md.dragy# >= md.viewport.screeny#
    // drag
      updated = 1

      if md.bDragScrollMode
        MapDisplay_SetViewportPosition( md, md.viewport.x# + (md.dragx# - x#)/md.viewport.screenwidth# * md.viewport.width#, md.viewport.y# + (md.dragy# - y#)/md.viewport.screenheight# * md.viewport.height# )
        md.dragx# = x#
        md.dragy# = y#
      elseif md.bDragSelectMode
        color = md.selectboxcolor
        DrawBox( x#, y#, md.dragx#, md.dragy#, color, color, color, color, 0 )
        md.bIsDragDrawingBox = 1
      elseif md.bDragUnselectMode
        color = md.selectboxcolor
        DrawBox( x#, y#, md.dragx#, md.dragy#, color, color, color, color, 0 )
        md.bIsDragDrawingBox = 1
      endif

      md.mousedownmove# = md.mousedownmove# + Abs( x# - md.mousedownx# ) + Abs( y# - md.mousedowny# )
    elseif released
      if md.mousedownmove# < 50
      // click
        if md.bClickToSelect
          for i = 0 to md.items.length
            if GetSpriteVisible( md.items[i].sprite )
              if GetSpriteHitTest( md.items[i].sprite, x#, y# )
                updated = 1
                if MapDisplay_GetSelected( md, i )
                  MapDisplay_ClearSelected( md, i )
                else
                  MapDisplay_SetSelected( md, i )
                endif
              endif
            endif
          next i
        endif
      else
        if md.bDragSelectMode
          MapDisplay_SetSelectedBox( md, x#, y#, md.dragx#, md.dragy# )
          updated = 1
        elseif md.bDragUnselectMode
          MapDisplay_ClearSelectedBox( md, x#, y#, md.dragx#, md.dragy# )
          updated = 1
        endif
      endif
    endif
  endif

  if 0 = state
    md.dragy# = md.viewport.screeny# - 1
  endif

endfunction updated


function MapDisplay_SetVisible( md ref as tMapDisplay, bVisible as integer )

  if not bVisible then MapDisplay_SetActive( md, 0 )

  md.bVisible = bVisible
  MapDisplay_Reposition( md )

endfunction


function MapDisplay_SetActive( md ref as tMapDisplay, bActive as integer )

  if bActive then MapDisplay_SetVisible( md, 1 )
  md.bActive = bActive

endfunction


function MapDisplay_Show( md ref as tMapDisplay, bShow as integer )

  MapDisplay_SetActive( md, bShow )
  MapDisplay_SetVisible( md, bShow )

endfunction


function MapDisplay_DrawViewportBox( md ref as tMapDisplay, color as integer )
  if md.bActive then DrawBox( md.viewport.screenx#, md.viewport.screeny#, md.viewport.screenx#+md.viewport.screenwidth#, md.viewport.screeny#+md.viewport.screenheight#, color, color, color, color, 0 )
endfunction

