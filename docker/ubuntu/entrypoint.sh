#!/bin/sh

printenv

qmake "PLUGIN_VERSION = $1"
make package
