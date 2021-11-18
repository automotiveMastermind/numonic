---
title: userenv-get
---

# NAME

userenv-get - gets the value of a variable within the user specific environment file

# SYNOPSIS

**userenv get** <*key*> [**--help**]

# DESCRIPTION

This command will retrieve the current value of a variable as defined within the user specific environment file,
typically located at $HOME/.pam_environment. This command is case-sensitive as variables are also case sensitive.

# OPTIONS

## \<key\>

the key (or name) of the environment variable to get

## --help

print this help information

# EXAMPLES

## userenv get PATH

get the value of the PATH variable within the user specific environment file

# SEE ALSO

**userenv-add**(1), **userenv-edit**(1), **userenv-set**(1), **userenv-load**(1), **pam_env**(7)
