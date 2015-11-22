#!/bin/sh

#Fail immediately if a task fails
set -e
set -o pipefail

xcodebuild -project backdrop.xcodeproj -scheme tests test |  xcpretty -c --report junit

