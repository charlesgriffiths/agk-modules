// File: profile.agc
// Created: 22-06-27
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
// https://github.com/charlesgriffiths/agk-modules/blob/main/other/profile/profile.agc


// Use with the shared variable modification at https://forum.thegamecreators.com/thread/228569

// A profile is a list of entries
// Each entry has a unique id, name, and list of key:data pairs
// Keeping names unique is a good idea, but not enforced
// The whole may be used to store a list of players with their savegame data
//   or a list of map locations with their current status (treasure, npcs, or other mutable features)
// With every change, the functions in this module write a file or shared variable with a name that is
//   a combination of prefix$, id, and an index of keys$ so that names and keys do not appear in the
//   names of files or shared variables.


type tProfileEntry
  id as integer
  name$ as string
  keys$ as string[]
endtype

type tProfileState
  prefix$ as string
  list as tProfileEntry[]
  selectid as integer
endtype


// initialize a profile instance, reading the saved state from persistent storage if possible
function Profile_Init( prefix$ as string )
p as tProfileState

  data$ = Profile_ReadString( prefix$ )
  if len(data$) then p.fromJSON( data$ )

  p.prefix$ = prefix$

endfunction p


// frees memory used by profile, does not delete files or free localstorage
function Profile_Delete( p ref as tProfileState )

  p.prefix$ = ""
  p.list.length = -1

endfunction

// deletes files/frees localstorage
function Profile_Destroy( p ref as tProfileState )

  for i = p.list.length to 0 step -1
    Profile_Remove( p, p.list[i].id )
  next i

endfunction


// set the current id, many module operations use the currently selected entry
function Profile_SetSelectID( p ref as tProfileState, id as integer )

  p.selectid = id
  Profile_WriteString( p.prefix$, p.toJSON())

endfunction


// get the name for the current id
function Profile_GetName( p ref as tProfileState )

  index = p.list.find( p.selectid )
  if -1 = index then exitfunction ""

endfunction p.list[index].name$


// set the name for the current id
function Profile_SetName( p ref as tProfileState, name$ as string )

  index = p.list.find( p.selectid )
  if -1 = index then exitfunction 0

  p.list[index].name$ = name$
  Profile_WriteString( p.prefix$, p.toJSON())

endfunction 1


// add or find a key in the current id and return the key's index
function Profile_AddKey( p ref as tProfileState, key$ as string )
keyindex as integer = -1
emptyindex as integer = -1

  index = p.list.find( p.selectid )
  if -1 = index then exitfunction -1

  for i = 0 to p.list[index].keys$.length
    if CompareString( key$, p.list[index].keys$[i] )
      keyindex = i
      exit
    elseif -1 = emptyindex and not len( p.list[index].keys$[i] )
      emptyindex = i
    endif
  next i

  if -1 = keyindex and -1 <> emptyindex
    keyindex = emptyindex
    p.list[index].keys$[keyindex] = key$
    Profile_WriteString( p.prefix$, p.toJSON())
  endif

  if -1 = keyindex
    p.list[index].keys$.insert( key$ )
    keyindex = p.list[index].keys$.length
    Profile_WriteString( p.prefix$, p.toJSON())
  endif

endfunction keyindex


// get a list of keys for the current id
function Profile_GetKeys( p ref as tProfileState, keys$ ref as string[] )

  keys$.length = -1

  index = p.list.find( p.selectid )
  if -1 = index then exitfunction 0

  for i = 0 to p.list[index].keys$.length
    if len( p.list[index].keys$[i] ) then keys$.insert( p.list[index].keys$[i] )
  next i

endfunction 1


// remove a key from the current id
function Profile_RemoveKey( p ref as tProfileState, key$ as string )

  index = p.list.find( p.selectid )
  if -1 = index then exitfunction 0

  for i = 0 to p.list[index].keys$.length
    if CompareString( key$, p.list[index].keys$[i] )
      Profile_DeleteString( p.prefix$ + str( p.selectid ) + "_" + str( i ))
      p.list[index].keys$[i] = ""
      Profile_WriteString( p.prefix$, p.toJSON())

      exitfunction 1
    endif
  next i

endfunction 0


// set a key:data pair in the current id
function Profile_SetData( p ref as tProfileState, key$ as string, data$ as string )

  keyindex = Profile_AddKey( p, key$ )
  if -1 = keyindex then exitfunction 0

  index = p.list.find( p.selectid )
  if -1 = index then exitfunction 0

  Profile_WriteString( p.prefix$ + str( p.selectid ) + "_" + str( keyindex ), data$ )

endfunction 1


// look up key$ in the current id and return its data
function Profile_GetData( p ref as tProfileState, key$ as string )
keyindex as integer = -1
data$ as string = ""

  index = p.list.find( p.selectid )
  if -1 = index then exitfunction ""

  for i = 0 to p.list[index].keys$.length
    if CompareString( key$, p.list[index].keys$[i] )
      keyindex = i
      exit
    endif
  next i

  if -1 = keyindex
    data$ = ""
  else
    data$ = Profile_ReadString( p.prefix$ + str( p.selectid ) + "_" + str( keyindex ))
  endif

endfunction data$


// return 0 if the id is not found
function Profile_HasID( p ref as tProfileState, id as integer )
  exitfunction 1 + p.list.find( id )
endfunction 0


// returns the first id with a matching name
function Profile_GetID( p ref as tProfileState, name$ as string )

  for i = 0 to p.list.length
    if CompareString( name$, p.list[i].name$ ) then exitfunction p.list[i].id
  next i

endfunction 0


// remove this id and all associated key:data pairs
function Profile_Remove( p ref as tProfileState, id as integer )

  index = p.list.find( id )
  if -1 <> index
    for i = 0 to p.list[index].keys$.length
      Profile_DeleteString( p.prefix$ + str( id ) + "_" + str( i ))
    next i
    p.list.remove( index )
    Profile_WriteString( p.prefix$, p.toJSON())

    exitfunction 1
  endif

endfunction 0


// add a new name to the profile list, set the new id as current, and return the new id
function Profile_Add( p ref as tProfileState, name$ as string )
id as integer = 0

  do
    inc id
    if not Profile_HasID( p, id )
    pe as tProfileEntry

      pe.id = id
      pe.name$ = name$

      p.list.insertsorted( pe )
      Profile_SetSelectID( p, id )
      exitfunction id
    endif
  loop

endfunction 0



function Profile_ReadString( name$ as string )
data$ as string

  if CompareString( "html5", GetDeviceBaseName())  // use shared variable
    data$ = LoadSharedVariable( "_ls" + name$, "" )  // _ls = localStorage
  elseif GetFileExists( name$ )                    // use file
    id = OpenToRead( name$ )
    data$ = ReadString( id )
    CloseFile( id )
  endif

endfunction data$


function Profile_WriteString( name$ as string, data$ as string )

  if not len( data$ )
    Profile_DeleteString( name$ )
    exitfunction
  endif

  if CompareString( "html5", GetDeviceBaseName())  // use shared variable
    SaveSharedVariable( "_ls" + name$, data$ )  // _ls = localStorage
  else                                             // use file
    id = OpenToWrite( name$, 0 )
    WriteString( id, data$ )
    CloseFile( id )
  endif

endfunction


function Profile_DeleteString( name$ as string )

  if CompareString( "html5", GetDeviceBaseName())  // use shared variable
    DeleteSharedVariable( "_ls" + name$ )  // _ls = localStorage
  elseif GetFileExists( name$ )                    // use file
    DeleteFile( name$ )
  endif

endfunction

