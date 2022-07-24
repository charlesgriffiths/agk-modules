// File: spriteroute.agc
// Created: 22-07-02
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
// https://github.com/charlesgriffiths/agk-modules/blob/main/juice/spriteroute/spriteroute.agc



// Use a spriteroute when you would like a sprite to be particular places and/or sizes and easily
// jump or tween between them
type tSpriteRouteLocation
  x# as float
  y# as float
  width# as float
  height# as float

  tag$ as string
  easing as integer
endtype


type tSpriteRouteState
  tag$ as string
  sprite as integer
  locations as tSpriteRouteLocation[]

  tween as integer
  tweenseconds# as float
  queue$ as string[]

  bActive as integer
  bVisible as integer
endtype


// initialize a spriteroute
function SpriteRoute_Init( sprite as integer )
sr as tSpriteRouteState

  sr.sprite = CloneSprite( sprite )
  sr.tag$ = "home"
  SpriteRoute_SetAsLocation( sr, sr.tag$, sr.sprite, TweenLinear())

  sr.tween = 0
  sr.tweenseconds# = 0.5
  sr.bActive = 1
  sr.bVisible = 1

endfunction sr


// delete a spriteroute
function SpriteRoute_Delete( sr ref as tSpriteRouteState )

  SpriteRoute_TweenStop( sr )
  if sr.sprite then DeleteSprite( sr.sprite )
  sr.sprite = 0
  sr.locations.length = -1

endfunction


function SpriteRoute_Update( sr ref as tSpriteRouteState )

  if sr.tween
    if not GetTweenSpritePlaying( sr.tween, sr.sprite )
      DeleteTween( sr.tween )
      sr.tween = 0
    endif
  elseif sr.queue$.length > -1
    SpriteRoute_TweenTo( sr, sr.queue$[0], 0 )
    sr.queue$.remove( 0 )
  endif

endfunction


function SpriteRoute_RemoveTag( sr ref as tSpriteRouteState, tag$ as string )

  for i = sr.locations.length to 0 step -1
    if CompareString( tag$, sr.locations[i].tag$ ) then sr.locations.remove( i )
  next i

endfunction


function SpriteRoute_GetTagIndex( sr ref as tSpriteRouteState, tag$ as string )

  for i = 0 to sr.locations.length
    if CompareString( tag$, sr.locations[i].tag$ ) then exitfunction i
  next i

endfunction -1


function SpriteRoute_SetAsLocation( sr ref as tSpriteRouteState, tag$ as string, sprite as integer, easing as integer )
  SpriteRoute_SetLocation( sr, tag$, GetSpriteX( sprite ), GetSpriteY( sprite ), GetSpriteWidth( sprite ), GetSpriteHeight( sprite ), easing )
endfunction


function SpriteRoute_SetLocation( sr ref as tSpriteRouteState, tag$ as string, x# as float, y# as float, width# as float, height# as float, easing as integer )
srl as tSpriteRouteLocation

  srl.x# = x#
  srl.y# = y#
  srl.width# = width#
  srl.height# = height#
  srl.tag$ = tag$
  srl.easing = easing

  SpriteRoute_RemoveTag( sr, tag$ )

  sr.locations.insert( srl )

endfunction


function SpriteRoute_IsTweening( sr ref as tSpriteRouteState )
  playing = GetTweenSpritePlaying( sr.tween, sr.sprite )
endfunction playing


function SpriteRoute_TweenStop( sr ref as tSpriteRouteState )

  if sr.tween
    if GetTweenSpritePlaying( sr.tween, sr.sprite ) then StopTweenSprite( sr.tween, sr.sprite )
    DeleteTween( sr.tween )
    sr.tween = 0
  endif

endfunction


// stop any tweening and move to a location immediately
function SpriteRoute_MoveTo( sr ref as tSpriteRouteState, tag$ as string )

  SpriteRoute_TweenStop( sr )
  index = SpriteRoute_GetTagIndex( sr, tag$ )
  if index > -1
    SetSpritePosition( sr.sprite, sr.locations[index].x#, sr.locations[index].y# )
    SetSpriteSize( sr.sprite, sr.locations[index].width#, sr.locations[index].height# )
    sr.tag$ = tag$
  endif

endfunction


// stop any tweening and tween to a location immediately
function SpriteRoute_TweenTo( sr ref as tSpriteRouteState, tag$ as string, delay# as float )

  SpriteRoute_TweenStop( sr )
  index = SpriteRoute_GetTagIndex( sr, tag$ )
  if index > -1
    sr.tween = CreateTweenSprite( sr.tweenseconds# )
    SetTweenSpriteX( sr.tween, GetSpriteX( sr.sprite ), sr.locations[index].x#, sr.locations[index].easing )
    SetTweenSpriteY( sr.tween, GetSpriteY( sr.sprite ), sr.locations[index].y#, sr.locations[index].easing )
    SetTweenSpriteSizeX( sr.tween, GetSpriteWidth( sr.sprite ), sr.locations[index].width#, sr.locations[index].easing )
    SetTweenSpriteSizeY( sr.tween, GetSpriteHeight( sr.sprite ), sr.locations[index].height#, sr.locations[index].easing )
    PlayTweenSprite( sr.tween, sr.sprite, delay# )
    sr.tag$ = tag$
  endif

endfunction


// tween to a location after any current tweening is done
function SpriteRoute_QueueTo( sr ref as tSpriteRouteState, tag$ as string )
  sr.queue$.insert( tag$ )
endfunction


function SpriteRoute_TweenIn( sr ref as tSpriteRouteState, delay# as float )
  SpriteRoute_TweenTo( sr, "in", delay# )
endfunction


function SpriteRoute_TweenOut( sr ref as tSpriteRouteState, delay# as float )
  SpriteRoute_TweenTo( sr, "out", delay# )
endfunction


function SpriteRoute_TweenHome( sr ref as tSpriteRouteState, delay# as float )
  SpriteRoute_TweenTo( sr, "home", delay# )
endfunction


function SpriteRoute_SetVisible( sr ref as tSpriteRouteState, bVisible as integer )

  sr.bVisible = bVisible
  SetSpriteVisible( sr.sprite, bVisible )

endfunction


function SpriteRoute_DrawBox( sr ref as tSpriteRouteState, tag$ as string, color as integer )

  index = SpriteRoute_GetTagIndex( sr, tag$ )
  if index > -1 then DrawBox( sr.locations[index].x#, sr.locations[index].y#, sr.locations[index].x# + sr.locations[index].width#, sr.locations[index].y# + sr.locations[index].height#, color, color, color, color, 0 )

endfunction

