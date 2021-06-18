let dhall-misc =
      https://raw.githubusercontent.com/awseward/dhall-misc/20210616052737/package.dhall
        sha256:8e1fe66925df2a92a25774e809da7dda1ce6775058db22a21f79fab2f12bbaed

in  dhall-misc.{ actions-catalog, job-templates, GHA }
