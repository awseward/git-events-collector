import sequtils
import strutils
import times

type Event* = object
  version*: string
  timestamp*: string # TODO: Maybe try making this an actual DateTime
  hook*: string
  repo*: string
  `ref`*: string

proc fromLine*(line: string): Event =
  let parts = split(line, "\t")
  echo parts
  Event(
    version: parts[0],
    timestamp: parts[1],
    hook: parts[2],
    repo: parts[3],
    `ref`: parts[4]
  )

proc fromFile*(path: string): seq[Event] =
  readFile(path).splitLines.map fromline

# ---

echo fromFile("/Users/andrew/.git-events.log")

# let line = "0.1.0\t2020-11-26T08:23:09Z\t/Users/andrew/.git-hooks/pre-push\t/Users/andrew/projects/nim/git-events-collector\tmaster"

# let event = fromLine line
# echo ""
# echo event
