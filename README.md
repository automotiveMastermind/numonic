# Numonic

> A spectacular shell prompt and associated tooling for macOS and *nix distributions

![Preview][preview-image]

## Vitals

| Info     | Badges                                                      |
| -------- | ----------------------------------------------------------- |
| License  | [![License][license-image]][license-url]                    |
| Build    | [![build][workflow-image]][workflow-url]                    |
| Releases | ![stable][stable-version-image] ![next][next-version-image] |

## Features

Numonic is a prompt for sh (any posix shell), bash, and zsh on *nix distributions that includes a ton of useful
functionality, including:

* installation and configuration of the amazing [starship](https://starship.rs) prompt
  * auto-installation of the fabulous [Fira Code](https://github.com/tonsky/FiraCode)
    [Nerd Font](https://www.programmingfonts.org/#firacode) - a prerequisite for starship
* a `dark-mode` [theme](https://numonic.sh/commands/theme) for several terminal programs across various platforms
  * [Apple Terminal](https://support.apple.com/en-gb/guide/terminal/welcome/mac)
  * [Gnome Terminal](https://wiki.gnome.org/Apps/Terminal)
  * [Visual Studio Code](https://code.visualstudio.com)
  * [Windows Terminal](https://aka.ms/terminal)
* automatic registration of [tab completion](https://numonic.sh/completion) for the shell, even for many tools not
  installed via numonic itself
  * kubectl
  * helm
  * terraform
  * docker
  * podman
  * nerdctl
  * npm
  * aws
  * gcloud
  * az
* user-level [environment variable management](https://numonic.sh/commands/userenv) with dynamic directory support
  * environment variables are loaded automatically when cd-ing into a directory containing a `.userenv` file
* a ton of [git extensions](https://numonic.sh/commands/git) to make working with forks and complex workflows easier
  * these are essentially the kit of git aliases that most (if not all) git experts have in their arsenal
* integration with `nvm` with support for `.nvmrc` files that will switch the version of node as required based on the
  current path
* user-level [installers](https://numonic.sh/commands/install) for cloud sdks and developer tools, including aws, azure,
  and google cloud
  * configuration that "just works" on any developer machine, including Windows Subsystem for Linux (WSL)
  * configure rootless [podman](https://podman.io) or [containerd](https://containerd.io) with
    [nerdctl](https://github.com/containerd/nerdctl#command-reference)
  * most *do not* require any privileged access (sudo)
* pre-defined [functions for printing](https://numonic.sh/commands/print) successes, warnings, and failures in colour
  * great for use in your own scripts without re-inventing the wheel
* ... and [much more](https://numonic.sh/commands)!

## Prerequisites

The following prerequisites are required for most numonic commands to function:

* curl >= 6
* git >= 2.0
* gpg / gnupg >= 2.0
* homebrew (mac-only)
* jq - >= 1.4
* a [nerd font](https://www.nerdfonts.com) for your terminal program of choice *OR* use our
  [theme](https://numonic.sh/commands/theme)

The latest available versions of these will be installed for your distribution by default. If you wish to skip automatic
installation, such as on systems where sudo permissions are not available, you can pass the `--no-dependencies` flag to
the bootstrap / installer. Note that doing this will require suitable versions of these prerequisites exist. The
existence of the dependencies is verified but not versions. This is done to ensure the greatest compatibility possible
within a wide range of secure environments, such as virtual deskops without internet access.

The install (install-aws, install-gcloud, install-azure, etc) scripts may have their own dependencies and will require
internet access. Please consult the [install](https://numonic.sh/commands/install) documentation for more information.

### Operating Systems

While numonic *should* run on macOS High Sierra or greater and all Linux distributions with either apt, dnf, or yum, we
only validate against a few of the more recent versions of popular ones.

> NOTE: We only test and support distributions that support both amd64 and arm64 (aarch64) as we have many customers
> operating on both.

| Name    | Version                             |
| ------- | ----------------------------------- |
| macOS   | 10.15 (Catalina) and 11.0 (Big Sur) |
| windows | 10 and 11 (WSL 2)                   |
| ubuntu  | 20.04 (Focal) and 20.10 (Impish)    |
| fedora  | 34 and 35                           |
| debian  | 10 (Buster) and 11 (Bullseye)       |
| centos  | 8                                   |
| arch    | 2021.11.01 and higher               |
| amazon  | Amazon Linux 2                      |


> NOTE: Not all capabilities are tested. If you discover any bugs or wish to add your favourite distro to the validated
> list, please [create an issue][new-issue-url].

## Installation

Install numonic in one step (choose one of the following options):

``` sh
# install and use zsh (the default)
curl --fail --silent --show-error --location https://numonic.sh/bootstrap.sh | sh -s

# install and use bash
curl --fail --silent --show-error --location https://numonic.sh/bootstrap.sh | sh -s -- bash
```

> NOTE: We believe in transparency and clarity of commands, hence the expanded form for the options above. The `-s` flag
> for the shell command means "read commands from standard input". For more information, see the
> [POSIX Specification](https://pubs.opengroup.org/onlinepubs/9699919799/).

### What Happens

Numonic will install the prerequisites above (unless the `--no-dependencies` flag was set). It will then extract shell
scripts and supporting files (such as themes) to `$HOME/.local/numonic`. Finally, it will create or replace the
following files in the `$HOME` directory:

* .pam_environment
* .profile
* .bash_profile
* .bashrc
* .zprofile
* .zshrc

If you have existing customizations within these startup environment files, they will need to be re-added to the
user bashrc and/or zshrc that numonic loads after it is initialized. This may seem invasive (and it is), but experience
has taught us that the vast majority of bugs we experience is correlated to changes that developers
(or other installers) make to these files with no regard for order. In numonic, any user customizations will always be
loaded *AFTER* numonic is fully initialized. This ensures that these customizations always take precendence. It also
will survive upgrades to numonic.

Use the [edit-bashrc](https://numonic.sh/commands/bash/edit-bashrc) and
[edit-zshrc](https://numonic.sh/commands/zsh/edit-zshrc) commands to add these customizations.

We do [create a backup](https://numonic.sh/commands/backup) of these files every time that numonic is installed or
upgraded. One can also uninstall numonic and restore their environment back to the way it was before numonic was even
introduced via an [`uninstall-numonic`](https://numonic.sh/commands/backup/uninstall-numonic) command.

### Specific Versions

Although it is **NOT** recommended (for security reasons), you can install specific versions using any git ref
(branch, tag, sha, etc):

``` sh
# install and use bash with a specific version
curl --fail --silent --show-error --location https://numonic.sh/bootstrap.sh | sh -s -- v1 bash
```

### Updating Numonic

To check for a new version of numonic, run the following command:

``` sh
# install an update if available
update-numonic

# install an update if available; otherwise, reinstall the current version
update-numonic --force
```

Numonic can periodically check for updates (once per week) by comparing the commit sha of the currently installed
version against the latest available version. It will alert the user each time a new shell is launched if a new version
is detected. This can be enabled by setting the `NUMONIC_AUTO_UPDATE` environment variable:

```sh
userenv set NUMONIC_AUTO_UPDATE=1
```

## Backups

We know that prompts can be very personal. As such, we create a backup of *any* file that we modify each and every time
that numonic is installed or updated. These backups are stored in `$HOME/.local/backup`. You can restore a specific
backup via the [`restore-backup`](https://numonic.sh/commands/backup/restore-backup) command. You can restore your
prompt back to the way it was before numonic was introduced to the system via the `uninstall-numonic` command. This will
restore the earliest (initial) backup and remove numonic from the system. Any tools installed using numonic, such as
cloud platform sdks, will remain, however.

## Copyright and License

&copy; automotiveMastermind and contributors. Distributed under the MIT license. See [LICENSE][license-url] for details.

[license-image]: https://img.shields.io/badge/license-MIT-blue.svg
[license-url]: LICENSE

[preview-image]: https://user-images.githubusercontent.com/1803684/102746284-e1880100-4355-11eb-9f72-1e1a07a579a8.png

[workflow-url]: https://github.com/automotivemastermind/numonic/actions?query=workflow%3Aend-to-end
[workflow-image]: https://img.shields.io/github/workflow/status/automotivemastermind/numonic/end-to-end

[stable-version-image]: https://img.shields.io/github/v/release/automotivemastermind/numonic?label=stable&sort=semver
[next-version-image]: https://img.shields.io/github/v/tag/automotivemastermind/numonic?color=orange&include_prereleases&label=next&sort=semver

[new-issue-url]: https://github.com/automotivemastermind/numonic/issues/new
