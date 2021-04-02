# Package

version       = "0.3.0"
author        = "Andrew Seward"
description   = "An app for collecting git events"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["git_events_collector"]


# Dependencies

requires "argparse >= 2.0.0"
requires "nim >= 1.4.4"

requires "https://github.com/awseward/nim-junk-drawer#9ff04c5c70b2fe5d24f951f0ff8f408a108ee059"

task pretty, "Run nimpretty on all .nim files in the repo":
  exec "find . -type f -name '*.nim' | xargs -n1 nimpretty --indent:2 --maxLineLen:120"
