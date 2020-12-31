let imports = ../imports.dhall

let action_templates = imports.action_templates

let GHA = action_templates.gha/jobs

let Build = action_templates.NimBuild

let checkedOut =
      λ(steps : List GHA.Step) →
        imports.concat
          GHA.Step
          [ [ action_templates.gha/steps.checkout ], steps ]

let uses = GHA.Step.uses

let Job = { runs-on : List Text, steps : List GHA.Step }

let JobEntry = { mapKey : Text, mapValue : Job }

in  { name = "CI"
    , on = [ "push" ]
    , jobs =
        imports.concat
          JobEntry
          [ [ Build.mkJob
                Build.Opts::{
                , platforms = [ "macos-latest" ]
                , bin = "git_events_collector"
                }
            ]
          , toMap
              { check-shell =
                { runs-on = [ "ubuntu-latest" ]
                , steps =
                    checkedOut
                      [ let a = imports.gh-actions-shell

                        in  a.mkJob a.Inputs::{=}
                      ]
                }
              , check-dhall =
                { runs-on = [ "ubuntu-latest" ]
                , steps =
                    checkedOut
                      [ let a = imports.gh-actions-dhall

                        in  a.mkJob a.Inputs::{ dhallVersion = "1.37.1" }
                      ]
                }
              }
          ]
    }
