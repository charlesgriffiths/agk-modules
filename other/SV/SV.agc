// File: SV.agc
// Created: 22-07-30
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
// https://github.com/charlesgriffiths/agk-modules/blob/main/other/SV/SV.agc


// This module simplifies the interface to the Shared Variable patch


type tSVFile
  filename as string
  datatype as string
  conversiontype as string
  width as integer
  height as integer
  bytes as integer[]
endtype


type tSV
  extension$ as string
  filename$ as string
  text$ as string
  file as tSVFile
endtype


function SV_Init()
sv as tSV
  sv.text$ = LoadSharedVariable( "_init", "" )
endfunction sv


function SV_GetArgs( sv ref as tSV )
  exitfunction LoadSharedVariable( "args", "" )
endfunction ""


function SV_FullScreen( sv ref as tSV )
  SaveSharedVariable( "_fullscreen", "" )
endfunction


function SV_SaveLocalStorage( sv ref as tSV, variable$ as string, value$ as string )
  SaveSharedVariable( "_ls"+variable$, value$ )
endfunction


function SV_LoadLocalStorage( sv ref as tSV, variable$ as string )
  exitfunction LoadSharedVariable( "_ls"+variable$, "" )
endfunction ""


function SV_DeleteLocalStorage( sv ref as tSV, variable$ as string )
  DeleteSharedVariable( "_ls"+variable$ )
endfunction


function SV_CopyToClipboard( sv ref as tSV, text$ as string )
  SaveSharedVariable( "_clipboard", text$ )
endfunction


// you probably don't have permission
function SV_RequestPasteFromClipboard( sv ref as tSV )
  exitfunction LoadSharedVariable( "_clipboard", "" )
endfunction ""


function SV_GetClipboardData( sv ref as tSV )

  sv.text$ = LoadSharedVariable( "_ssclipboard", "" )
  if len(sv.text$) then exitfunction 1

endfunction 0


function SV_OpenTextFile( sv ref as tSV )
  SV_OpenTextFileType( sv, ".txt" )
endfunction


function SV_OpenTextFileType( sv ref as tSV, extension$ as string )

  sv.extension$ = extension$
  sv.filename$ = ""
  sv.text$ = ""
  SaveSharedVariable( "_fr", extension$ )

endfunction


function SV_ReadTextFile( sv ref as tSV )

  sv.filename$ = LoadSharedVariable( "_sstextfilename", "" )
  if not len(sv.filename$) then exitfunction 0
  sv.text$ = LoadSharedVariable( "_fr", "" )
  DeleteSharedVariable( "_f" )

endfunction 1


function SV_DownloadTextFile( sv ref as tSV, filename$ as string, text$ as string )
  SaveSharedVariable( "_fd" + filename$, text$ )
endfunction


function SV_OpenBinaryFile( sv ref as tSV )
  SV_OpenBinaryFileType( sv, ".*" )
endfunction


function SV_OpenBinaryFileType( sv ref as tSV, extension$ as string )

  sv.extension$ = extension$
  sv.filename$ = ""
  SaveSharedVariable( "_frb", ".*" )

endfunction


function SV_ReadBinaryFile( sv ref as tSV )

  sv.filename$ = LoadSharedVariable( "_ssbinaryfilename", "" )
  if not len(sv.filename$) then exitfunction 0
  s$ = LoadSharedVariable( "_frb", "" )
  if len(s$)
    sv.file.bytes.fromJSON( s$ )
  endif
  DeleteSharedVariable( "_f" )

endfunction 1


function SV_DownloadBinaryFile( sv ref as tSV, filename$ as string, memblock as integer )

  sv.file.filename = filename$
  sv.file.datatype = ""
  sv.file.conversiontype = ""
  sv.file.bytes.length = GetMemblockSize( memblock ) - 1

  for i = 0 to sv.file.bytes.length
    sv.file.bytes[i] = GetMemblockByte( memblock, i )
  next i

  SaveSharedVariable( "_fj", sv.file.toJSON() )

endfunction


function SV_DownloadImage( sv ref as tSV, filename$ as string, image as integer, datatype$ as string, conversiontype$ as string )

  sv.file.width = GetImageWidth( image )
  sv.file.height = GetImageHeight( image )
  mb = CreateMemblockFromImage( image )
  sv.file.filename = filename$
  sv.file.datatype = datatype$
  sv.file.conversiontype = conversiontype$
  sv.file.bytes.length = GetMemblockSize( mb ) - 1

  for i = 0 to sv.file.bytes.length
    sv.file.bytes[i] = GetMemblockByte( mb, i )
  next i

  SaveSharedVariable( "_fj", sv.file.toJSON() )
  DeleteMemblock( mb )

endfunction


function SV_DownloadImageRaw( sv ref as tSV, filename$ as string, image as integer )
  SV_DownloadImage( sv, filename$, image, "imagedata", "imagedata" )
endfunction


function SV_DownloadImagePng( sv ref as tSV, filename$ as string, image as integer )
  SV_DownloadImage( sv, filename$, image, "imagedata", "image/png" )
endfunction


function SV_DownloadImageJpg( sv ref as tSV, filename$ as string, image as integer )
  SV_DownloadImage( sv, filename$, image, "imagedata", "image/jpg" )
endfunction


function SV_ConvertImageJpg( sv ref as tSV )

  sv.filename$ = LoadSharedVariable( "_ssbinaryfilename", "" )
  if not len(sv.filename$) then exitfunction 0

  sv.file.datatype = "image/jpg"
  sv.file.conversiontype = "imagedata"
  sv.file.bytes.length = -1

  LoadSharedVariable( "_fj", sv.file.toJSON() )

endfunction 1


function SV_ConvertImagePng( sv ref as tSV )

  sv.filename$ = LoadSharedVariable( "_ssbinaryfilename", "" )
  if not len(sv.filename$) then exitfunction 0

  sv.file.datatype = "image/png"
  sv.file.conversiontype = "imagedata"
  sv.file.bytes.length = -1

  LoadSharedVariable( "_fj", sv.file.toJSON() )

endfunction 1


function SV_GetImage( sv ref as tSV )

  text$ = LoadSharedVariable( "_fj", "" )
  if not len(text$) then exitfunction 0

  sv.file.bytes.fromJSON( text$ )
  mb = CreateMemblock( 12 + sv.file.bytes.length )
  SetMemblockInt( mb, 0, sv.file.bytes[0] )
  SetMemblockInt( mb, 4, sv.file.bytes.length/(4*sv.file.bytes[0]) )
  SetMemblockInt( mb, 8, 32 )

  for i = 1 to sv.file.bytes.length
    SetMemblockByte( mb, 11 + i, sv.file.bytes[i] )
  next i

  image = CreateImageFromMemblock( mb )

  DeleteMemblock( mb )
  DeleteSharedVariable( "_fj" )

endfunction image

