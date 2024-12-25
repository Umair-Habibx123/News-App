package com.example.news_app

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.newsdetail/url_launcher"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openUrl") {
                val url: String? = call.argument("url")
                if (!url.isNullOrEmpty()) {
                    openBrowserIntent(url)
                    result.success(null)
                } else {
                    result.error("INVALID_URL", "The provided URL is invalid", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun openBrowserIntent(url: String) {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }
}
