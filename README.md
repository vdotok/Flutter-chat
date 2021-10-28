
# vdotok_connect


## Installation

======================


## Preparations  

Required preparations for Android, iOS and web. 

 

## IOS: 

 

Add the following entry to your Info.plist file, located in <project root>/ios/Runner/Info.plist: 

```
<key>NSCameraUsageDescription</key><
string>$(PRODUCT_NAME) Camera Usage!</string>
<key>NSMicrophoneUsageDescription</key>
<string>$(PRODUCT_NAME) Microphone Usage!</string>
```
This entry allows your app to access camera and microphone. 

 

 

## Android: 

  

Ensure the following permission is present in your Android Manifest file, located in  

```

<project root>/android/app/src/main/AndroidManifest.xml:  

<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" /> 

<uses-permission android:name="android.permission.INTERNET" /> 

<uses-permission android:name="android.permission.CAMERA" /> 

<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" /> 

<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" /> 

<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" /> 

<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" /> 

 
```



Open the below link, and select “Operating System” for the installation of Flutter:  

 https://flutter.dev/docs/get-started/install

**Note:** *Now run "flutter doctor" and make sure all the tick-marks appear green.*

## Repo Clone:	
* Open Github URL of VdoTok’s Flutter Chat 

* Click on **Code** button, appearing on R.H.S  

* A toast for **Clone** will appear, containing HTTPS, SSH, and GitHub CLI information  

* On HTTPS section, copy repository **URL** 

* Open **Terminal / Command Prompt** and go to the **Directory** where you want to clone the project  

* Paste copied repository URL and press **Enter** 

Bravo! You’ve successfully configured the project. 

## VS Code Installation:

Download Vs code by using following link : https://code.visualstudio.com/download


## Project Run Steps:

1. Open **Project** in VS Code. 
2. Open **Terminal** and go to **Project Directory** and run **"flutter pub get"**


## Device Setting:
	
To connect a device, enable **“developer mode”** and **“USB debug”** by following the device-specific steps given on the below link:
https://developer.android.com/studio/debug/dev-options


## Build Project 

After connecting phone run following command in **Project Directory:** "flutter run"