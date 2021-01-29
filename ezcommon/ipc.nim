import binpak, ./log

type
  RequestKind* {.pure.} = enum
    req_ping
    req_log
    req_load
    req_bye

  RequestPacket* = object
    case kind*: RequestKind
    of req_ping:
      discard
    of req_log:
      logData*: LogData
    of req_load:
      modName*: string
    of req_bye:
      discard

  ResponseKind* {.pure.} = enum
    res_pong
    res_failed
    res_load

  ResponsePacket* = object
    case kind*: ResponseKind
    of res_pong:
      discard
    of res_failed:
      errMsg*: string
    of res_load:
      modPath*: string

converter toRequestPacket*(log: LogData): RequestPacket =
  RequestPacket(kind: req_log, logData: log)

genBinPak(RequestPacket, ResponsePacket)
