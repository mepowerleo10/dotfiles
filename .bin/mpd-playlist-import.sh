#!/bin/bash

while IFS= read -r line
do
  echo copying "$line" to $2
  cp "$line" "$2"
done < "$1"
