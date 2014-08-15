#!/bin/sh

cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/your/prefrence .
make 
make install
