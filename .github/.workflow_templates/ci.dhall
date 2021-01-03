let imports = ../imports.dhall

let GHA = imports.GHA

let On = GHA.On

let Checkout = imports.action_templates.actions/Checkout

let nim/Build = imports.action_templates.nim/Build

let collectJobs = imports.concat { mapKey : Text, mapValue : GHA.Job.Type }

in  GHA.Workflow::{
    , name = "CI"
    , on = On.names [ "push" ]
    , jobs =
        collectJobs
          [ [ nim/Build.mkJobEntry
                nim/Build.Opts::{
                , platforms = [ "macos-latest" ]
                , bin = "git_events_collector"
                }
            ]
          , toMap
              { check-shell = GHA.Job::{
                , runs-on = [ "ubuntu-latest" ]
                , steps =
                    Checkout.plainDo
                      [ [ let action = imports.gh-actions-shell

                          in  action.mkStep
                                action.Common::{=}
                                action.Inputs::{=}
                        ]
                      ]
                }
              , check-dhall = GHA.Job::{
                , runs-on = [ "ubuntu-latest" ]
                , steps =
                    Checkout.plainDo
                      [ [ let action = imports.gh-actions-dhall

                          in  action.mkStep
                                action.Common::{=}
                                action.Inputs::{ dhallVersion = "1.37.1" }
                        ]
                      ]
                }
              }
          ]
    }
