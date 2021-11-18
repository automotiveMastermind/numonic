---
title: userenv-load
---

# NAME

userenv-load - loads the user specific environment file within the current shell session

# SYNOPSIS

**userenv-load** [**--help**]

# DESCRIPTION

This command will load all variables from the user specific environment file, typically localled at
$HOME/.pam_environment. Once loaded, the variables will be available within the current shell.

# OPTIONS

## --help

print this help information

# EXAMPLES

## userenv load

load all variables contained within the user specific environment file

# SEE ALSO

**userenv-edit**(1), **userenv-set**(1), **userenv-add**(1), **userenv-replace**(1), **pam_env**(7)
