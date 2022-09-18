// File: refa.agc
// Created: 22-09-17
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
// https://github.com/charlesgriffiths/agk-modules/blob/main/other/ref/refa.agc


// Refa allows you to put a pointerlike item inside a tier one type so that data in two different types
// can stay synchronized without having to know anything about one another.

type tRefaValue
  id as integer
  value as integer[]
  value# as float[]
  value$ as string[]
  bDirty as integer
endtype

global gRefaValues as tRefaValue[]

type tRefa
  id as integer
endtype


function Refa_Init()
r as tRefa
rv as tRefaValue

  if -1 = gRefaValues.length
    r.id = 1
  else
    r.id = gRefaValues[gRefaValues.length].id + 1
  endif

  rv.id = r.id
  gRefaValues.insertsorted( rv )

endfunction r


function Refa_Delete( r ref as tRefa )

  index = gRefaValues.find( r.id )
  if index >= 0 then gRefaValues.remove( index )

endfunction


function Refa_DeleteAll()
  gRefaValues.length = -1
endfunction


function Refa_IsDirty( r ref as tRefa )

  index = gRefaValues.find( r.id )
  if index >= 0 then exitfunction gRefaValues[index].bDirty

endfunction 0


function Refa_SetDirty( r ref as tRefa )

  index = gRefaValues.find( r.id )
  if index >= 0 then gRefaValues[index].bDirty = 1

endfunction


function Refa_GetInt( r ref as tRefa, i as integer )

  index = gRefaValues.find( r.id )
  if index >= 0
    gRefaValues[index].bDirty = 0
    if i < 0 or i > gRefaValues[index].value.length then exitfunction 0
    exitfunction gRefaValues[index].value[i]
  endif

endfunction 0

function Refa_SetInt( r ref as tRefa, value as integer, i as integer )

  index = gRefaValues.find( r.id )
  if index >= 0
    gRefaValues[index].bDirty = 1
    if i < 0 then exitfunction
    if i > gRefaValues[index].value.length then gRefaValues[index].value.length = i
    gRefaValues[index].value[i] = value
  endif

endfunction


function Refa_GetFloat( r ref as tRefa, i as integer )

  index = gRefaValues.find( r.id )
  if index >= 0
    gRefaValues[index].bDirty = 0
    if i < 0 or i > gRefaValues[index].value.length then exitfunction 0.0
    exitfunction gRefaValues[index].value#[i]
  endif

endfunction 0.0

function Refa_SetFloat( r ref as tRefa, value# as float, i as integer )

  index = gRefaValues.find( r.id )
  if index >= 0
    gRefaValues[index].bDirty = 1
    if i < 0 then exitfunction
    if i > gRefaValues[index].value#.length then gRefaValues[index].value#.length = i
    gRefaValues[index].value#[i] = value#
  endif

endfunction


function Refa_GetString( r ref as tRefa, i as integer )

  index = gRefaValues.find( r.id )
  if index >= 0
    gRefaValues[index].bDirty = 0
    if i < 0 or i > gRefaValues[index].value$.length then exitfunction ""
    exitfunction gRefaValues[index].value$[i]
  endif

endfunction ""

function Refa_SetString( r ref as tRefa, value$ as string, i as integer )

  index = gRefaValues.find( r.id )
  if index >= 0
    gRefaValues[index].bDirty = 1
    if i < 0 then exitfunction
    if i > gRefaValues[index].value#.length then gRefaValues[index].value$.length = i
    gRefaValues[index].value$[i] = value$
  endif

endfunction


function Refa_ToString( r ref as tRefa )
s$ as string

  index = gRefaValues.find( r.id )
  if index >= 0
    s$ = "refa (" + str(r.id) + ") is "
    if not gRefaValues[index].bDirty then s$ = s$ + "not "
    s$ = s$ + "dirty "
    s$ = s$ + "values("+str(gRefaValues[index].value.length+1)+") ["
    for i = 0 to gRefaValues[index].value.length
      if i then s$ = s$ + ", "
      s$ = s$ + str(gRefaValues[index].value[i])
    next i
    s$ = s$ + "] values#("+str(gRefaValues[index].value#.length+1)+") ["
    for i = 0 to gRefaValues[index].value#.length
      if i then s$ = s$ + ", "
      s$ = s$ + str(gRefaValues[index].value#[i],4)
    next i
    s$ = s$ + "] values$("+str(gRefaValues[index].value$.length+1)+") ["
    for i = 0 to gRefaValues[index].value#.length
      if i then s$ = s$ + ", "
      s$ = s$ + chr(0x22) + gRefaValues[index].value$[i] + chr(0x22)
    next i
  else
    s$ = "No such refa (" + str(r.id) + ")."
  endif

endfunction s$

