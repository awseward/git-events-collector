import argparse

import ./statics
import ./event_log

# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.
import git_events_collectorpkg/submodule

const AppName = "git_events_collector"

let p = newParser(AppName):
  help "TODO"

  flag("--version", help = "Print the version of " & AppName)
  flag("--revision", help = "Print the Git SHA of " & AppName)
  flag("--info", help = "Print version and revision")

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
