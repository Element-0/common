import std/[hashes, strscans, strformat], binpak

type VersionCode* = distinct uint64

func parseVersionCode*(str: string): VersionCode =
  var a, b, c, d: int
  if str.scanf("$i.$i.$i.$i", a, b, c, d):
    let buint = ((uint64 a and 0xFFFF) shl 48) or ((uint64 b and 0xFFFF) shl 32) or ((uint64 c and 0xFFFF) shl 16) or (uint64 d and 0xFFFF)
    return VersionCode(buint)
  else:
    raise newException(ValueError, "Invalid version code")

func `==`*(a, b: VersionCode): bool {.borrow.}

func `<`*(a, b: VersionCode): bool {.borrow.}
func `<=`*(a, b: VersionCode): bool {.borrow.}

func hash*(a: VersionCode): Hash {.borrow.}

func `$`*(self: VersionCode): string =
  let raw = uint64 self
  let a = uint16 raw shr 48
  let b = uint16 raw shr 32
  let c = uint16 raw shr 16
  let d = uint16 raw
  &"{a}.{b}.{c}.{d}"

func `~>`*(io: BinaryInput, x: var VersionCode) {.inline, borrow.}
func `<~`*(io: BinaryOutput, x: VersionCode) {.inline, borrow.}
