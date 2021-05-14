let imports = ../imports.dhall

let GHA = imports.GHA

let On = GHA.On

let OS = GHA.OS.Type

let Checkout = imports.actions-catalog.actions/checkout

let nim/Setup = imports.job-templates.nim/Setup

let Release = imports.job-templates.release

in  GHA.Workflow::{
    , name = "Release"
    , on = On.map [ On.push On.PushPull::{ tags = On.include [ "*" ] } ]
    , jobs = toMap
        { release-client = GHA.Job::{
          , runs-on = [ OS.macos-latest ]
          , steps =
              Checkout.plainDo
                (   nim/Setup.mkSteps nim/Setup.Opts::{ nimVersion = "1.4.4" }
                  # Release.mkSteps
                      Release.Opts::{
                      , formula-name = "git_events_collector"
                      , homebrew-tap = "awseward/homebrew-tap"
                      }
                )
          }
        }
    }
