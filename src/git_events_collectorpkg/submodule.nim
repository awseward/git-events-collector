import db_sqlite
import sequtils
import strutils
import sugar
import times

import junk_drawer/db

type Event* = object
  version*: string
  timestamp*: DateTime
  hook*: string
  repo*: string
  `ref`*: string

proc parseUtcISO(input: string): DateTime =
  input.replace("T", " ").replace("Z", "").parse("yyyy-MM-dd HH:mm:ss", utc())

proc fromLine(line: string): Event =
  let parts = split(line, "\t")
  Event(
    version: parts[0],
    timestamp: parseUtcISO(parts[1]),
    hook: parts[2],
    repo: parts[3],
    `ref`: parts[4]
  )

proc fromFile*(path: string): seq[Event] =
  readFile(path)
    .splitLines
    .filter(line => line != "")
    .map fromline

proc open_sqlite*(filepath: string): DbConn =
  db_sqlite.open(filepath, "", "", "")

proc dbSetup*(db_open: (proc: DbConn)) =
  let query = sql """
    CREATE TABLE IF NOT EXISTS events (
      version   TEXT NOT NULL,
      timestamp DATETIME NOT NULL,
      hook      TEXT NOT NULL,
      repo      TEXT NOT NULL,
      ref       TEXT NOT NULL
    )"""
  # echo query.string
  db_open.use conn: conn.exec query

proc loadDb*(db_open: (proc: DbConn), event: Event) =
  let query = sql """
    INSERT INTO events (version, timestamp, hook, repo, ref)
      VALUES (?, ?, ?, ?, ?)
  """
  # echo query.string
  db_open.use conn:
    conn.exec(query,
      event.version,
      $event.timestamp,
      event.hook,
      event.repo,
      event.`ref`
    )
