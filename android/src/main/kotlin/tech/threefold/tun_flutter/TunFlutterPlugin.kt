package tech.threefold.tun_flutter

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.VpnService
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import androidx.localbroadcastmanager.content.LocalBroadcastManager

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** TunFlutterPlugin */
class TunFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var activity: Activity

    var VPN_REQUEST_CODE = 0x0F // const val?

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "tun_flutter")
        channel.setMethodCallHandler(this)

        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "startVpn") {
            val started = startVpn()
            Log.d("tff", "" + "VPN Started ")
            result.success(started.toString())
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.e("tff", "************************ onAttachedToActivity")
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}
    override fun onDetachedFromActivityForConfigChanges() {}

    private fun startVpn(): Boolean {
        Log.d("tff", "preparing vpn service")

        val intent = VpnService.prepare(context)
        if (intent != null) {
            Log.d("tff", "Start activity for result... ")
            activity.startActivityForResult(intent, VPN_REQUEST_CODE)
            return false;
        }



        LocalBroadcastManager.getInstance(activity)
            .registerReceiver(receiver, IntentFilter(TunService.RECEIVER_INTENT))

        val intentTff = Intent(context, TunService::class.java)
        val TASK_CODE = 100
        val pi = activity.createPendingResult(TASK_CODE, intentTff, 0)
        intentTff.action = TunService.ACTION_START
        val startResult = activity.startService(intentTff)

        Log.e("tff", "start service result: " + startResult.toString())

        return true
    }

    private val receiver: BroadcastReceiver =
        object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent) {

                when (intent.getStringExtra("type")) {
                    "state" -> {
                        if (intent.getStringExtra("ip") == null) {
                            //currentIp = "";
                            return;
                        }
                        //if (currentIp != intent.getStringExtra("ip")) {
                        // ip has changed!.
                        //  currentIp = intent.getStringExtra("ip")
                        //  reportIp(currentIp)
                    }
                }
            }
        }
}

