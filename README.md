# pyenv-virtualenv-ext

[![build-status-image]][travis-ci]
[![license-image]][license]

pyenv-virtualenv-ext is a [pyenv] plugin that hooks into `pyenv version-name`,
`pyenv-version-origin`, and `pyenv which` to make itself transparently aware of
the virtual environment specified inside a `.python-venv` file.

This means you don't have to add `eval "$(pyenv virtualenv-init -)"` to your
profile, or manually activate the virtual environment.

See the [list of releases][releases] for changes in each version.

## Installation

### Installing as a pyenv plugin (recommended)

Make sure you have the latest [pyenv] and [pyenv-virtualenv] versions installed,
then run:

```shell
git clone https://github.com/jamieconnolly/pyenv-virtualenv-ext.git ~/.pyenv/plugins/pyenv-virtualenv-ext
```

This will install the latest development version of this plugin into the
`~/.pyenv/plugins/pyenv-virtualenv-ext` directory. From that directory, you
can check out a specific release tag. To update the plugin, run git pull to
download the latest changes.

### Installing as a standalone program (advanced)

Make sure you have the latest [pyenv] and [pyenv-virtualenv] versions installed,
then run:

```shell
git clone https://github.com/jamieconnolly/pyenv-virtualenv-ext.git
cd pyenv-virtualenv-ext
./install.sh
```

This will install the plugin into `/usr/local`. If you do not have write
permission to `/usr/local`, you will need to run `sudo ./install.sh` instead.
You can install to a different prefix by setting the `PREFIX` environment
variable.

To update the plugin after it has been installed, run `git pull` in your cloned
copy of the repository, then re-run the install script.

### Installing with Homebrew (for OS X users)

Mac users can install the plugin with the [Homebrew] package manager.

*This is the recommended method of installation if you installed [pyenv] with
[Homebrew].*

```shell
brew tap jamieconnolly/formulae
brew install pyenv-virtualenv-ext
```

Or, if you would like to install the latest development release:

```shell
brew tap jamieconnolly/formulae
brew install --HEAD pyenv-virtualenv-ext
```

## Usage

Just add the name of the virtual environment to a `.python-venv` file in your
project and that's it, you're good to go!

## License

&copy; 2016 Jamie Connolly. Released under the [MIT License](LICENSE.md).

[homebrew]: http://brew.sh
[license]: https://github.com/jamieconnolly/pyenv-virtualenv-ext/blob/master/LICENSE
[pyenv]: https://github.com/yyuu/pyenv
[pyenv-virtualenv]: https://github.com/yyuu/pyenv-virtualenv
[releases]: https://github.com/jamieconnolly/pyenv-virtualenv-ext/releases
[travis-ci]: https://travis-ci.org/jamieconnolly/pyenv-virtualenv-ext

[build-status-image]: https://img.shields.io/travis/jamieconnolly/pyenv-virtualenv-ext/master.svg
[license-image]: https://img.shields.io/badge/license-MIT-blue.svg
