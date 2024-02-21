# 버전 입력 받기
echo "🚀 버전을 입력해주세요 ex) 2.0.06"
read version

rm -rf FlexLayout.zip
rm -rf FlexLayout
rm -rf FlexLayout.xcframework

# 입력받은 버전에 따라 다운로드
curl https://github.com/layoutBox/FlexLayout/archive/refs/tags/$version.zip -L -o FlexLayout.zip
unzip FlexLayout.zip
mv FlexLayout-$version FlexLayout

cd FlexLayout

for SDK in iphoneos iphonesimulator
do
xcodebuild archive \
  -scheme FlexLayout \
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

echo "🎉 FlexLayout.xcframework 생성 완료 version $version"