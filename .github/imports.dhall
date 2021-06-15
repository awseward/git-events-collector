let dhall-misc =
      https://raw.githubusercontent.com/awseward/dhall-misc/20210615160625/package.dhall
        sha256:f2f63279600b19f733c04683286b9a955886d64b89589aee251bfb3643d18218

in  dhall-misc.{ actions-catalog, job-templates, GHA }
