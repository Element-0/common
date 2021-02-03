import std/[hashes, strformat], binpak

type UUID* = distinct array[16, byte]

proc `==`*(lhs, rhs: UUID): bool =
  for idx in 0..<16:
    if ((array[16, byte])(lhs))[idx] != ((array[16, byte])(rhs))[idx]:
      return false
  return true

proc hash*(id: UUID): Hash =
  for i in array[16, byte](id):
    result = result !& hash(i)
  result = !$ result

converter valid*(id: UUID): bool =
  for i in array[16, byte](id):
    if i != 0:
      return true
  return false

proc `$`*(id: UUID): string =
  for idx, i in array[16, byte](id):
    case idx:
    of 4, 6, 8, 10:
      result = result & "-"
    else:
      discard
    formatValue(result, i, "02x")

proc parseUUID*(str: string): UUID =
  if str.len != 36:
    raise newException(ValueError, "UUID length mismatch")
  if str[8] != '-' or str[13] != '-' or str[18] != '-' or str[23] != '-':
    raise newException(ValueError, "Invalid UUID format")
  var even = false
  var tmp: byte
  var count = 0
  var ret: array[16, byte]
  for ch in str:
    let imm = case ch:
    of '-': continue
    of '0'..'9': byte(ord(ch) - ord('0'))
    of 'a'..'f': byte(ord(ch) - ord('a') + 10)
    of 'A'..'F': byte(ord(ch) - ord('A') + 10)
    else: raise newException(ValueError, "invalid character " & $ch)
    if even:
      ret[count] = (tmp shl 4) + imm
      count += 1
      tmp = 0
      even = false
    else:
      tmp = imm
      even = true
  return UUID(ret)

func `~>`*(io: BinaryInput, x: var UUID) {.inline.} =
  for i in 0..<16:
    io ~> array[16, byte](x)[i]
func `<~`*(io: BinaryOutput, x: UUID) {.inline.} =
  for i in 0..<16:
    io <~ array[16, byte](x)[i]
