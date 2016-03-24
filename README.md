# pyenv-virtualenv-ext

[![license-image]][license]

pyenv-virtualenv-ext is a [pyenv](https://github.com/yyuu/pyenv) plugin that
hooks into `pyenv exec` and `pyenv which` to make itself transparently aware of
the virtual environment specified inside a `.python-venv` file.

This means you don't have to worry about activating the virtual environment, or
adding `eval "$(pyenv virtualenv-init -)"` to your profile.

See the [list of releases](https://github.com/jamieconnolly/pyenv-virtualenv-ext/releases)
for changes in each version.

## Installation

### Installing as a pyenv plugin (recommended)

Make sure you have the latest [pyenv](https://github.com/yyuu/pyenv) and
[pyenv-virtualenv](https://github.com/yyuu/pyenv-virtualenv) versions installed,
then run:

    git clone https://github.com/jamieconnolly/pyenv-virtualenv-ext.git ~/.pyenv/plugins/pyenv-virtualenv-ext

This will install the latest development version of pyenv-virtualenv-ext into
the `~/.pyenv/plugins/pyenv-virtualenv-ext` directory. From that directory, you
can check out a specific release tag. To update pyenv-virtualenv-ext, run git
pull to download the latest changes.

### Installing as a standalone program (advanced)

Make sure you have the latest [pyenv](https://github.com/yyuu/pyenv) and
[pyenv-virtualenv](https://github.com/yyuu/pyenv-virtualenv) versions installed,
then run:

    git clone https://github.com/jamieconnolly/pyenv-virtualenv-ext.git
    cd pyenv-virtualenv-ext
    ./install.sh

This will install pyenv-virtualenv-ext into `/usr/local`. If you do not have
write permission to `/usr/local`, you will need to run `sudo ./install.sh`
instead. You can install to a different prefix by setting the `PREFIX`
environment variable.

To update pyenv-virtualenv-ext after it has been installed, run `git pull` in
your cloned copy of the repository, then re-run the install script.

### Installing with Homebrew (for OS X users)

Mac OS X users can install pyenv-virtualenv-ext with the [Homebrew](http://brew.sh)
package manager.

*This is the recommended method of installation if you installed pyenv with
Homebrew.*

    brew tap jamieconnolly/formulae
    brew install pyenv-virtualenv-ext

Or, if you would like to install the latest development release:

    brew tap jamieconnolly/formulae
    brew install --HEAD pyenv-virtualenv-ext

## Usage

Just add the name of the virtual environment to a `.python-venv` file in your
project. That's it, you're good to go!

[license]: https://github.com/jamieconnolly/pyenv-virtualenv-ext/blob/master/LICENSE
[license-image]: https://img.shields.io/badge/license-MIT-blue.svg
