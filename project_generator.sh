echo "Running project generations"
swift ./project_configure.swift
rm -rf Ecommerce.xcodeproj
rm -rf Ecommerce.xcworkspace
xcodegen
pod install
open -a Xcode Ecommerce.xcworkspace
