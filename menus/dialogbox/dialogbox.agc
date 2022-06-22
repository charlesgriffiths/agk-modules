// File: dialogbox.agc
// Created: 22-06-22
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


type tDialogBoxPrompt
  x# as float
  y# as float
  prompt$ as string
  textsize# as float
  color as integer

  sprite as integer
  text as integer
endtype


type tDialogBoxState
  x# as float
  y# as float
  width# as float
  height# as float
  bgcolor as integer
  bgsprite as integer
  prompts as tDialogBoxPrompt[]
  choices as tDialogBoxPrompt[]
  bBoldHoverText as integer
  bBoxTextChoice as integer
  textboxmargin# as float
  textboxcolor as integer

  choice as integer
endtype


// initialize the state of a dialogbox instance
function DialogBox_Init( x# as float, y# as float, width# as float, height# as float, bgcolor as integer, bgsprite as integer )
db as tDialogBoxState

  db.x# = x#
  db.y# = y#
  db.width# = width#
  db.height# = height#
  db.bgcolor = bgcolor

  db.bgsprite = 0
  if 0 <> bgsprite
    db.bgsprite = CloneSprite( bgsprite )
    SetSpriteVisible( bgsprite, 0 )
  endif

  db.bBoldHoverText = 1
  db.choice = -2

  db.bBoxTextChoice = 1
  db.textboxmargin# = 10
  db.textboxcolor = MakeColor( 255, 0, 0, 255 )

endfunction db


// delete a dialogbox
function DialogBox_Delete( db ref as tDialogBoxState )

  if 0 <> db.bgsprite then DeleteSprite( db.bgsprite )
  db.bgsprite = 0

  for i = 0 to db.prompts.length
    if 0 <> db.prompts[i].sprite then DeleteSprite( db.prompts[i].sprite )
    if 0 <> db.prompts[i].text then DeleteText( db.prompts[i].text )
  next i
  db.prompts.length = -1

  for i = 0 to db.choices.length
    if 0 <> db.choices[i].sprite then DeleteSprite( db.choices[i].sprite )
    if 0 <> db.choices[i].text then DeleteText( db.choices[i].text )
  next i
  db.choices.length = -1

endfunction


// set hovered choice text to bold or not
function DialogBox_SetBoldHoverText( db ref as tDialogBoxState, bBoldHoverText as integer )
  db.bBoldHoverText = bBoldHoverText
endfunction


// set choice text to be boxed or not
function DialogBox_SetChoiceTextBox( db ref as tDialogBoxState, bBoxTextChoice as integer )
  db.bBoxTextChoice = bBoxTextChoice
endfunction


// set choice text box margin
function DialogBox_SetChoiceTextBoxMargin( db ref as tDialogBoxState, margin# as float )
  db.textboxmargin# = margin#
endfunction


// set choice text box color
function DialogBox_SetChoiceTextBoxColor( db ref as tDialogBoxState, color as integer )
  db.textboxcolor = color
endfunction


// add a text prompt (display only)
function DialogBox_AddTextPrompt( db ref as tDialogBoxState, x# as float, y# as float, prompt$ as string, textsize# as float, textcolor as integer)
  DialogBox_AddPrompt( db.prompts, x#, y#, prompt$, textsize#, textcolor, 0 )
endfunction


// add a sprite prompt (display only)
function DialogBox_AddSpritePrompt( db ref as tDialogBoxState, x# as float, y# as float, sprite as integer )
  DialogBox_AddPrompt( db.prompts, x#, y#, "", 0, 0, sprite )
endfunction


// add a text choice (clickable)
function DialogBox_AddTextChoice( db ref as tDialogBoxState, x# as float, y# as float, prompt$ as string, textsize# as float, textcolor as integer)
  DialogBox_AddPrompt( db.choices, x#, y#, prompt$, textsize#, textcolor, 0 )
endfunction


// add a sprite choice (clickable)
function DialogBox_AddSpriteChoice( db ref as tDialogBoxState, x# as float, y# as float, sprite as integer )
  DialogBox_AddPrompt( db.choices, x#, y#, "", 0, 0, sprite )
endfunction


// internal helper function to add sprite or text to prompts or choices
function DialogBox_AddPrompt( dbps ref as tDialogBoxPrompt[], x# as float, y# as float, prompt$ as string, textsize# as float, textcolor as integer, sprite as integer )
dbp as tDialogBoxPrompt

  dbp.x# = x#
  dbp.y# = y#
  dbp.prompt$ = prompt$
  dbp.textsize# = textsize#
  dbp.color = textcolor

  if 0 = sprite
    dbp.sprite = 0
  else
    dbp.sprite = CloneSprite( sprite )
    SetSpriteDepth( dbp.sprite, 1 )
    SetSpriteVisible( dbp.sprite, 0 )
    FixSpriteToScreen( dbp.sprite, 1 )
  endif

  dbps.insert( dbp )

endfunction


// display the dialog box and pause the app until a choice is chosen
function DialogBox_Display( db ref as tDialogBoxState )
shade as integer
bg as integer
defaultok as integer = 0

  shade = CreateSprite( 0 )
  SetSpriteColorAlpha( shade, 64 )
  SetSpriteSize( shade, GetVirtualWidth(), GetVirtualHeight())
  SetSpritePosition( shade, 0, 0 )
  FixSpriteToScreen( shade, 1 )
  SetSpriteDepth( shade, 3 )

  if 0 = db.bgsprite
    bg = CreateSprite( 0 )
    SetSpriteColor( bg, GetColorRed( db.bgcolor ), GetColorGreen( db.bgcolor ), GetColorBlue( db.bgcolor ), 255 )
  else
    bg = CloneSprite( db.bgsprite )
    SetSpriteVisible( bg, 1 )
  endif
  SetSpriteSize( bg, db.width#, db.height# )
  SetSpritePosition( bg, db.x#, db.y# )
  SetSpriteDepth( bg, 2 )
  FixSpriteToScreen( bg, 1 )

  DialogBox_ShowPrompt( db, db.prompts )

  if -1 = db.choices.length
    defaultok = CreateText( "OK" )
    SetTextSize( defaultok, db.width# * 0.1 )
    SetTextPosition( defaultok, db.x# + 0.5 * (db.width# - GetTextTotalWidth( defaultok )), db.y# + db.height# - GetTextTotalHeight( defaultok ) - db.height# * 0.05 )
    FixTextToScreen( defaultok, 1 )
    SetTextDepth( defaultok, 0 )
  else
    DialogBox_ShowPrompt( db, db.choices )
  endif
  db.choice = -1

  do
    x# = ScreenToWorldX( GetPointerX())
    y# = ScreenToWorldY( GetPointerY())
    if GetPointerReleased()
      for i = 0 to db.choices.length
        SetTextBold( db.choices[i].text, 0 )
        if 0 <> db.choices[i].sprite
          if GetSpriteHitTest( db.choices[i].sprite , x#, y# )
            db.choice = i
            exit
          endif
        endif
        if 0 <> db.choices[i].text
          if GetTextHitTest( db.choices[i].text, x#, y# )
            db.choice = i
            exit
          endif
        endif
      next i
      if -1 <> db.choice then exit

      if 0 <> defaultok
        SetTextBold( defaultok, 0 )
        if GetTextHitTest( defaultok, x#, y# ) then exit
      endif
    endif

    if db.bBoldHoverText
      for i = 0 to db.choices.length
        DialogBox_BoldHoveredText( db.choices[i].text, x#, y# )
      next i
      DialogBox_BoldHoveredText( defaultok, x#, y# )
    endif

    if db.bBoxTextChoice
      for i = 0 to db.choices.length
        DialogBox_DrawTextBox( db.choices[i].text, db.textboxmargin#, db.textboxcolor )
      next i
      DialogBox_DrawTextBox( defaultok, db.textboxmargin#, db.textboxcolor )
    endif

    sync()
  loop

  for i = 0 to db.prompts.length
    if 0 <> db.prompts[i].text then SetTextVisible( db.prompts[i].text, 0 )
    if 0 <> db.prompts[i].sprite then SetSpriteVisible( db.prompts[i].sprite, 0 )
  next i

  for i = 0 to db.choices.length
    if 0 <> db.choices[i].text then SetTextVisible( db.choices[i].text, 0 )
    if 0 <> db.choices[i].sprite then SetSpriteVisible( db.choices[i].sprite, 0 )
  next i

  if 0 <> defaultok then DeleteText( defaultok )
  DeleteSprite( bg )
  DeleteSprite( shade )

endfunction db.choice


// helper function to bold hovered text
function DialogBox_BoldHoveredText( id as integer, x# as float, y# as float )

  if 0 <> id
    if GetTextHitTest( id, x#, y# )
      SetTextBold( id, 1 )
    else
      SetTextBold( id, 0 )
    endif
  endif

endfunction


// helper function to draw a box around a text choice
function DialogBox_DrawTextBox( id as integer, spacing# as float, color as integer )

  if 0 <> id
    x# = GetTextX( id )
    y# = GetTextY( id )
    DrawBox( x# - spacing#, y# - spacing#/2, x# + spacing# + GetTextTotalWidth( id ), y# + spacing# + GetTextTotalHeight( id ), color, color, color, color, 0 )
  endif

endfunction


// internal helper function to show sprite or text in prompts or choices
function DialogBox_ShowPrompt( db ref as tDialogBoxState, dbps ref as tDialogBoxPrompt[] )

  for i = 0 to dbps.length
    if 0 = dbps[i].text and 1 <> CompareString( "", dbps[i].prompt$ )
      id = CreateText( dbps[i].prompt$ )
      SetTextSize( id, dbps[i].textsize# )
      SetTextColor( id, GetColorRed( dbps[i].color ), GetColorGreen( dbps[i].color ), GetColorBlue( dbps[i].color ), GetColorAlpha( dbps[i].color ))
      x# = db.x# + dbps[i].x#
      if dbps[i].x# < 0 then x# = x# + db.width# - GetTextTotalWidth( id )
      y# = db.y# + dbps[i].y#
      if dbps[i].y# < 0 then y# = y# + db.height# - GetTextTotalHeight( id )
      SetTextPosition( id, x#, y# )
      FixTextToScreen( id, 1 )
      SetTextDepth( id, 0 )
      dbps[i].text = id
    endif

    if 0 <> dbps[i].text then SetTextVisible( dbps[i].text, 1 )
    if 0 <> dbps[i].sprite
      SetSpritePosition( dbps[i].sprite, db.x# + dbps[i].x#, db.y# + dbps[i].y# )
      SetSpriteVisible( dbps[i].sprite, 1 )
    endif
  next i

endfunction

