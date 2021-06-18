let imports = ./imports.dhall

let versions = { dhall = "1.39.0", nim = "1.4.4" }

in  { defaultBranch = "main"
    , homebrew =
      { formula-name = "git_events_collector"
      , homebrew-tap = "awseward/homebrew-tap"
      }
    , nimSetup =
        let J_ = imports.job-templates.nim/Setup

        let opts = J_.Opts::{ nimVersion = versions.nim }

        let steps = J_.mkSteps opts

        in  { opts, steps }
    , versions
    }
