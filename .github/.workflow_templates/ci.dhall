let imports = ../imports.dhall

let action_templates = imports.action_templates

let GHA = action_templates.gha/jobs

let Build = action_templates.NimBuild

let checkout = action_templates.gha/steps.checkout

let uses = GHA.Step.uses

in  { name = "CI"
    , on = [ "push" ]
    , jobs =
      [ Build.mkJob
          Build.Opts::{
          , platforms = [ "macos-latest" ]
          , bin = "git_events_collector"
          }
      , { mapKey = "check-shell"
        , mapValue =
          { runs-on = [ "ubuntu-latest" ]
          , steps =
            [ checkout
            , uses GHA.Uses::{ uses = "awseward/gh-actions-shell@0.1.0" }
            ]
          }
        }
      , { mapKey = "check-dhall"
        , mapValue =
          { runs-on = [ "ubuntu-latest" ]
          , steps =
            [ checkout
            , let a = imports.gh-actions-dhall

              in  a.mkJob a.Inputs::{ dhallVersion = "1.37.1" }
            ]
          }
        }
      ]
    }
