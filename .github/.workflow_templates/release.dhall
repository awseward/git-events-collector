-- TODO: Implement the steps in this action's single job
let imports =
      https://raw.githubusercontent.com/awseward/dhall-misc/23bbedf525112d787334849b86caafa3310c4389/action_templates/package.dhall sha256:6a5145962730d7a0c7705a3b70803aaf22ee978f7fc1269aceca27100028ff31

let Map =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.0.0/Prelude/Map/Type.dhall sha256:210c7a9eba71efbb0f7a66b3dcf8b9d3976ffc2bc0e907aadfb6aa29c333e8ed

let GHA = imports.gha/jobs

let Build = imports.NimBuild

let checkout = imports.gha/steps.checkout

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
            [ checkout
            , run GHA.Run::{ run = "echo 'TODO: plan'" }
            , run GHA.Run::{ run = "echo 'TODO: nim setup'" }
            , run GHA.Run::{ run = "echo 'TODO: tarball'" }
            , run GHA.Run::{ run = "echo 'TODO: checksum'" }
            , run GHA.Run::{ run = "echo 'TODO: create Relase'" }
            , uses
                GHA.Uses::{
                , id = Some "upload_tarball"
                , uses = "actions/upload-release-asset@v1"
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
          }
        }
      ]
    }
