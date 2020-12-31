let imports = ../imports.dhall

let Build = imports.action_templates.NimBuild

let check-dhall = imports.gh-actions-dhall

let check-shell = imports.gh-actions-shell

let checkedOut = imports.checkedOut

in  { name = "CI"
    , on = [ "push" ]
    , jobs =
        imports.collectJobs
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
                    checkedOut [ check-shell.mkJob check-shell.Inputs::{=} ]
                }
              , check-dhall =
                { runs-on = [ "ubuntu-latest" ]
                , steps =
                    checkedOut
                      [ check-dhall.mkJob
                          check-dhall.Inputs::{ dhallVersion = "1.37.1" }
                      ]
                }
              }
          ]
    }
