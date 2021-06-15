let imports = ../imports.dhall

let config = ../config.dhall

let GHA = imports.GHA

let On = GHA.On

let OS = GHA.OS.Type

let actions = imports.actions-catalog

let Checkout = actions.actions/checkout

let nim/Build = imports.job-templates.nim/Build

in  GHA.Workflow::{
    , name = "CI"
    , on = On.names [ "push" ]
    , jobs =
          [ nim/Build.mkJobEntry
              nim/Build.Opts::{
              , platforms = [ OS.macos-latest ]
              , bin = "git_events_collector"
              , nimSetup = config.nimSetup.opts
              }
          ]
        # toMap
            { check-shell = GHA.Job::{
              , runs-on = [ OS.ubuntu-latest ]
              , steps =
                  Checkout.plainDo
                    [ let A = actions.awseward/gh-actions-shell

                      in  A.mkStep A.Common::{=} A.Inputs::{=}
                    ]
              }
            , check-dhall = GHA.Job::{
              , runs-on = [ OS.ubuntu-latest ]
              , steps =
                  Checkout.plainDo
                    [ let A = actions.awseward/gh-actions-dhall

                      in  A.mkStep A.Common::{=} A.Inputs::{=}
                    ]
              }
            }
    }
