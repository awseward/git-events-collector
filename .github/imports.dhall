let dhall-misc =
      https://raw.githubusercontent.com/awseward/dhall-misc/20210612002520/package.dhall
        sha256:09eecf28e32dd179bc8a3500ac0ed4c312c6f793e2ca588d297fac0187f6e85e

in  dhall-misc.{ actions-catalog, job-templates, GHA }
