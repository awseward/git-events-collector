let imports =
      https://raw.githubusercontent.com/awseward/dhall-misc/23bbedf525112d787334849b86caafa3310c4389/action_templates/package.dhall sha256:6a5145962730d7a0c7705a3b70803aaf22ee978f7fc1269aceca27100028ff31

let GHA = imports.gha/jobs

let Build = imports.NimBuild

let checkout = imports.gha/steps.checkout

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
            , uses
                GHA.Uses::{
                , uses = "awseward/gh-actions-dhall@0.2.2"
                , `with` = toMap { dhallVersion = "1.37.1" }
                }
            ]
          }
        }
      ]
    }
