# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.2] 2021-12-14
### Added
- Now loads events' JSON `props` into the SQLite files

### Fixed
- Events without remotes now come through as null instead of an empty string

## [0.4.1] 2021-12-14
### Fixed
- Properly handle loading old (`0.1.0`) events; where remote is not present (https://github.com/awseward/git-events-collector/pull/59)

## [0.4.0] 2021-12-10
### Changed
- Various CI updates (https://github.com/awseward/git-events-collector/pull/54, https://github.com/awseward/git-events-collector/pull/55, https://github.com/awseward/git-events-collector/pull/56, https://github.com/awseward/git-events-collector/pull/57)

### Added
- Add handling for `events.remote` (https://github.com/awseward/git-events-collector/pull/58)

## [0.3.2] 2021-04-02
### Changed
- Get the SQLite db component moved into `$XDG_DATA_HOME` also (https://github.com/awseward/git-events-collector/pull/52)

### Fixed
- Fix incorrectly swapped directory order in a path (https://github.com/awseward/git-events-collector/pull/52)

## [0.3.1] 2021-04-01
### Fixed
- Remove leading `./` from `get_path*` invocations
- Ensure new `gec_path*` files get included in release tarball

## [0.3.0] 2021-04-01
### Added
- BSD 3-Clause License (https://github.com/awseward/call_status/pull/122)
- Use XDG base dir(s) (https://github.com/awseward/git-events-collector/pull/49)
- Provide `gec_path*` executables `gec_path_active` and `get_path_data_dir` for quering app locations on disk (https://github.com/awseward/git-events-collector/pull/49)

### Changed
- Upgrade dependency versions - `nim`: `>=1.4.2 → >=1.4.4`, `argparse`: `>=0.10.1 → >=2.0.0` (https://github.com/awseward/git-events-collector/pull/46)

## [0.2.9] 2021-01-18
### TODO: Fill in details

## [0.2.8] 2021-01-18
### TODO: Fill in details

## [0.2.7] 2021-01-05
### TODO: Fill in details

## [0.2.6] 2020-12-31
### TODO: Fill in details

## [0.2.5] 2020-12-31
### TODO: Fill in details

## [0.2.4] 2020-12-31
### TODO: Fill in details

## [0.2.3] 2020-12-30
### TODO: Fill in details

## [0.2.2] 2020-12-19
### TODO: Fill in details

## [0.2.1] 2020-12-19
### TODO: Fill in details

## [0.2.0] 2020-12-19
### TODO: Fill in details

## [0.1.3] 2020-12-12
### TODO: Fill in details

## [0.1.2] 2020-12-12
### TODO: Fill in details

## [0.1.1] 2020-12-12
### TODO: Fill in details

## [0.1.0] 2020-12-11
### TODO: Fill in details

## [0.0.7] 2020-12-09
### TODO: Fill in details

## [0.0.6] 2020-12-09
### TODO: Fill in details

## [0.0.5] 2020-12-09
### TODO: Fill in details

## [0.0.4] 2020-12-08
### TODO: Fill in details

## [0.0.3] 2020-12-08
### TODO: Fill in details

## [0.0.2] 2020-12-08
### TODO: Fill in details
