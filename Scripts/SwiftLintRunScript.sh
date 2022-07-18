export PATH="$PATH:/opt/homebrew/bin"
if which swiftlint >/dev/null; then
    swiftlint
else
    echo "warning: SwiftLint not installed, download form https://github.com/realm/SwiftLint"
fi
