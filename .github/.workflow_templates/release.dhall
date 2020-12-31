let imports = ../imports.dhall

let action_templates = imports.action_templates

let NimSetup = action_templates.NimSetup

let GHA = action_templates.gha/jobs

let run = GHA.Step.run

let uses = GHA.Step.uses

let release =
      let Opts =
            { Type =
                { formula-name : Text, homebrew-tap : Text, base-branch : Text }
            , default.base-branch = "master"
            }

      in  { mkSteps = λ(opts : Opts.Type) → [] : List GHA.Step, Opts }

let fmtCommitMsg =
      λ(header : Text) →
      λ(body : Text) →
        ''
        ${header}

        ${body}
        ''

in  { name = "Release"
    , on.push.tags = [ "*" ]
    , jobs = toMap
        { release-client =
          { runs-on = [ "macos-latest" ]
          , steps =
              imports.concat
                GHA.Step
                [ NimSetup.mkSteps NimSetup.Opts::{ nimVersion = "1.4.0" }
                , release.mkSteps
                    release.Opts::{
                    , formula-name = "git_events_collector"
                    , homebrew-tap = "awseward/homebrew-tap"
                    }
                ]
          }
        }
    }
