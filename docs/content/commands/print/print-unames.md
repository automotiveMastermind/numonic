---
title: print-unames
---

# NAME

print-unames - prints a list of compatible unix names for the current platform from most specific to least specific

# SYNOPSIS

**print-unames**

# DESCRIPTION

This command uses information from the `/etc/os-release` file, if available, along with the **uname** command to
determine the current operating system id. This is then expanded to include less-specific compatible unix name
identifiers.

When processing the `/etc/os-release` file, the `ID` and `ID_LIKE` variables are used. Special handling is then
implemented for fedora to include centos in the id list as well as linuxmint to include debian.

Windows Subsystem for Linux (WSL) is also detected and included as an id.

The following is a list of expected outputs for various platforms:

`macOS`
: darwin

`ubuntu`
: ubuntu debian linux

`debian`
: debian linux

`centos`
: centos linux

`fedora`
: fedora centos linux

`linuxmint`
: linuxmint debian linux

`ubuntu (wsl)`
: wsl ubuntu debian linux

# EXAMPLES

## print-unames

print the list of compatible unix names from most specific to least specific

# SEE ALSO

**print-colors**(1), **print-success**(1),  **print-warn**(1), **print-fail**(1)
