// File: textoutline.agc
// Created: 22-09-11
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
// https://github.com/charlesgriffiths/agk-modules/blob/main/juice/textoutline/textoutline.agc


type tTextOutline
  x# as float
  y# as float
  width# as float
  textsize# as float
  text$ as string
  id as integer[]
  outlinecolor as integer
  followtime# as float

  bFollowCursor as integer
  bActive as integer
endtype


function TextOutline_Init( x# as float, y# as float, width# as float )
t as tTextOutline

  t.width# = width#
  t.bActive = 1

  t.id.length = 16
  for i = 0 to t.id.length
    t.id[i] = CreateText( "" )
  next i
  SetTextDepth( t.id[0], GetTextDepth( t.id[0] ) - 1 )
  SetTextColor( t.id[0], 0, 0, 0, 255 )

  TextOutline_SetPosition( t, x#, y# )

endfunction t


function TextOutline_Delete( t ref as tTextOutline )

  for i = 0 to t.id.length
    DeleteText( t.id[i] )
  next i
  t.id.length = -1

endfunction


function TextOutline_SetText( t ref as tTextOutline, text$ as string )

  t.text$ = text$
  for i = 0 to t.id.length
    SetTextString( t.id[i], text$ )
  next i

endfunction


function TextOutline_Split( text$ as string )
ret as string[]

  ret.length = CountStringTokens2( text$, chr(10)) - 1

  for i=0 to ret.length
    ret[i] = GetStringToken2( text$, chr(10), i+1 )
  next i

endfunction ret


function TextOutline_SetColor( t ref as tTextOutline, color as integer )
  SetTextColor( t.id[0], GetColorRed( color ), GetColorGreen( color ), GetColorBlue( color ), GetColorAlpha( color ))
endfunction


function TextOutline_SetOutlineColor( t ref as tTextOutline, color as integer )

  t.outlinecolor = color
  for i = 1 to t.id.length
    SetTextColor( t.id[i], GetColorRed( color ), GetColorGreen( color ), GetColorBlue( color ), GetColorAlpha( color ))
  next i

endfunction


function TextOutline_SetWidth( t ref as tTextOutline, width# as float )

  t.width# = width#
  TextOutline_MoveTo( t, t.x#, t.y# )

endfunction


function TextOutline_SetSize( t ref as tTextOutline, size# as float )

  t.textsize# = size#
  for i = 0 to t.id.length
    SetTextSize( t.id[i], size# )
  next i
  TextOutline_MoveTo( t, t.x#, t.y# )

endfunction


function TextOutline_GetTotalWidth( t ref as tTextOutline )
  exitfunction GetTextTotalWidth( t.id[0] ) + t.width# * 2
endfunction 0.0


function TextOutline_GetTotalHeight( t ref as tTextOutline )
  exitfunction GetTextTotalHeight( t.id[0] ) + t.width# * 2
endfunction 0.0


function TextOutline_SetPosition( t ref as tTextOutline, x# as float, y# as float )

  t.x# = x#
  t.y# = y#
  TextOutline_MoveTo( t, x#, y# )

endfunction


function TextOutline_MoveTo( t ref as tTextOutline, x# as float, y# as float )

  SetTextPosition( t.id[0], x#, y# )

  SetTextPosition( t.id[1], x#-t.width#*0.707, y#-t.width#*0.707 )
  SetTextPosition( t.id[2], x#-t.width#*0.707, y#+t.width#*0.707 )
  SetTextPosition( t.id[3], x#+t.width#*0.707, y#-t.width#*0.707 )
  SetTextPosition( t.id[4], x#+t.width#*0.707, y#+t.width#*0.707 )
  SetTextPosition( t.id[5], x#-t.width#, y# )
  SetTextPosition( t.id[6], x#, y#+t.width# )
  SetTextPosition( t.id[7], x#, y#-t.width# )
  SetTextPosition( t.id[8], x#+t.width#, y# )
  SetTextPosition( t.id[9], x#-t.width#*0.383, y#-t.width#*0.924 )
  SetTextPosition( t.id[10], x#-t.width#*0.383, y#+t.width#*0.924 )
  SetTextPosition( t.id[11], x#+t.width#*0.383, y#-t.width#*0.924 )
  SetTextPosition( t.id[12], x#+t.width#*0.383, y#+t.width#*0.924 )
  SetTextPosition( t.id[13], x#-t.width#*0.383, y#-t.width#*0.924 )
  SetTextPosition( t.id[14], x#-t.width#*0.383, y#+t.width#*0.924 )
  SetTextPosition( t.id[15], x#+t.width#*0.383, y#-t.width#*0.924 )
  SetTextPosition( t.id[16], x#+t.width#*0.383, y#+t.width#*0.924 )

endfunction


function TextOutline_UpdateMouse( t ref as tTextOutline )
  TextOutline_Update( t, ScreenToWorldX(GetPointerX()), ScreenToWorldY(GetPointerY()), GetPointerPressed(), GetPointerReleased(), GetPointerState() )
endfunction


function TextOutline_Update( t ref as tTextOutline, x# as float, y# as float, pressed as integer, released as integer, state as integer )

  if t.followtime# > 0
    dec t.followtime#, GetFrameTime()
    if t.followtime# <= 0 then TextOutline_Show( t, 0 )
  endif

  if t.bFollowCursor and t.bActive
    movetox# = x# + t.x#
    movetoy# = y# + t.y#
    if movetox# < GetScreenBoundsLeft() then movetox# = GetScreenBoundsLeft()
    if movetoy# < GetScreenBoundsTop() then movetoy# = GetScreenBoundsTop()
    TextOutline_MoveTo( t, movetox#, movetoy# )
  endif

endfunction


function TextOutline_SetFollowtime( t ref as tTextOutline, followtime# as float )
  t.followtime# = followtime#
endfunction


function TextOutline_SetVisible( t ref as tTextOutline, bVisible as integer )

  for i = 0 to t.id.length
    SetTextVisible( t.id[i], bVisible )
  next i

endfunction


function TextOutline_SetActive( t ref as tTextOutline, bActive as integer )
  t.bActive = bActive
endfunction


function TextOutline_Show( t ref as tTextOutline, bShow as integer )

  TextOutline_SetVisible( t, bShow )
  TextOutline_SetActive( t, bShow )

endfunction

