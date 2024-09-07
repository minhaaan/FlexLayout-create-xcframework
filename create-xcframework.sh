# 버전 입력 받기
echo "🚀 Input FlexLayout version ex) 2.0.06"
read version

rm -rf FlexLayout.zip
rm -rf FlexLayout
rm -rf FlexLayout.xcframework

# download
curl https://github.com/layoutBox/FlexLayout/archive/refs/tags/$version.zip -L -o FlexLayout.zip
unzip FlexLayout.zip
mv FlexLayout-$version FlexLayout

cd FlexLayout

# If the version is 2.0.08 or higher, use the scheme FlexLayoutInner; otherwise, use FlexLayout
if echo "$version" | egrep -q '^2\.0\.(0[8-9]|[1-9][0-9])$|^2\.[1-9][0-9]*\.[0-9]+$|^[3-9]\.'; then
  scheme="FlexLayoutInner"
else
  scheme="FlexLayout"
fi

for SDK in iphoneos iphonesimulator
do
xcodebuild archive \
  -workspace FlexLayout.xcworkspace \
  -scheme $scheme \
  -archivePath "FlexLayout-$SDK.xcarchive" \
  -sdk $SDK \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  DEBUG_INFORMATION_FORMAT=DWARF \
  MARKETING_VERSION=$version
done

xcodebuild -create-xcframework \
  -framework "FlexLayout-iphoneos.xcarchive/Products/Library/Frameworks/FlexLayout.framework" \
  -framework "FlexLayout-iphonesimulator.xcarchive/Products/Library/Frameworks/FlexLayout.framework" \
  -output "../FlexLayout.xcframework"

cd ..

rm -rf FlexLayout.zip
rm -rf FlexLayout