# update-licenses

Shell script for updating copyright information in your GitHub projects.

NOTE: This script is very specific to me. In its current incarnation, it only
works for npm-packaged projects in public GitHub. Pull requests for further
extension are welcome.

## Prerequisites

 * Unix-based operating system (tested in OSX only; should work in Linux)
 * Zsh
 * Perl
 * git

## Installation

Install __update-licenses__ via install.sh (override target directory by
specifying `$PREFIX`):

    $ zsh install.sh

## Usage

```sh
update-licenses
```

Script will search cloned GitHub repos for files that may contain copyright
information and update the year range of those copyrights according to the
specified end-year. __update-licenses__ aims to be idempotent.

## Available Options

#### `search`
Set search directory by specifying `$SEARCH` env var. Defaults to `$HOME/git`.

#### `year`
Set end-year for copyright range by specifying `$YEAR` env var. Defaults to
current year.

#### `githubuser` (required)
Set GitHub user to restrict script to by specifying `$GITHUB_USER`. If omitted,
script will prompt for a value.

## License

MIT
