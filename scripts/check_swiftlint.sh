set -e

if which swiftlint >/dev/null; then
  current_version=$(swiftlint version)
  actual_version="0.31.0"
  echo $version
if [ "$current_version" != "$actual_version" ] ; then
    echo "warning: Incorrect version of SwiftLint. $actual_version vs $current_version"
  fi
  swiftlint
else
  echo "error: SwiftLint not installed, download it from https://github.com/realm/SwiftLint"
  exit 1
fi
