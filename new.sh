#!/bin/bash

#maker script

for file in "$@"
do
    cat template.cpp > $file.cpp
done
