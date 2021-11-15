package com.ielb.daeem;// ...
import io.flutter.app.FlutterApplication;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;

public class Application extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {
    // ...
    @Override
    public void onCreate() {  
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
        super.onCreate();
     
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        GeneratedPluginRegistrant.registerWith((FlutterEngine) registry);
    }
    // ...
}