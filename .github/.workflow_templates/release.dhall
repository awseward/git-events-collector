let imports = ../imports.dhall

let config = ../config.dhall

let GHA = imports.GHA

let On = GHA.On

let OS = GHA.OS.Type

let Checkout = imports.actions-catalog.actions/checkout

let Release = imports.job-templates.release

in  GHA.Workflow::{
    , name = "Release"
    , on = On.map [ On.push On.PushPull::{ tags = On.include [ "*" ] } ]
    , jobs = toMap
        { release-client = GHA.Job::{
          , runs-on = [ OS.macos-latest ]
          , steps =
              Checkout.plainDo
                (   config.nimSetup.steps
                  # Release.mkSteps Release.Opts::config.homebrew
                )
          }
        }
    }
