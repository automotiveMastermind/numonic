---
title: userenv-edit
---

# NAME

userenv-edit - opens an editor to the user specific environments file

# SYNOPSIS

**userenv edit** [**-f** <*file*>] [**-h** | **--help**]

**userenv edit** [**--file=**<*file*>] [**-h** | **--help**]

# DESCRIPTION

This command will open an editor for the user specific environments file, typically located at $HOME/.pam_environment
and wait for any changes to be saved. Once the editor is closed, the environment will be loaded.

# OPTIONS

## -f \<file\>, --file=\<file\>

the path of the environment file to read and write
DEFAULT: $HOME/.pam_environment

## -h, --help

print this help information

# EXAMPLES

## userenv edit

opens an editor to the user specific environments file

## userenv edit -f ~/my-variables

## userenv edit --file=~/my-variables

opens an editor to the specified user specific environments file

# SEE ALSO

**userenv-set**(1), **userenv-add**(1), **userenv-replace**(1), **userenv-load**(1), **pam_env**(7)
