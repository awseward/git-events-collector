let imports = ./imports.dhall

let defaultBranch = "main"

let versions = { dhall = "1.39.0", nim = "1.4.4" }

let mkCacheWorkflowOpts -- TODO: Consider upstreaming in some form or another.
                        =
      let GHA = imports.GHA

      let OS = GHA.OS

      let On = GHA.On

      let NonEmpty = GHA.NonEmpty

      in  λ(defaultBranch : Text) →
          λ(os : NonEmpty.Type OS.Type) →
          λ(steps : List GHA.Step.Type) →
            { name = "Cache"
            , on =
                On.map
                  [ On.push
                      On.PushPull::{ branches = On.include [ defaultBranch ] }
                  ]
            , jobs = toMap
                { update-cache = GHA.Job::(GHA.handleOS os ⫽ { steps }) }
            }

in  { defaultBranch
    , mkCacheWorkflowOpts
    , nimSetup =
        let J_ = imports.job-templates.nim/Setup

        let opts = J_.Opts::{ nimVersion = versions.nim }

        let steps = J_.mkSteps opts

        in  { opts, steps }
    , versions
    }
