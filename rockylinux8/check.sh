#!/bin/bash
source /opt/rh/gcc-toolset-11/enable
cd "$WORKSPACE"
make check V=1
