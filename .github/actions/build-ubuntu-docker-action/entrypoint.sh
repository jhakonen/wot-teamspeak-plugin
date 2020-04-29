#!/bin/sh

qmake "PLUGIN_VERSION = $1"
make package
