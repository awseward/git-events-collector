import sequtils
import strutils
import sugar
import times

type Event* = object
  version*: string
  timestamp*: DateTime
  hook*: string
  repo*: string
  `ref`*: string

proc parseUtcISO(input: string): DateTime =
  input.replace("T", " ").replace("Z", "").parse("yyyy-MM-dd HH:mm:ss", utc())

proc fromLine*(line: string): Event =
  let parts = split(line, "\t")
  Event(
    version: parts[0],
    timestamp: parseUtcISO(parts[1]),
    hook: parts[2],
    repo: parts[3],
    `ref`: parts[4]
  )

proc fromFile*(path: string): seq[Event] =
  readFile(path).splitLines.filter(line => line != "").map fromline

# ---

echo fromFile("/Users/andrew/.git-events.log")
