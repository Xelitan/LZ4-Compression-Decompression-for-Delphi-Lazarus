# LZ4-Compression-Decompression-for-Delphi-Lazarus
LZ4 Compression and Decompression for Delphi, Lazarus, Free Pascal

## Usage examples

```
var F,S: TFileStream;
    Size: Integer;
begin
  LZ4_COMPRESSION := 1; //small files but slow
  LZ4_COMPRESSION := 50; //bigger files, faster

  F := TFileStream.Create('input.txt', fmOpenRead);
  S := TFileStream.Create('output.lz4', fmCreate);
  LZ4(F, S);
  Size := F.Size;
  F.Free;
  S.Free;

  F := TFileStream.Create('output.lz4', fmOpenRead);
  S := TFileStream.Create('output.txt', fmCreate);
  UnLZ4(F, S, Size);
  F.Free;
  S.Free;
end;
```

## This unit uses LZ4 library:

LibLZ4.DLL is licensed under a BSD 2-Clause license.
https://github.com/lz4/lz4

## Concatenation

Currently this unit compresses data without buffering. So when you compress a file- a whole file is read into RAM, compressed and then saved to disk.
If you want to compress huge files you should divide them into chunks, compress each chunk and then glue chunks together. Concatenation of LZ4 files is a valid LZ4 file.
