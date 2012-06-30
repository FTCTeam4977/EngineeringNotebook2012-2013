#!/bin/sh

# Script to automaticly open the entry file for today
# Change the EDITOR variable to your favorite editor ( nano, vi, etc ). On a Mac, using mate as the editor will open the file in TextMate.


EDITOR="mate"

$EDITOR `date "+%B%d-%Y.md"`
