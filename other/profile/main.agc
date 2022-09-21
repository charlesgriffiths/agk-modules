// Project: profile 
// Created: 22-06-27

#include "profile.agc"


// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "profile" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

prefix$ as string = "profile_"

p as tProfileState

  p = Profile_Init( prefix$ )

//  Profile_Destroy( p )
//  p = Profile_Init( prefix$ )


names$ as string[]

  for i = 1 to 11
    names$.insert( "Test Profile Name #" + str(i))
  next i

  if p.list.length < 0
    for i = 0 to names$.length
      if not Profile_GetID( p, names$[i] ) then Profile_Add( p, names$[i] )
    next i

    for i = 0 to 100
      index = Random( 0, names$.length )
      id = Profile_GetID( p, names$[index] )
      Profile_SetSelectID( p, id )
     key = Random( 0, 4 )
      data = Random( 0, 100 )
      Profile_SetData( p, "key #" + str(key), "data #" + str(data) + " for key #" + str(key))
    next i
  endif

  Profile_Delete( p )

folder$ as string
writepath$ as string

  folder$ = GetFolder()
  writepath$ = GetWritePath()

  p = Profile_Init( prefix$ )

  ResetTimer()

action$ as string = "initialize profile"
result$ as string 
keys$ as string[]

  result$ = "profile initialized with " + str(p.list.length + 1) + " names."

  do
    print( "folder: " + folder$ )
    print( "writepath: " + writepath$ )
    
    print( "action: " + action$ )
    print( "result: " + result$ )

    if Timer() > 5
      ResetTimer()
      select Random( 0, 8 )
        case 0:
          action$ = "initialize profile"
          Profile_Delete( p )
          p = Profile_Init( prefix$ )
          result$ = "profile initialized with " + str(p.list.length + 1) + " names."
          for i = 0 to p.list.length
            result$ = result$ + " " + str( p.list[i].id )
          next i
        endcase

        case 1:
          name$ = names$[Random( 0, names$.length )]
          action$ = "set current name to: " + name$
          id = Profile_GetID( p, name$ )
          Profile_SetSelectID( p, id )
          if not id
            result$ = "that name was not found, id is 0"
          else
            Profile_GetKeys( p, keys$ )
            result$ = "id is " + str(id) + " with " + str( keys$.length+1 ) + " keys."
          endif
        endcase

        case 2:
          Profile_GetKeys( p, keys$ )
          if keys$.length > -1
            key$ = keys$[Random( 0, keys$.length )]
            action$ = "getting data for key: " + key$ + " id is " + str( p.selectid )
            data$ = Profile_GetData( p, key$ )
            result$ = "data is: " + data$
          endif
        endcase

        case 3:
          if keys$.length > -1
            key$ = keys$[Random( 0, keys$.length )]
            action$ = "deleting key: " + key$
            result = Profile_RemoveKey( p, key$ )
            result$ = "RemoveKey() returned: " + str(result)
          endif
        endcase

        case 4:
          name$ = names$[Random( 0, names$.length )]
          id = Profile_GetID( p, name$ )
          action$ = "deleting name: " + name$ + "   id " + str(id)
          Profile_Remove( p, id )
          if not id
            result$ = "the name was not present"
          else
            id = Profile_GetID( p, name$ )
            result$ = "name removed, now id " + str(id)
          endif
        endcase

        case 5:
          index = Random( 0, 10 )
          id = Profile_GetID( p, names$[index] )
          action$ = "adding a key to " + names$[index] + "   id " + str(id)
          Profile_SetSelectID( p, id )
          key = Random( 0, 4 )
          data = Random( 0, 100 )
          result = Profile_SetData( p, "key #" + str(key), "data #" + str(data) + " for key #" + str(key))
          result$ = "SetData() returned: " + str(result)
          if not result and not id then result$ = result$ + " the name was not present"
        endcase

        case 6:
          index = Random( 0, names$.length )
          action$ = "adding name " + names$[index]
          if not Profile_GetID( p, names$[index] )
            result = Profile_Add( p, names$[index] )
            result$ = "Add() returned: " + str(result)
          else
            result$ = "that name was already present"
          endif
        endcase

        case 7:
          Profile_GetKeys( p, keys$ )
          action$ = "getting keys for id " + str( p.selectid )
          result$ = str(keys$.length+1) + " keys:"
          for i = 0 to keys$.length
            result$ = result$ + " " + keys$[i] + ","
          next i
        endcase

        case 8:
          if not p.selectid and p.list.length > -1 then Profile_SetSelectID( p, p.list[Random( 0, p.list.length )].id )
          if p.selectid
            action$ = "adding 5 random keys to " + Profile_GetName( p )
            Profile_GetKeys( p, keys$ )
            count = keys$.length + 1
            for i = 1 to 5
              key = Random( 0, 10 )
              data = Random( 0, 1000 )
              Profile_SetData( p, "key #" + str(key), "data #" + str(data) + " for key #" + str(key))
            next i
            Profile_GetKeys( p, keys$ )
            result$ = "key count was changed from " + str(count) + " to " + str(keys$.length + 1)
          endif
        endcase


      endselect
    endif

    Print( str(5-Timer(),1) )
    Sync()
  loop

