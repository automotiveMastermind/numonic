---
title: userenv-replace
---

# NAME

userenv-replace - replaces the value of an existing variable within the user specific environment file

# SYNOPSIS

**userenv replace** <*key*> <*value*> [**-h** | **--help**]

**userenv replace** <*key*>**=**<*value*> [**-h** | **--help**]

## DESCRIPTION

This command replaces the value of an exsting value within the user specific environment file, typically located at
$HOME/.pam_environment. If the variable does not already exist, then the command will fail. To set or add an existing
variable whther or not it already exists, use **userenv set**. To set a value if and only if it does not already exist,
use **userenv add**.

Once the new variable is replaces, the environment will be loaded to ensure that the new variable is available within
the current shell session.

# OPTIONS

## \<key\>

the key (or name) of the environment variable to add

## \<value\>

the value of the environment variable to add

## -h, --help

print this help information

# EXAMPLES

## userenv replace abc 123

replace a variable named abc with a value of 123

## userenv replace abc=123

replace a variable named abc with a value of 123

# SEE ALSO

**userenv-edit**(1), **userenv-set**(1),**userenv-add**(1), **userenv-load**(1), **pam_env**(7)
