# read version
echo "🚀 Input PinLayout version ex) 1.10.5"
read version

rm -rf PinLayout.zip
rm -rf PinLayout
rm -rf PinLayout.xcframework

# download
curl https://github.com/layoutBox/PinLayout/archive/refs/tags/$version.zip -L -o PinLayout.zip
unzip PinLayout.zip
mv PinLayout-$version PinLayout

cd PinLayout

for SDK in iphoneos iphonesimulator
do
xcodebuild archive \
  -workspace PinLayout.xcworkspace \
  -scheme PinLayout-iOS \
  -archivePath "PinLayout-$SDK.xcarchive" \
  -sdk $SDK \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  DEBUG_INFORMATION_FORMAT=DWARF \
  MARKETING_VERSION=$version
done

xcodebuild -create-xcframework \
  -framework "PinLayout-iphoneos.xcarchive/Products/Library/Frameworks/PinLayout.framework" \
  -framework "PinLayout-iphonesimulator.xcarchive/Products/Library/Frameworks/PinLayout.framework" \
  -output "../PinLayout.xcframework"

cd ..

rm -rf PinLayout.zip
rm -rf PinLayout