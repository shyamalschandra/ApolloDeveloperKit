.PHONY: all clean carthage carthage-clean cocoapods cocoapods-clean

all: carthage cocoapods

clean: carthage-clean cocoapods-clean

carthage:
	carthage bootstrap --platform iOS --no-use-binaries --cache-builds
	set -o pipefail && xcodebuild -project ApolloDeveloperKitInstallTests.xcodeproj -scheme ApolloDeveloperKitInstallTests-iOS-Carthage -sdk iphonesimulator build | xcpretty

carthage-clean:
	$(RM) -R Carthage Cartfile.resolved

cocoapods:
	pod install
	set -o pipefail && xcodebuild -workspace ApolloDeveloperKitInstallTests.xcworkspace -scheme ApolloDeveloperKitInstallTests-iOS-CocoaPods -sdk iphonesimulator build | xcpretty

cocoapods-clean:
	pod deintegrate
