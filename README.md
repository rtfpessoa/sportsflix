# sportsflix

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/076d315d3b5443918eb89841f265019d)](https://www.codacy.com/app/rtfpessoa/sportsflix?utm_source=github.com&utm_medium=referral&utm_content=rtfpessoa/sportsflix&utm_campaign=Badge_Grade)
[![Codacy Badge](https://api.codacy.com/project/badge/Coverage/076d315d3b5443918eb89841f265019d)](https://www.codacy.com/app/rtfpessoa/sportsflix?utm_source=github.com&utm_medium=referral&utm_content=rtfpessoa/sportsflix&utm_campaign=Badge_Coverage)
[![CircleCI](https://circleci.com/gh/rtfpessoa/sportsflix.svg?style=svg)](https://circleci.com/gh/rtfpessoa/sportsflix)

Watch the best sports stream in HD from the command line

## Prerequisite

* Docker
* Ruby 1.9.3 or newer
* VLC player

## Installation

```sh
gem install sportsflix --pre
```

> Notice the `--pre` in the end

## Usage

### Examples

**Watch Benfica game**
```
sflix watch --video-format=mkv --video-player=vlc --club=BENFICA
```

**Watch game on Mac OS with VLC**
```
sflix watch --video-player-path="/Applications/VLC.app/Contents/MacOS/VLC"
```

### Help

    Commands:
      sflix help [COMMAND]  # Describe available commands or one specific command
      sflix watch           # watch stream in the chosen player
    
    Options:
      vvv, [--verbose], [--no-verbose]
      o, [--offset=N]
                                                   # Default: 0
      f, [--video-format=VIDEO-FORMAT]
                                                   # Default: mp4
      c, [--club=CLUB]
      p, [--video-player=VIDEO-PLAYER]
                                                   # Default: vlc
      pp, [--video-player-path=VIDEO-PLAYER-PATH]
                                                   # Default: vlc
      ni, [--no-interactive]
      s, [--server-only], [--no-server-only]

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rtfpessoa/sportsflix. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Copyright

Copyright (c) 2017-present Rodrigo Fernandes. See [LICENSE](https://github.com/rtfpessoa/sportsflix/blob/master/LICENSE.md) for details.
