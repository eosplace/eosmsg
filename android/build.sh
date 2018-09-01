KEYSTORE=./keystore
APK=./bin/game1-release-unsigned.apk
ZIPALIGN=~/android-sdk-linux/build-tools/22.0.1/zipalign

cp ../index.html assets/

echo "Clean android"
ant clean

echo "Build android"
ant release 

echo "Signing"
rm game1.apk
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore $KEYSTORE $APK cmsoftwares

echo "Zip Align"
$ZIPALIGN -v 4 $APK game1.apk 

