import argparse
import strformat
import sugar
import system

import ./statics

import git_events_collectorpkg/submodule

const AppName = "git_events_collector"

let p = newParser(AppName):
  help "TODO"

  flag "--version", help = "Print the version of " & AppName
  flag "--revision", help = "Print the Git SHA of " & AppName
  flag "--info", help = "Print version and revision"

  command "mvp":
    arg "src", help = "Filepath of the source TSV input file"
    arg "dest", help = "Filepath of the destination SQLite file"

    run:
      let tsvFile = expandTilde opts.src
      let sqliteFile = expandTilde opts.dest

      let db_open = () => open_sqlite sqliteFile

      db_open.dbSetup

      for e in fromFile(tsvFile):
        db_open.loadDb e

      echo sqliteFile

  run:
    if opts.version:
      echo pkgVersion
    elif opts.revision:
      echo pkgRevision
    elif opts.info:
      echo "version:  ", pkgVersion
      echo "revision: ", pkgRevision
    elif commandLineParams().len == 0:
      echo "Pass `-h` or `--help` for usage info."

p.run
