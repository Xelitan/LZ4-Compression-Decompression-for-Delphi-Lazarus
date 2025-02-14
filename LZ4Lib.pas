unit LZ4Lib;

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// Description:	LZ4 compressor and decompressor                               //
// Version:	0.1                                                           //
// Date:	15-FEB-2025                                                   //
// License:     MIT                                                           //
// Target:	Win64, Free Pascal, Delphi                                    //
// Copyright:	(c) 2025 Xelitan.com.                                         //
//		All rights reserved.                                          //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

interface

uses
  Classes, SysUtils, Dialogs;

  var LZ4_COMPRESSION: Integer = 1;

  const LZ4_LIB = 'liblz4.dll';

  function LZ4_compressBound(inputSize: Integer): Integer; cdecl; external LZ4_LIB;
  function LZ4_compress_default(const src: PByte; dst: PByte; srcSize: Integer; dstCapacity: Integer): Integer; cdecl; external LZ4_LIB;
  function LZ4_compress_fast(src: PByte; dst: PByte; srcSize: Integer; dstCapacity: Integer; acceleration: Integer): Integer; cdecl; external LZ4_LIB;
  function LZ4_decompress_safe(const src: PByte; dst: PByte; compressedSize: Integer; dstCapacity: Integer): Integer; cdecl; external LZ4_LIB;

  //Functions
  function LZ4(Data: PByte; DataLen: Integer; var OutData: TBytes): Boolean; overload;
  function UnLZ4(Data: PByte; DataLen: Integer; var OutData: TBytes; OutDataLen: Integer): Boolean; overload;

  function LZ4(InStr, OutStr: TStream): Boolean; overload;
  function UnLZ4(InStr, OutStr: TStream; OutDataLen: Integer): Boolean; overload;

  function LZ4(Str: String): String; overload;
  function UnLZ4(Str: String; OutDataLen: Integer): String; overload;

implementation

function LZ4(Data: PByte; DataLen: Integer; var OutData: TBytes): Boolean;
var OutLen: Integer;
begin
  OutLen := LZ4_compressBound(DataLen);
  SetLength(OutData, OutLen);

  //OutLen := LZ4_compress_default(Data, @OutData[0], DataLen, OutLen);
  OutLen := LZ4_compress_fast(Data, @OutData[0], DataLen, OutLen, LZ4_COMPRESSION);

  if OutLen = 0 then Exit(False);

  SetLength(OutData, OutLen);
  SetLength(OutData, OutLen);

  Result := True;
end;

function UnLZ4(Data: PByte; DataLen: Integer; var OutData: TBytes; OutDataLen: Integer): Boolean;
begin
  SetLength(OutData, OutDataLen);
  OutDataLen := LZ4_decompress_safe(Data, @OutData[0], DataLen, OutDataLen);

  if OutDataLen <= 0 then Exit(False);
  SetLength(OutData, OutDataLen);

  Result := True;
end;

function UnLZ4(Str: String; OutDataLen: Integer): String;
var Res: Boolean;
    OutLen: Integer;
    OutData: TBytes;
begin
  Res := UnLZ4(@Str[1], Length(Str), OutData, OutDataLen);
  if not Res then Exit('');

  OutLen := Length(OutData);
  SetLength(Result, OutLen);
  Move(OutData[0], Result[1], OutLen);
end;

function LZ4(InStr, OutStr: TStream): Boolean;
var Buf: array of Byte;
    Size: Integer;
    OutData: TBytes;
begin
  Result := False;
  try
    Size := InStr.Size - InStr.Position;
    SetLength(Buf, Size);
    InStr.Read(Buf[0], Size);

    if not LZ4(@Buf[0], Size, OutData) then Exit;

    OutStr.Write(OutData[0], Length(OutData));
    Result := True;
  finally
  end;
end;

function UnLZ4(InStr, OutStr: TStream; OutDataLen: Integer): Boolean;
var Buf: array of Byte;
    Size: Integer;
    OutData: TBytes;
begin
  Result := False;
  try
    Size := InStr.Size - InStr.Position;
    SetLength(Buf, Size);
    InStr.Read(Buf[0], Size);

    if not UnLZ4(@Buf[0], Size, OutData, OutDataLen) then Exit;

    OutStr.Write(OutData[0], Length(OutData));
    Result := True;
  finally
  end;
end;

function LZ4(Str: String): String;
var Res: Boolean;
    OutLen: Integer;
    OutData: TBytes;
begin
  Res := LZ4(@Str[1], Length(Str), OutData);
  if not Res then Exit('');

  OutLen := Length(OutData);
  SetLength(Result, OutLen);
  Move(OutData[0], Result[1], OutLen);
end;

end.
