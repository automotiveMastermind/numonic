---
title: install-podman
---

# NAME

install-podman - installs podman, skopeo, and all prerequisites for the current platform required to build and run
containers

# SYNOPSIS

**install-podman** [**-d** | **--debug**] [**-f** | **--force**] [**-h** |  **--help**] [**-q** | **--quiet**]

# DESCRIPTION

This installer will configure podman and a container runtime with full support for bind mounts, port-forwarding, and
cross-platform build / run. The exact dependencies and configuration of podman is highly dependent on the platform on
which it is installed. See the following sections for more information.

## MACOS

Installation of podman on macOS currently relies on [lima](https://github.com/lima-vm/lima) to enable bind mount
capabilities using sshfs. The default `podman-machine` does not currently support bind mounts, although support is
coming soon. We will continue to evaluate `podman-machine` as a native solution.

## WSL

WSL 2 does not currently support systemd, so the podman socket is initialised as a background process. In addition, the
cgroup manager must be set to cgroupfs and the events logger is set to file.

# OPTIONS

## FLAGS

### -d, --debug

print the commands as they are executed (set -x)

### -f, --force

forces an installation / upgrade of podman and its dependencies even if it is already installed

### -h, --help

print this help information

### -q, --quiet

suppress any output to stdout (any errors will still be printed)

# EXAMPLES

## install-podman

installs podman if not already installed

## install-podman --force

installs or updates podman even if it is already installed
this will replace any existing dependencies, such as vms used to enable podman support on platforms such as macOS
