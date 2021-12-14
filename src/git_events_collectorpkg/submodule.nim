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
  remote*: string

proc parseUtcISO(input: string): DateTime =
  input.replace("T", " ").replace("Z", "").parse("yyyy-MM-dd HH:mm:ss", utc())

proc fromLine(line: string): Event =
  let parts = split(line, "\t")
  let version = parts[0]
  Event(
    version: version,
    timestamp: parseUtcISO(parts[1]),
    hook: parts[2],
    repo: parts[3],
    `ref`: parts[4],
    remote: (
      if version == "0.1.0":
        ""
      else:
        parts[5]
    )
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
      ref       TEXT NOT NULL,
      -- Added `remote` in 0.1.1; locations which haven't upgraded won't be writing this yet
      remote    TEXT
    )"""
  # echo query.string
  db_open.use conn: conn.exec query

proc loadDb*(db_open: (proc: DbConn), event: Event) =
  let query = sql """
    INSERT INTO events
             (version, timestamp, hook, repo, ref, remote)
      VALUES (      ?,         ?,    ?,    ?,   ?,      ?)
  """
  # echo query.string
  db_open.use conn:
    conn.exec(query,
      event.version,
      $event.timestamp,
      event.hook,
      event.repo,
      event.`ref`,
      event.remote
    )
