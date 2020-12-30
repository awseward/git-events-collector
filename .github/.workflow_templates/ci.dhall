-- TODO: Give `action_templates` a package file...
let GHA =
      https://raw.githubusercontent.com/awseward/dhall-misc/6e59634e92acab9ae7159cf85596069648e12f89/action_templates/gha/jobs.dhall sha256:62d396ac46458a7f72ef02283f2fb259454ef1cd4cba73da954c3864e7eb9898

let Build =
      https://raw.githubusercontent.com/awseward/dhall-misc/6e59634e92acab9ae7159cf85596069648e12f89/action_templates/NimBuild.dhall sha256:11e5f6b49f06d811a27954fdfe51888d80b9009acc61d4d4a632ec7aed8ba2d1

let checkout =
      ( https://raw.githubusercontent.com/awseward/dhall-misc/6e59634e92acab9ae7159cf85596069648e12f89/action_templates/gha/steps.dhall sha256:16f36e604030c9c9288654156468b236b361efca0b84f6b15e839cad10532bc4
      ).checkout

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
