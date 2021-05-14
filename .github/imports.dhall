let dhall-misc =
      https://raw.githubusercontent.com/awseward/dhall-misc/20210514020537/package.dhall sha256:5365fa3f87b28f72ec098d90f4b2788cdafdb9463032afa75b8b7ebafdd02351

in  dhall-misc.{ actions-catalog, job-templates, GHA }
