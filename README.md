# VDOTOK Flutter Connect 

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
 

## Create Client Instance: 

First we need to create an instance of emitter client.  

```
Emitter emitter = Emitter.instance; 
```

## Add listeners: 

Below described main helpful callbacks and listeners: 

```

emitter.onConnect = (res) { 

}; 

emitter.onPresence = (res) { 

}; 

emitter.onsubscribe = (value) { 

}; 

emitter.onMessage = (msg) async { 

};

```

 

class used in ReadReceiptModel class to inform status of the message 

```

class ReceiptType { 

static var sent = 1; 

static var delivered = 2; 

static var seen = 3; 

} 

 ```

Class to identify the type of file 
 

```
class MediaType { 

static int image = 0; 

static int audio = 1; 

static int video = 2; 

static int file = 3; 

} 
```

 
Class to identify the type of Message 
```

class MessageType { 

static const String text = "text"; 

static const String media = "media"; 

static const String file = "file"; 

static const String thumbnail = "thumbnail"; 

static const String path = "path"; 

static const String typing = "typing"; 

} 
```

## SDK Methods: 

 

## Connection: 

 

Use this method to connect socket. 
```

emitter.connect( 

String lientId, 

Bool reconnectivity, 

String refID, 

String authorization_token 

); 
```

 

## Subscription: 

 

// Use this method to subscribe to a chat or group 
```

emitter.subscribePresence(String channelKey, String channelName, bool changes, bool status); 

 ```

## SubscribePresence: 

 

//Use this method to acknowledge the availability of the user.  
```

emitter.subscribePresence(String channelKey, String channelName, bool changes, bool status); 

 ```

## Publish: 

 

// Use this method to publish message of object type which can be of any type i-e text ,audio,video,document or images type. 
```

Emitter.publish(String channelKey, String channelName, Map<String, dynamic> send_message); 

 ```