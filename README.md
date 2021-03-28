# git-events-collector

## Installation

```sh
brew install awseward/homebrew-tap/git_events_collector
```

To follow the launchd service log:

```sh
tail -f /tmp/log/gec_run.log
```

There's some potential for permissions issues-- in such cases, can run:
```sh
mkdir -p /tmp/log
touch /tmp/log/gec_run.log
chown "${USER}" /tmp/log/gec_run.log
```

## [Changelog](/CHANGELOG.md)
