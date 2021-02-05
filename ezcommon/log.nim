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
    case kind*: LogDetailKind
    of ldk_text:
      val_text*: string
    of ldk_bool:
      val_bool*: bool
    of ldk_int:
      val_int*: int
    of ldk_uuid:
      val_uuid*: UUID

  LogData* = object
    area*: string
    tags*: seq[string]
    level*: LogLevel
    source*: string
    line*: int
    content*: string
    details*: Table[string, LogDetail]

func `$`*(detail: LogDetail): string =
  case detail.kind:
  of ldk_text:
    detail.val_text
  of ldk_bool:
    $detail.val_bool
  of ldk_int:
    $detail.val_int
  of ldk_uuid:
    $detail.val_uuid

converter toLogDetail*(str: string): LogDetail = LogDetail(kind: ldk_text, val_text: str)
converter toLogDetail*(val: bool): LogDetail = LogDetail(kind: ldk_bool, val_bool: val)
converter toLogDetail*(val: int): LogDetail = LogDetail(kind: ldk_int, val_int: val)
converter toLogDetail*(val: UUID): LogDetail = LogDetail(kind: ldk_uuid, val_uuid: val)

genBinPak(LogData, LogDetail)
