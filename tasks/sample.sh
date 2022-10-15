#!/bin/bash
# Usage: Bash Script Job Shell Script Using Variables
# -------------------------------------------------
 
# Define bash shell variable called var 
# Avoid spaces around the assignment operator (=)
var="Bash Script Job"
 
# print it 
echo "$var"
 
# Another way of printing it
printf "%s\n" "$var"

# Raise an error to stderr (&2) and send code 1 (exit 1) manually
# echo "Error message..." >&2
# exit 1