let imports =
      https://raw.githubusercontent.com/awseward/dhall-misc/0a6f0c9a9cc274b629c281a180e23a7d52d4b255/action_templates/package.dhall sha256:81940c41ebd445d5126b603d9e44555cc3c4282a6abb5d57bd5b8d36ccc5a893

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
      ]
    }
