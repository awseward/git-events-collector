-- TODO: Implement the steps in this action's single job
let imports =
      https://raw.githubusercontent.com/awseward/dhall-misc/0a6f0c9a9cc274b629c281a180e23a7d52d4b255/action_templates/package.dhall sha256:81940c41ebd445d5126b603d9e44555cc3c4282a6abb5d57bd5b8d36ccc5a893

let Map =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.0.0/Prelude/Map/Type.dhall sha256:210c7a9eba71efbb0f7a66b3dcf8b9d3976ffc2bc0e907aadfb6aa29c333e8ed

let GHA = imports.gha/jobs

let Build = imports.NimBuild

let checkout = imports.gha/steps.checkout

let run = GHA.Step.run

let uses = GHA.Step.uses

let Thing = { id : Optional Text, `with` : Map Text Text }

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
            , run GHA.Run::{ run = "echo 'TODO: upload tarball'" }
            , run
                GHA.Run::{
                , run = "echo 'TODO: mislav/bump-homebrew-formula-action@v1.6'"
                }
            ]
          }
        }
      ]
    , things =
          [ { id = None Text
            , `with` = toMap
                { body =
                    "Checksum: `\${{ steps.checksum.outputs.tarball_checksum }}`"
                , draft = "false"
                , prerelease = "false"
                , release_name = "\${{ steps.plan.outputs.git_tag }}"
                , tag_name = "\${{ steps.plan.outputs.git_tag }}"
                }
            }
          ]
        : List Thing
    }
