---
title: git-commit-save
---

# NAME

git-commit-save - create a new empty marker commit

# SYNOPSIS

**git** **commit-save** [**--dry-run**] [**--debug**] [**--help**]

# DESCRIPTION

This command creates a new checkpoint commit with a prefix of **[SAVE]** for the subject. This is useful for saving
progress as a new commit on the current HEAD without pushing to the remote. A saved commit is only retained locally.

# OPTIONS

## \<message\>, -m \<message\>, --message=\<message\>

the message to include in the save commit

## --help

print this help information

## --debug

print the commands as they are executed (set -x)

# EXAMPLES

## git commit-wip

create an save commit with a subject of: **\[SAVE\]** which is not pushed to the remote

## git commit-wip -d 'some message'

## git commit-wip --debug some message

create a commit with a subject of: **\[SAVE\] some message** and push to the remote while printing the commands as they
are executed

# SEE ALSO

**git-commit-mark**(1), **git-commit-wip**(1), **git-commit-restore**(1), **git-commit-undo**(1), **git-commit**(1)
