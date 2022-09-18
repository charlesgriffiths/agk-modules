// File: ref.agc
// Created: 22-09-15
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
// https://github.com/charlesgriffiths/agk-modules/blob/main/other/ref/ref.agc



// Ref allows you to put a pointerlike item inside a tier one type so that data in two different types
// can stay synchronized without having to know anything about one another.

type tRefValue
  id as integer
  value as integer
  value# as float
  value$ as string
  bDirty as integer
endtype

global gRefValues as tRefValue[]

type tRef
  id as integer
endtype


function Ref_Init()
r as tRef
rv as tRefValue

  if -1 = gRefValues.length
    r.id = 1
  else
    r.id = gRefValues[gRefValues.length].id + 1
  endif

  rv.id = r.id
  gRefValues.insertsorted( rv )

endfunction r


function Ref_Delete( r ref as tRef )

  index = gRefValues.find( r.id )
  if index >= 0 then gRefValues.remove( index )

endfunction


function Ref_DeleteAll()
  gRefValues.length = -1
endfunction


function Ref_IsDirty( r ref as tRef )

  index = gRefValues.find( r.id )
  if index >= 0 then exitfunction gRefValues[index].bDirty

endfunction 0


function Ref_SetDirty( r ref as tRef )

  index = gRefValues.find( r.id )
  if index >= 0 then gRefValues[index].bDirty = 1

endfunction


function Ref_GetInt( r ref as tRef )

  index = gRefValues.find( r.id )
  if index >= 0
    gRefValues[index].bDirty = 0
    exitfunction gRefValues[index].value
  endif

endfunction 0

function Ref_SetInt( r ref as tRef, value as integer )

  index = gRefValues.find( r.id )
  if index >= 0
    gRefValues[index].bDirty = 1
    gRefValues[index].value = value
  endif

endfunction


function Ref_GetFloat( r ref as tRef )

  index = gRefValues.find( r.id )
  if index >= 0
    gRefValues[index].bDirty = 0
    exitfunction gRefValues[index].value#
  endif

endfunction 0.0

function Ref_SetFloat( r ref as tRef, value# as float )

  index = gRefValues.find( r.id )
  if index >= 0
    gRefValues[index].bDirty = 1
    gRefValues[index].value# = value#
  endif

endfunction


function Ref_GetString( r ref as tRef )

  index = gRefValues.find( r.id )
  if index >= 0
    gRefValues[index].bDirty = 0
    exitfunction gRefValues[index].value$
  endif

endfunction ""

function Ref_SetString( r ref as tRef, value$ as string )

  index = gRefValues.find( r.id )
  if index >= 0
    gRefValues[index].bDirty = 1
    gRefValues[index].value$ = value$
  endif

endfunction


function Ref_ToString( r ref as tRef )
s$ as string

  index = gRefValues.find( r.id )
  if index >= 0
    s$ = "ref (" + str(r.id) + ") is "
    if not gRefValues[index].bDirty then s$ = s$ + "not "
    s$ = s$ + "dirty " + str(gRefValues[index].value) + " " + str(gRefValues[index].value#) + " " + chr(0x22) + gRefValues[index].value$ + chr(0x22)
  else
    s$ = "No such ref (" + str(r.id) + ")."
  endif

endfunction s$

