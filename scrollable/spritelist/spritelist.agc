// File: spritelist.agc
// Created: 22-06-15
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


type tSpriteListState
  x# as float
  y# as float
  width# as float
  height# as float
  spacing# as float

  mousedownx# as float
  mousedowny# as float
  mousedownmove# as float

  list as integer[]
  selected as integer[]
  depth as integer
  topindex as integer
  scrolloffset# as float
  dragy# as float

  bActive as integer
  bVisible as integer
  bShowLastSprite as integer
  bRedisplay as integer
  bScrollingUp as integer
  bClickToSelect as integer
  bScrollWheelAnywhere as integer
endtype



// initialize the state of a spritelist instance
function SpriteList_Init( x# as float, y# as float, width# as float, height# as float, spacing# as float )
sl as tSpriteListState

  sl.x# = x#
  sl.y# = y#
  sl.width# = width#
  sl.height# = height#
  sl.spacing# = spacing#

  sl.depth = 10
  sl.topindex = 0
  sl.scrolloffset# = 0
  sl.bActive = 1
  sl.bVisible = 1
  sl.bShowLastSprite = 0
  sl.bRedisplay = 0
  sl.bScrollingUp = 0
  sl.bClickToSelect = 0
  sl.bScrollWheelAnywhere = 0

endfunction sl


// delete the spritelist
function SpriteList_Delete( sl ref as tSpriteListState )

  for i = 0 to sl.list.length
    if sl.list[i] <> 0 then DeleteSprite( sl.list[i] )
  next i
  sl.list.length = -1
  sl.selected.length = -1
  sl.topindex = 0
  sl.scrolloffset# = 0
  sl.bShowLastSprite = 0
  sl.bRedisplay = 1

endfunction


// get total number of sprites
function SpriteList_GetSpriteCount( sl ref as tSpriteListState )
endfunction sl.list.length + 1


// append a sprite
function SpriteList_AppendSprite( sl ref as tSpriteListState, sprite as integer )
  SpriteList_InsertSprite( sl, sprite, sl.list.length+1 )
endfunction


// insert a sprite
function SpriteList_InsertSprite( sl ref as tSpriteListState, sprite as integer, index as integer )

  if index < 0 then index = 0
  sprite = CloneSprite( sprite )
  if index > sl.list.length
    sl.list.insert( sprite )
  else
    sl.list.insert( sprite, index )
    for i = 0 to sl.selected.length
      if index <= sl.selected[i] then sl.selected[i] = sl.selected[i] + 1
    next i
  endif
  if sl.topindex >= index and sl.topindex < sl.list.length then sl.topindex = sl.topindex + 1
  sl.bRedisplay = 1

endfunction


// remove a sprite
function SpriteList_RemoveSprite( sl ref as tSpriteListState, index as integer )

  if index >= 0 and index <= sl.list.length
    if sl.list[index] > 0 then DeleteSprite( sl.list[index] )
    sl.list.remove( index )
    sl.bRedisplay = 1
    if sl.topindex > 0 and sl.topindex >= index then sl.topindex = sl.topindex - 1
    for i = sl.selected.length to 0 step -1
      if index = sl.selected[i]
        sl.selected.remove( i )
      elseif index < sl.selected[i]
        sl.selected[i] = sl.selected[i] - 1
      endif
    next i
  endif

endfunction


// modify a sprite
function SpriteList_ModifyItem( sl ref as tSpriteListState, index as integer, sprite as integer )

  if sl.list[index] <> 0 then DeleteSprite( sl.list[index] )
  sl.list[index] = sprite
  sl.bRedisplay = 1

endfunction


// call SpriteList_Update with mouse information
function SpriteList_UpdateMouse( sl ref as tSpriteListState )
  updated = SpriteList_Update( sl, ScreenToWorldX(GetPointerX()), ScreenToWorldY(GetPointerY()), GetPointerPressed(), GetPointerReleased(), GetPointerState() )
endfunction updated


// call SpriteList_Update once per frame, or whenever the spritelist should be updated
function SpriteList_Update( sl ref as tSpriteListState, x# as float, y# as float, pressed as integer, released as integer, state as integer )
updated as integer = 0
savedtopindex as integer
savedscrolloffset# as float

  savedtopindex = sl.topindex
  savedscrolloffset# = sl.scrolloffset#

  // if the pointer is in bounds
  if sl.bActive and x# >= sl.x# and y# >= sl.y# and x# <= sl.x# + sl.width# and y# <= sl.y# + sl.height#
    if pressed > 0
      sl.dragy# = y#
      sl.mousedownx# = x#
      sl.mousedowny# = y#
      sl.mousedownmove# = 0
    elseif state > 0 and y# <> sl.dragy# and sl.dragy# >= sl.y#
      if y# > sl.dragy#
        sl.bScrollingUp = 1
        sl.bShowLastSprite = 0
      else
        sl.bScrollingUp = 0
      endif

      if 0 = sl.bShowLastSprite then sl.scrolloffset# = sl.scrolloffset# + sl.dragy# - y#
      sl.dragy# = y#
      sl.bRedisplay = 1
      
      sl.mousedownmove# = sl.mousedownmove# + Abs( x# - sl.mousedownx# ) + Abs( y# - sl.mousedowny# )
    elseif released > 0 and sl.mousedownmove# < 50
    // click
      if sl.bClickToSelect <> 0
        for i = sl.topindex to sl.list.length
          if GetSpriteVisible( sl.list[i] )
            if GetSpriteHitTest( sl.list[i], 1+sl.x#, y# ) > 0
              updated = 1
              if SpriteList_GetSelected( sl, i )
                SpriteList_ClearSelected( sl, i )
              else
                SpriteList_SetSelected( sl, i )
              endif
            endif
          endif
        next i
      endif
    endif
  endif
  
  if state = 0
    sl.dragy# = sl.y# - 1
  endif

  if sl.bActive
    if sl.bScrollWheelAnywhere or (x# >= sl.x# and y# >= sl.y# and x# <= sl.x# + sl.width# and y# <= sl.y# + sl.height#)
      if GetRawMouseWheelDelta() > 0
      // scroll up
        if sl.topindex > 0 then sl.topindex = sl.topindex - 1
        sl.scrolloffset# = 0
        sl.bShowLastSprite = 0
        sl.bRedisplay = 1
        sl.bScrollingUp = 1
      elseif GetRawMouseWheelDelta() < 0
      // scroll down
        if sl.topindex < sl.list.length and sl.bShowLastSprite = 0 then sl.topindex = sl.topindex + 1
        sl.scrolloffset# = 0
        sl.bRedisplay = 1
        sl.bScrollingUp = 0
      endif
    endif
  endif

// display
  if sl.bVisible and sl.bRedisplay > 0 and sl.topindex >= 0 and sl.topindex <= sl.list.length
  ypos# as float

    sl.bRedisplay = 0

    if sl.scrolloffset# < 0
      if sl.topindex > 0
        sl.topindex = sl.topindex - 1
//        SpriteList_SetDisplaySprite( sl, sl.topindex )
        sl.scrolloffset# = sl.scrolloffset# + GetSpriteHeight( sl.list[sl.topindex] ) + sl.spacing#
      else
        sl.scrolloffset# = 0
      endif
    endif

    ypos# = sl.y# - sl.scrolloffset#

    for i = 0 to sl.list.length
      if i >= sl.topindex and ypos# < sl.y# + sl.height#
        SpriteList_SetDisplaySprite( sl, i )
        SetSpritePosition( sl.list[i], sl.x#, ypos# )
        ypos# = ypos# + GetSpriteHeight( sl.list[i] ) + sl.spacing#

        // if this is the last line and there is no scrolloffset and we are not scrolling up,
        //   set scrolloffset and show all of the last sprite
        if i = sl.list.length and 0 = sl.scrolloffset# and 0 = sl.bScrollingUp
          sl.scrolloffset# = ypos# - (sl.y# + sl.height#) - sl.spacing#
          if 0 = sl.scrolloffset# then sl.scrolloffset# = 0.001
          sl.bShowLastSprite = 1
          sl.bRedisplay = 1
        endif
      else
        // if we are outside the window set sprite to invisible
        SetSpriteVisible( sl.list[i], 0 )

        // if we are supposed to show last sprite but this sprite is not visible, scroll down
        if sl.bShowLastSprite > 0 and i >= sl.topindex
          sl.topindex = sl.topindex + 1
          sl.bRedisplay = 1
        endif
      endif
    next i

    // if we are not scrolling up and topindex was displayed outside the window, scroll down
    if 0 = sl.bScrollingUp and GetSpriteVisible( sl.list[sl.topindex] ) = 0 and sl.scrolloffset# > GetSpriteHeight( sl.list[sl.topindex] ) + sl.spacing#
      sl.scrolloffset# = sl.scrolloffset# - (GetSpriteHeight( sl.list[sl.topindex] ) + sl.spacing#)
      sl.topindex = sl.topindex + 1
      sl.bRedisplay = 1
    endif

    // if there is empty space at the bottom of the window, trim scrolloffset and maybe scroll up
    if ypos# < sl.y# + sl.height# and sl.scrolloffset# > 0.001
      emptyspace# = sl.y# + sl.height# - ypos# + sl.spacing#
      if emptyspace# >= sl.scrolloffset#
        if sl.topindex > 0
          sl.topindex = sl.topindex - 1
          SpriteList_SetDisplaySprite( sl, sl.topindex )
          sl.scrolloffset# = sl.scrolloffset# - emptyspace# + GetSpriteHeight( sl.list[sl.topindex] ) + sl.spacing#
        else
          sl.scrolloffset# = 0.001
        endif
      else
        sl.scrolloffset# = sl.scrolloffset# - emptyspace#
      endif
      sl.bRedisplay = 1
      sl.bShowLastSprite = 1
    endif
  endif

endfunction updated or savedscrolloffset# <> sl.scrolloffset# or savedtopindex <> sl.topindex


// internal. make a sprite ready to display
function SpriteList_SetDisplaySprite( sl ref as tSpriteListState, index as integer )

  SetSpriteVisible( sl.list[index], 1 )
  SetSpriteDepth( sl.list[index], sl.depth )
  SetSpriteScissor( sl.list[index], sl.x#, sl.y#, sl.x# + sl.width#, sl.y# + sl.height# )

endfunction


// set one item to selected
function SpriteList_SetSelected( sl ref as tSpriteListState, index as integer )

  if index >= 0 and index <= sl.list.length
//    SpriteList_SetDisplaySprite( sl, index )
    sl.selected.insert( index )
  endif

endfunction


// set one item to unselected
function SpriteList_ClearSelected( sl ref as tSpriteListState, index as integer )

  if index >= 0 and index <= sl.list.length
    for i = sl.selected.length to 0 step -1
      if index = sl.selected[i] then sl.selected.remove( i )
    next i
  endif

endfunction


// set all items to unselected
function SpriteList_ClearAllSelected( sl ref as tSpriteListState )

  for i = 0 to sl.selected.length
    SpriteList_ClearSelected( sl, sl.selected[i] )
  next i
  sl.selected.length = -1

endfunction


// return selected state of an item
function SpriteList_GetSelected( sl ref as tSpriteListState, index as integer )
ret as integer = 0

  for i = 0 to sl.selected.length
    if sl.selected[i] = index then ret = 1
  next i

endfunction ret


// allow items to be selected with a touch/mouseclick
function SpriteList_SetClickToSelect( sl ref as tSpriteListState, bClickToSelect as integer )
  sl.bClickToSelect = bClickToSelect
endfunction


// set the sprite display depth
function SpriteList_SetDepth( sl ref as tSpriteListState, depth as integer )

  sl.depth = depth
  for i = 0 to sl.list.length
    if GetSpriteVisible( sl.list[i] ) then SetSpriteDepth( sl.list[i], depth )
  next i

endfunction


// set the spacing between sprites
function SpriteList_SetSpacing( sl ref as tSpriteListState, spacing# as float )

  sl.spacing# = spacing#
  sl.bRedisplay = 1

endfunction


// set mouse bounds for scroll wheel to anywhere or within list only
function SpriteList_SetScrollWheelAnywhere( sl ref as tSpriteListState, bScrollWheelAnywhere as integer )
  sl.bScrollWheelAnywhere = bScrollWheelAnywhere
endfunction


// set spritelist to visible or invisible
function SpriteList_SetVisible( sl ref as tSpriteListState, bVisible as integer )

  sl.bVisible = bVisible
  sl.bRedisplay = bVisible
  SpriteList_SetActive( sl, bVisible )

  if bVisible = 0
    for i = 0 to sl.list.length
      SetSpriteVisible( sl.list[i], 0 )
    next i
  endif

endfunction


// enable/disable the spritelist
function SpriteList_SetActive( sl ref as tSpriteListState, bActive as integer )
  sl.bActive = bActive
endfunction


// draw a box around the spritelist
function SpriteList_DrawOutline( sl ref as tSpriteListState, color as integer )
  DrawBox( sl.x#, sl.y#, sl.x#+sl.width#, sl.y#+sl.height#, color, color, color, color, 0 )
endfunction

