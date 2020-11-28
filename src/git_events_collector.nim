import argparse
import sugar

import ./statics

import git_events_collectorpkg/submodule

const AppName = "git_events_collector"

let p = newParser(AppName):
  help "TODO"

  flag("--version", help = "Print the version of " & AppName)
  flag("--revision", help = "Print the Git SHA of " & AppName)
  flag("--info", help = "Print version and revision")

  command "mvp":
    run:
      const log_filepath    = expandTilde "~/.git-events.log"
      const sqlite_filepath = expandTilde "~/.git-events-collector.db"
      const db_open = () => open_sqlite sqlite_filepath

      db_open.dbSetup

      for e in fromFile(logFilepath):
        db_open.loadDb e

      echo sqlite_filepath

  run:
    if opts.version:
      echo pkgVersion
    elif opts.revision:
      echo pkgRevision
    elif opts.info:
      echo "version:  ", pkgVersion
      echo "revision: ", pkgRevision
    elif commandLineParams().len == 0:
      echo p.help

p.run
