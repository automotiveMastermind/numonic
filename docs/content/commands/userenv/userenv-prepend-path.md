---
title: userenv-prepend-path
---

# NAME

userenv-prepend-path - prepends a path to the beginning of the **PATH** variable within the user specific environment file

# SYNOPSIS

**userenv prepend-path** <*path*> [**--help**]

# DESCRIPTION

This command will prepend the specified value to the **PATH** variable witihn the user specific environment file,
typically located at $HOME/.pam_environment. The separator will always be a colon (:).

# OPTIONS

## \<path\>

the path to prepend to the beginning of the **PATH** variable

## --help

print this help information

# EXAMPLES

## userenv prepend-path

prepend the current path to the beginning of the **PATH** variable

## userenv prepend-path ~/my-app/bin

prepend a specific path to the beginning of the **PATH** variable

# SEE ALSO

**userenv-append-path**(1), **userenv-load**(1), **environ**(7), **pam_env**(7)
