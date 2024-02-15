ROOT="./.build"

rm -rf $ROOT

for SDK in iphoneos iphonesimulator
do
xcodebuild archive \
  -scheme FlexLayout \
  -archivePath "$ROOT/FlexLayout-$SDK.xcarchive" \
  -sdk $SDK \
  SKIP_INSTALL=NO \
  BUILD_LIBRARIES_FOR_DISTRIBUTION=YES \
  DEBUG_INFORMATION_FORMAT=DWARF
done

xcodebuild -create-xcframework \
  -framework "$ROOT/FlexLayout-iphoneos.xcarchive/Products/Library/Frameworks/FlexLayout.framework" \
  -framework "$ROOT/FlexLayout-iphonesimulator.xcarchive/Products/Library/Frameworks/FlexLayout.framework" \
  -output "$ROOT/FlexLayout.xcframework"

# cd $ROOT
# zip -r -X FlexLayout-xcframeworks-ios.zip *.xcframework
# rm -rf *.xcframework
# cd -