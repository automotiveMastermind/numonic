---
title: userenv-prepend
---

# NAME

userenv-prepend - prepends a value to the beginning of a variable within the user specific environment file

# SYNOPSIS

**userenv prepend** <*key*> <*value*> [**--separator** <*separator*>] [**--help**]

**userenv prepend** <*key*>**=**<*value*> [**--separator=**<*separator*>] [**--help**]

# DESCRIPTION

This command will prepend the specified value to the beginning of a variable within the user specific environment file,
typically located at $HOME/.pam_environment. If the variable does not already exist, it will be created using the
specified value. An optional separator can be defined. If the separator is not defined, then the value will be separated
using a colon (:).

# OPTIONS

## \<key\>

the key (or name) of the environment variable to prepend

## \<value\>

the value of the environment variable to prepend

## --separator \<separator\>, --separator=\<separator\>

the separator to use when prepending the value

## --help

print this help information

# EXAMPLES

## userenv prepend abc 123

## userenv prepend abc=123

prepend a variable named abc with a value of 123 using the default colon as a separator

## userenv prepend abc 123 --separator

## userenv prepend abc=123 --separator=

prepend a variable named abc with the value of 123 using a comma as a separator

# DEFAULTS

If the separator is not specified, the default will be the colon (:) character. For example if a value of 123 is
prepended to an existing variable called my_var with a value of abc, then the result will be: my_var=abc:123 by default.

# SEE ALSO

**userenv-append**(1), **userenv-load**(1), **pam_env**(7)
