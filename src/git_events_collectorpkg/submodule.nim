import db_sqlite
import options
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
  remote*: Option[string]
  propsJSON*: string

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
    remote:
      if version == "0.1.0" or parts[5] == "":
        none string
      else:
        some parts[5]
    ,
    propsJSON:
      # Yikes this is awful but I really don't want to spend any time on this
      # part of things right now…
      if (version == "0.1.0" or version == "0.1.1" or version == "0.1.2"):
        "{}"
      else:
        parts[6]
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
      remote    TEXT,
      props     TEXT NOT NULL
    )"""
  # echo query.string
  db_open.use conn: conn.exec query

proc loadDb*(db_open: (proc: DbConn), event: Event) =
  if event.remote.isSome:
    let query =
      sql """
        INSERT INTO events
                 (version, timestamp, hook, repo, ref, remote, props)
          VALUES (      ?,         ?,    ?,    ?,   ?,      ?,     ?)
      """
    db_open.use conn:
      conn.exec(query,
        event.version,
        $event.timestamp,
        event.hook,
        event.repo,
        event.`ref`,
        event.remote.get,
        event.propsJSON
      )
  else:
    let query =
      sql """
        INSERT INTO events
                 (version, timestamp, hook, repo, ref, remote, props)
          VALUES (      ?,         ?,    ?,    ?,   ?,   NULL,     ?)
      """
    db_open.use conn:
      conn.exec(query,
        event.version,
        $event.timestamp,
        event.hook,
        event.repo,
        event.`ref`,
        event.propsJSON
      )
