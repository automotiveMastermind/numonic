---
title: userenv-append-path
---

# NAME

userenv-append-path - appends a path to the end of the **PATH** variable within the user specific environment file

# SYNOPSIS

**userenv append-path** [<*path*>] [**-f** <*file*>] [**-h** | **--help**]

**userenv append-path** [<*path*>] [**--file=**<*file*>] [**-h** | **--help**]

# DESCRIPTION

This command will append the specified path to the **PATH** variable witihn the user specific environment file,
typically located at $HOME/.pam_environment. The separator will always be a colon (:).

If the specified path is already in the **PATH** variable, then the command will fail with an exit code of 2. For all
other errors, the exit code will be 1.

# OPTIONS

## \<path\>

the path to append to the end of the **PATH** variable
DEFAULT: "${PWD}"

## -h, --help

print this help information

## -f \<file\>, --file=\<file\>

the path of the environment file to read and write
DEFAULT: $HOME/.pam_environment

# DEFAULTS

If no path is specified, the command will use append the current path of the shell.

If no file is specified, then the default user specific environment file location of $HOME/.pam_environment will be
used.

# EXAMPLES

## userenv append-path

append the current path to the end of the **PATH** variable

## userenv append-path ~/my-app/bin

append a specific path to the end of the **PATH** variable

## userenv append-path -f ~/my-variables

## userenv append-path --file=~/my-variables

append a specific path to the end of the **PATH** variable within the specified environments file ($HOME/my-variables)

# SEE ALSO

**userenv-prepend-path**(1), **userenv-load**(1), **environ**(7), **pam_env**(7)
