# XBuild

[![CI Status](https://travis-ci.org/guidomb/xbuild.svg?branch=master)](https://travis-ci.org/guidomb/xbuild)
[![Code Climate](https://codeclimate.com/github/guidomb/xbuild/badges/gpa.svg)](https://codeclimate.com/github/guidomb/xbuild)
[![Test Coverage](https://codeclimate.com/github/guidomb/xbuild/badges/coverage.svg)](https://codeclimate.com/github/guidomb/xbuild)


**XBuild** is a thin wrapper on top of `xcodebuild` and `xctool` that allows you to configure your favorite iOS & Mac build tool for your project.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xbuild'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xbuild

## Usage

      xbuild [OPTIONS] ACTION [WORKSPACE] [SCHEME]

      Parameters:
        ACTION                        The build action to be run. (clean|build|test|archive|analyze|install)
        [WORKSPACE]                   Sets the project's workspace.
        [SCHEME]                      Sets the project's scheme.

      Options:
        -x, --dry-run                 Runs all the process without actually calling the build tool.
        -p, --pretty                  Uses xcpretty to format build output (only when using xcodebuild).
        -v, --verbose                 Enables verbose mode.
        -F, --xctool                  Uses xctool instead of xcodebuild as the build tool.
        -h, --help                    print help


You can have a `.xbuild.yml` on the current working directory where you run `xbuild`
command is run. In this file you can configure the options, workspace and scheme. Here
is an example:

```yaml
dry_run: false
pretty: false
verbose: true
xctool: true
scheme: MyProjectShared
workspace: MyProject.xcworkspace
```

Options and arguments passed through the command line have more precedence that the
ones defined in the `.xbuild.yml` file.

The `scheme` and `workspace` arguments are mandatory and must be defined either using
the `.xbuild.yml` or through the command line.

### Action arguments

You can configure action arguments to be included for a specific action in your `.xbuild.yml`. For example lets say that you want to add the arguments `-foo 1 -bar 2` for the `build` action. You should defined those actions like this"

```yaml
dry_run: true
pretty: true
verbose: true
xctool: false
scheme: MyProjectShared
workspace: MyProject.xcworkspace
action_arguments:
  build:
    foo: 1
    bar: 2
```

When you run the `xbuild` command with the previous `.xbuild.yml` you will get the following output:

    XBuild::Runner: Executing command 'set -o pipefail && xcodebuild -workspace   MyProject.xcworkspace -scheme MyProjectShared build -foo 1 -bar 2 | xcpretty -c'


## Contributing

1. Fork it ( https://github.com/guidomb/xbuild/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

**XBuild** is available under the MIT [license](https://raw.githubusercontent.com/guidomb/xbuild/master/LICENSE).

      Copyright (c) 2014 Guido Marucci Blas <guidomb@gmail.com.ar>

      Permission is hereby granted, free of charge, to any person obtaining a copy
      of this software and associated documentation files (the "Software"), to deal
      in the Software without restriction, including without limitation the rights
      to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
      copies of the Software, and to permit persons to whom the Software is
      furnished to do so, subject to the following conditions:

      The above copyright notice and this permission notice shall be included in
      all copies or substantial portions of the Software.

      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
      IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
      FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
      AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
      LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
      OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
      THE SOFTWARE.
