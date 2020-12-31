-- TODO: Implement the steps in this action's single job
let imports =
      { action_templates =
          https://raw.githubusercontent.com/awseward/dhall-misc/43f250d9c743ca2d06cc9f849015f021bdb6b53b/action_templates/package.dhall
      , Map =
          https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.0.0/Prelude/Map/Type.dhall sha256:210c7a9eba71efbb0f7a66b3dcf8b9d3976ffc2bc0e907aadfb6aa29c333e8ed
      , concat =
          https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.0.0/Prelude/List/concat
      }

let Map = imports.Map

let action_templates = imports.action_templates

let NimSetup = action_templates.NimSetup

let GHA = action_templates.gha/jobs

let checkout = action_templates.gha/steps.checkout

let run = GHA.Step.run

let uses = GHA.Step.uses

let fmtCommitMsg =
      λ(header : Text) →
      λ(body : Text) →
        ''
        ${header}

        ${body}
        ''

in  { name = "Release"
    , on.push.tags = [ "*" ]
    , jobs =
      [ { release-client =
          { runs-on = [ "macos-latest" ]
          , steps =
              imports.concat
                GHA.Step
                [ NimSetup.mkSteps NimSetup.Opts::{=}
                , [ run GHA.Run::{ id = Some "plan", run = "echo 'TODO: plan'" }
                  , run GHA.Run::{ run = "echo 'TODO: nim setup'" }
                  , run GHA.Run::{ run = "echo 'TODO: tarball'" }
                  , run GHA.Run::{ run = "echo 'TODO: checksum'" }
                  , uses
                      GHA.Uses::{
                      , id = Some "create_release"
                      , uses = "actions/create-release@v1"
                      , env = toMap
                          { GITHUB_TOKEN = "\${{ secrets.GITHUB_TOKEN }}" }
                      , `with` = toMap
                          { tag_name = "\${{ steps.plan.outputs.git_tag }}"
                          , release_name = "\${{ steps.plan.outputs.git_tag }}"
                          , body =
                              "Checksum: `\${{ steps.checksum.outputs.tarball_checksum }}`"
                          , draft = "false"
                          , prerelease = "false"
                          }
                      }
                  , uses
                      GHA.Uses::{
                      , id = Some "upload_tarball"
                      , uses = "actions/upload-release-asset@v1"
                      , env = toMap
                          { GITHUB_TOKEN = "\${{ secrets.GITHUB_TOKEN }}" }
                      , `with` = toMap
                          { body =
                              "Checksum: `\${{ steps.checksum.outputs.tarball_checksum }}`"
                          , draft = "false"
                          , prerelease = "false"
                          , release_name = "\${{ steps.plan.outputs.git_tag }}"
                          , tag_name = "\${{ steps.plan.outputs.git_tag }}"
                          }
                      }
                  , uses
                      GHA.Uses::{
                      , uses = "mislav/bump-homebrew-formula-action@v1.6"
                      , env = toMap
                          { COMMITTER_TOKEN = "\${{ secrets.COMMITTER_TOKEN }}"
                          }
                      , `with` = toMap
                          { formula-name = "git_events_collector"
                          , homebrew-tap = "awseward/homebrew-tap"
                          , base-branch = "master"
                          , download-url =
                              "\${{ steps.upload_tarball.outputs.browser_download_url }}"
                          , commit-message =
                              fmtCommitMsg
                                "{{formulaName}} {{version}}"
                                "Sourced from \${{ steps.create_release.outputs.html_url }}."
                          }
                      }
                  ]
                ]
          }
        }
      ]
    }
