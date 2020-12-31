let imports =
      { action_templates =
          https://raw.githubusercontent.com/awseward/dhall-misc/43f250d9c743ca2d06cc9f849015f021bdb6b53b/action_templates/package.dhall sha256:b8414ded01b53ae4f4a0452245a8f5d667950cb7ef1c8b34b74dc6f6b25c174b
      , Map =
          https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.0.0/Prelude/Map/Type.dhall sha256:210c7a9eba71efbb0f7a66b3dcf8b9d3976ffc2bc0e907aadfb6aa29c333e8ed
      , concat =
          https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.0.0/Prelude/List/concat sha256:54e43278be13276e03bd1afa89e562e94a0a006377ebea7db14c7562b0de292b
      }

let action_templates = imports.action_templates

let NimSetup = action_templates.NimSetup

let GHA = action_templates.gha/jobs

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
    , jobs = toMap
        { release-client =
          { runs-on = [ "macos-latest" ]
          , steps =
              imports.concat
                GHA.Step
                [ NimSetup.mkSteps NimSetup.Opts::{ nimVersion = "1.4.0" }
                , [ run
                      GHA.Run::{
                      , id = Some "plan"
                      , name = Some "Plan release"
                      , run = ./release/plan.sh as Text
                      }
                  , run
                      GHA.Run::{
                      , id = Some "tarball"
                      , name = Some "Create tarball"
                      , run = ./release/tarball.sh as Text
                      }
                  , run
                      GHA.Run::{
                      , id = Some "checksum"
                      , name = Some "Record checksum"
                      , run = ./release/checksum.sh as Text
                      }
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
    }
