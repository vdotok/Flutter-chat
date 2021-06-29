
# vdotok_stream_example


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



 Follow the link below and Select the operating system on which you are installing Flutter.

 https://flutter.dev/docs/get-started/install

Note: 
now run "flutter doctor"
Before move farword make sure all the ticks are green. 

## Repo Clone:	
Copy and Paste Github URL “https://github.com/vdotok/Flutter-chat”
	Click on “Code” button
	From HTTPS section copy repo URL
	Open terminal and go to that directory where you want to clone project.
	Paste copied URL and press Enter.
	Hurrraaaa you Just configure the project


## VS code installation 

Download Vs code by using following link. 
https://code.visualstudio.com/download


## project run steps
1. open project in vs code. 
2. Open terminal and go to project directory and run "flutter pub get"


## Device Setting


	
In order to connect you device  you need to enable developer mode
	For enabling developer mode and usb debug you may follow the device specific steps
	you can follow the step described in link below to enable developer options and usb debugging
	https://developer.android.com/studio/debug/dev-options




## Build Project 

After connecting phone run following command in project directory. 

"flutter run"