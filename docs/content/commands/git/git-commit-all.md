---
title: git-commit-all
---

# NAME

git-commit-all - create a commit including all new, removed, or modified files within the working tree

# SYNOPSIS

**git** **commit-all** [**-d** | **--debug**] [**-h** | **--help**] [**-q** | **--quiet**]

# DESCRIPTION

This command updates the index using all content found within the working tree excluding those defined in a
**.gitignore** file.

# OPTIONS

## FLAGS

### -d, --debug

print the commands as they are executed (set -x)

### -h, --help

print this help information

### -q, --quiet

suppress any output to stdout (any errors will still be printed)

# EXAMPLES

## git commit-all

track all files within the repository, excluding those defined in the .gitignore

## git commit-all -d

## git commit-all --debug

print the underlying git commands as they are executed

# SEE ALSO

**git-commit**(1), **git-add**(1), **gitignore**(5)
