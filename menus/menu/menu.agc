// File: menu.agc
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
//
// https://github.com/charlesgriffiths/agk-modules/blob/main/menus/menu/menu.agc


#constant Menu_ChangeNone 0
#constant Menu_ChangeSize 1
#constant Menu_ChangeAlpha 2
#constant Menu_ChangeColor 3
#constant Menu_ChangePosition 4
#constant Menu_ChangeTextColor 5
#constant Menu_Hover 6
#constant Menu_Pressed 7
#constant Menu_Center 8
#constant Menu_AlignLeft 9
#constant Menu_AlignRight 10


type tMenuItem
  normalsprite as integer
  hoversprite as integer
  pressedsprite as integer
  text as integer
  textcolor as integer
endtype


type tMenuChange
  changefunction as integer
  x# as float
  y# as float
  r as integer
  g as integer
  b as integer
  a as integer
endtype


type tMenuState
  x# as float
  y# as float
  spacing# as float
  depth as integer

  list as tMenuItem[]
  hoverchange as tMenuChange[]
  pressedchange as tMenuChange[]

  bActive as integer
  bVisible as integer
  bScissorText as integer
endtype



// initialize the state of a menu instance
function Menu_Init( x# as float, y# as float, spacing# as float, spritelist as integer[] )
m as tMenuState
ypos# as float

  m.x# = x#
  m.y# = y#
  m.spacing# = spacing#
  m.depth = 10

  m.list.length = spritelist.length
  ypos# = y#
  for i = 0 to spritelist.length
    m.list[i].normalsprite = CloneSprite( spritelist[i] )
    SetSpritePosition( m.list[i].normalsprite, x#, ypos# )
    SetSpriteDepth( m.list[i].normalsprite, m.depth )
    ypos# = ypos# + spacing# + GetSpriteHeight( m.list[i].normalsprite )
  next i

  Menu_ClearTransform( m, Menu_Hover )
  Menu_AddTransformAlpha( m, Menu_Hover, -64 )

  Menu_ClearTransform( m, Menu_Pressed )
  Menu_AddTransformPosition( m, Menu_Pressed, -spacing#/2, -spacing#/2 )
  Menu_AddTransformSize( m, Menu_Pressed, spacing#, spacing# )

  m.bActive = 1
  m.bVisible = 1
  m.bScissorText = 1

endfunction m


// delete a menu
function Menu_Delete( m ref as tMenuState )

  for i = 0 to m.list.length
    if m.list[i].normalsprite then DeleteSprite( m.list[i].normalsprite )
    if m.list[i].hoversprite then DeleteSprite( m.list[i].hoversprite )
    if m.list[i].pressedsprite then DeleteSprite( m.list[i].pressedsprite )
    if m.list[i].text then DeleteText( m.list[i].text )
  next i

  m.list.length = -1
  m.hoverchange.length = -1
  m.pressedchange.length = -1

endfunction


// set text for a menu item
function Menu_SetText( m ref as tMenuState, index as integer, text$ as string, size as integer, color as integer, justify as integer, xoffset# as float )

  if m.list[index].text then DeleteText( m.list[index].text )
  if CompareString( "", text$ )
    m.list[index].text = 0
  else
    id = CreateText( text$ )
    SetTextDepth( id, m.depth-1 )
    SetTextSize( id, size )
    SetTextColor( id, GetColorRed( color ), GetColorGreen( color ), GetColorBlue( color ), GetColorAlpha( color ))
    m.list[index].textcolor = color
    twidth# = GetTextTotalWidth( id )
    theight# = GetTextTotalHeight( id )
    x# = GetSpriteX( m.list[index].normalsprite )
    y# = GetSpriteY( m.list[index].normalsprite )
    swidth# = GetSpriteWidth( m.list[index].normalsprite )
    sheight# = GetSpriteHeight( m.list[index].normalsprite )
    if m.bScissorText then SetTextScissor( id, x#, y#, x# + swidth#, y# + sheight# )
    m.list[index].text = id

    select justify
      case Menu_Center:
        SetTextPosition( id, x# + (swidth# - twidth#)/2 + xoffset#, y# + (sheight# - theight#)/2 )
      endcase

      case Menu_AlignLeft:
        SetTextPosition( id, x# + xoffset#, y# + (sheight# - theight#)/2 )
      endcase

      case Menu_AlignRight:
        SetTextPosition( id, x# + swidth# - twidth# + xoffset#, y# + (sheight# - theight#)/2 )
      endcase
    endselect
  endif

endfunction


// change the depth for sprites and text of this menu
function Menu_SetDepth( m ref as tMenuState, depth as integer )

  m.depth = depth
  for i = 0 to m.list.length
    if m.list[i].normalsprite then SetSpriteDepth( m.list[i].normalsprite, depth )
    if m.list[i].hoversprite then SetSpriteDepth( m.list[i].hoversprite, depth )
    if m.list[i].pressedsprite then SetSpriteDepth( m.list[i].pressedsprite, depth )
    if m.list[i].text then SetTextDepth( m.list[i].text, depth-1 )
  next i

endfunction


// call Menu_Update with mouse information
function Menu_UpdateMouse( m ref as tMenuState )
  choice = Menu_Update( m, ScreenToWorldX(GetPointerX()), ScreenToWorldY(GetPointerY()), GetPointerPressed(), GetPointerReleased(), GetPointerState() )
endfunction choice


// call Menu_Update once per frame, or whenever the menu should be updated
function Menu_Update( m ref as tMenuState, x# as float, y# as float, pressed as integer, released as integer, state as integer )
choice as integer = -1

  if 0 = m.bVisible then exitfunction -1

  for i = 0 to m.list.length
    sprite = m.list[i].normalsprite
    color = m.list[i].textcolor

    if GetSpriteHitTest( sprite, x#, y# )
      if state
        if 0 = m.list[i].pressedsprite then m.list[i].pressedsprite = Menu_Transform( sprite, m.pressedchange )
        sprite = m.list[i].pressedsprite
        if m.list[i].text then color = Menu_TransformTextColor( color, m.pressedchange )
      else
        if 0 = m.list[i].hoversprite then m.list[i].hoversprite = Menu_Transform( sprite, m.hoverchange )
        sprite = m.list[i].hoversprite
        if m.list[i].text then color = Menu_TransformTextColor( color, m.hoverchange )
      endif

      if m.bActive and released then choice = i
    endif
    if m.list[i].text then SetTextColor( m.list[i].text, GetColorRed( color ), GetColorGreen( color ), GetColorBlue( color ), GetColorAlpha( color ))

    if m.list[i].normalsprite then SetSpriteVisible( m.list[i].normalsprite, 0 )
    if m.list[i].hoversprite then SetSpriteVisible( m.list[i].hoversprite, 0 )
    if m.list[i].pressedsprite then SetSpriteVisible( m.list[i].pressedsprite, 0 )
    SetSpriteVisible( sprite, 1 )
    if m.list[i].text then SetTextVisible( m.list[i].text, 1 )
  next i

endfunction choice


function Menu_RefreshTransformSprites( m ref as tMenuState )

  for i = 0 to m.list.length
    sprite = m.list[i].normalsprite
    
    if m.list[i].pressedsprite then DeleteSprite( m.list[i].pressedsprite )
    m.list[i].pressedsprite = Menu_Transform( sprite, m.pressedchange )
    if m.list[i].hoversprite then DeleteSprite( m.list[i].hoversprite )
    m.list[i].hoversprite = Menu_Transform( sprite, m.hoverchange )
  next i

endfunction


// internal. changes sprite by instructions in change
function Menu_Transform( sprite as integer, change ref as tMenuChange[] )

  sprite = CloneSprite( sprite )
  for i = 0 to change.length
    select change[i].changefunction
      case Menu_ChangeSize:
        SetSpriteSize( sprite, GetSpriteWidth( sprite ) + change[i].x#, GetSpriteHeight( sprite ) + change[i].y# )
      endcase

      case Menu_ChangeAlpha:
        SetSpriteColorAlpha( sprite, GetSpriteColorAlpha( sprite ) + change[i].a )
      endcase

      case Menu_ChangeColor:
        SetSpriteColor( sprite, GetSpriteColorRed( sprite ) + change[i].r, GetSpriteColorGreen( sprite ) + change[i].g, GetSpriteColorBlue( sprite ) + change[i].b, GetSpriteColorAlpha( sprite ) + change[i].a )
      endcase

      case Menu_ChangePosition:
        SetSpritePosition( sprite, GetSpriteX( sprite ) + change[i].x#, GetSpriteY( sprite ) + change[i].y# )
      endcase
    endselect
  next i

endfunction sprite


// internal. changes text color by instructions in change
function Menu_TransformTextColor( color as integer, change ref as tMenuChange[] )

  for i = 0 to change.length
    select change[i].changefunction
      case Menu_ChangeTextColor:
        color = MakeColor( change[i].r, change[i].g, change[i].b, change[i].a )
      endcase
    endselect
  next i

endfunction color


// remove sprite transform instructions
function Menu_ClearTransform( m ref as tMenuState, transform as integer )

  if transform = Menu_Hover
    m.hoverchange.length = -1
    for i = 0 to m.list.length
      if m.list[i].hoversprite then DeleteSprite( m.list[i].hoversprite )
      m.list[i].hoversprite = 0
    next i
  elseif transform = Menu_Pressed
    m.pressedchange.length = -1
    for i = 0 to m.list.length
      if m.list[i].pressedsprite then DeleteSprite( m.list[i].pressedsprite )
      m.list[i].pressedsprite = 0
    next i
  endif

endfunction


// add a transform change to size
function Menu_AddTransformSize( m ref as tMenuState, transform as integer, dx# as float, dy# as float )
mc as tMenuChange

  mc.changefunction = Menu_ChangeSize
  mc.x# = dx#
  mc.y# = dy#

  if Menu_Hover = transform
    m.hoverchange.insert( mc )
  elseif Menu_Pressed = transform
    m.pressedchange.insert( mc )
  endif

endfunction


// add a transform change to alpha
function Menu_AddTransformAlpha( m ref as tMenuState, transform as integer, da as integer )
mc as tMenuChange

  mc.changefunction = Menu_ChangeAlpha
  mc.a = da

  if Menu_Hover = transform
    m.hoverchange.insert( mc )
  elseif Menu_Pressed = transform
    m.pressedchange.insert( mc )
  endif

endfunction


// add a transform change to color
function Menu_AddTransformColor( m ref as tMenuState, transform as integer, dr as integer, dg as integer, db as integer, da as integer )
mc as tMenuChange

  mc.changefunction = Menu_ChangeColor
  mc.r = dr
  mc.g = dg
  mc.b = db
  mc.a = da

  if Menu_Hover = transform
    m.hoverchange.insert( mc )
  elseif Menu_Pressed = transform
    m.pressedchange.insert( mc )
  endif

endfunction


// add a transform change to text color
function Menu_AddTransformTextColor( m ref as tMenuState, transform as integer, dr as integer, dg as integer, db as integer, da as integer )
mc as tMenuChange

  mc.changefunction = Menu_ChangeTextColor
  mc.r = dr
  mc.g = dg
  mc.b = db
  mc.a = da

  if Menu_Hover = transform
    m.hoverchange.insert( mc )
  elseif Menu_Pressed = transform
    m.pressedchange.insert( mc )
  endif

endfunction


// add a transform change to position
function Menu_AddTransformPosition( m ref as tMenuState, transform as integer, dx# as float, dy# as float )
mc as tMenuChange

  mc.changefunction = Menu_ChangePosition
  mc.x# = dx#
  mc.y# = dy#

  if Menu_Hover = transform
    m.hoverchange.insert( mc )
  elseif Menu_Pressed = transform
    m.pressedchange.insert( mc )
  endif

endfunction


// set the transform sprite directly
function Menu_SetTransformSprite( m ref as tMenuState, index as integer, transform as integer, sprite as integer )

  if Menu_Hover = transform
    if m.list[index].hoversprite then DeleteSprite( m.list[index].hoversprite )
    m.list[index].hoversprite = sprite
  elseif Menu_Pressed = transform
    if m.list[index].pressedsprite then DeleteSprite( m.list[index].pressedsprite )
    m.list[index].pressedsprite = sprite
  endif

endfunction


// set menu to visible or invisible
function Menu_SetVisible( m ref as tMenuState, bVisible as integer )

  m.bVisible = bVisible
  Menu_SetActive( m, bVisible )

  if bVisible = 0
    for i = 0 to m.list.length
      if m.list[i].normalsprite then SetSpriteVisible( m.list[i].normalsprite, 0 )
      if m.list[i].hoversprite then SetSpriteVisible( m.list[i].hoversprite, 0 )
      if m.list[i].pressedsprite then SetSpriteVisible( m.list[i].pressedsprite, 0 )
      if m.list[i].text then SetTextVisible( m.list[i].text, 0 )
    next i
  endif

endfunction


// enable/disable the menu
function Menu_SetActive( m ref as tMenuState, bActive as integer )
  m.bActive = bActive
endfunction


// turn text scissoring on/off
function Menu_SetScissorText( m ref as tMenuState, bScissorText as integer )

  m.bScissorText = bScissorText
  
  if 0 = bScissorText
    for i = 0 to m.list.length
      if m.list[i].text then SetTextScissor( m.list[i].text, 0, 0, 0, 0 )
    next i
  endif

endfunction


// draw a box around the menu area
function Menu_DrawBox( m ref as tMenuState, color as integer )
width# as float = 0
height# as float = 0

  if m.list.length >= 0 then width# = GetSpriteWidth( m.list[0].normalsprite )
  for i = 0 to m.list.length
    height# = height# + GetSpriteHeight( m.list[i].normalsprite )
  next i
  height# = height# + m.spacing# * m.list.length

  DrawBox( m.x#, m.y#, m.x#+width#, m.y#+height#, color, color, color, color, 0 )

endfunction

