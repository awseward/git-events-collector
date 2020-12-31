let action_templates =
      https://raw.githubusercontent.com/awseward/dhall-misc/23bbedf525112d787334849b86caafa3310c4389/action_templates/package.dhall sha256:6a5145962730d7a0c7705a3b70803aaf22ee978f7fc1269aceca27100028ff31

let check-dhall =
      https://raw.githubusercontent.com/awseward/gh-actions-dhall/7b24bc672d948fdca4ad49f185b18a82a2de196d/job.dhall sha256:f27ade72b1a253a737187974a11b8c6f8e9804ab4b5aa9fda2d2f661d707587d

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
            , check-dhall.mkJob check-dhall.Inputs::{ dhallVersion = "1.37.1" }
            ]
          }
        }
      ]
    }
