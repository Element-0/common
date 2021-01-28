import std/tables, binpak, ./uuid

type
  LogLevel* {.pure.} = enum
    lvl_notice
    lvl_info
    lvl_debug
    lvl_warn
    lvl_error

  LogDetailKind* {.pure.} = enum
    ldk_text
    ldk_bool
    ldk_int
    ldk_uuid

  LogDetail* = object
    case kind: LogDetailKind
    of ldk_text:
      val_text: string
    of ldk_bool:
      val_bool: bool
    of ldk_int:
      val_int: int
    of ldk_uuid:
      val_uuid: UUID

  LogData* = object
    level: LogLevel
    area: string
    details: Table[string, LogDetail]

genBinPak(LogData, LogDetail)
