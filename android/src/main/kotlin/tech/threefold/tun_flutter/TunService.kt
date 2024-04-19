package tech.threefold.tun_flutter

import android.content.Intent
import android.net.VpnService
import android.os.ParcelFileDescriptor
import android.system.OsConstants
import android.util.Log
import java.util.concurrent.atomic.AtomicBoolean
import androidx.localbroadcastmanager.content.LocalBroadcastManager

class TunService : VpnService() {

    companion object {
        const val RECEIVER_INTENT = "tech.threefold.tun_flutter.TunService.MESSAGE"
        const val ACTION_START = "tech.threefold.tun_flutter.TunService.START"
        const val ACTION_STOP = "tech.threefold.tun_flutter.TunService.STOP"
    }

    private var started = AtomicBoolean()
    private var parcel: ParcelFileDescriptor? = null
    override fun onCreate() {
        Log.d("tff", "tun service created")
        super.onCreate()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.e("tff", "Got a start command ")
        Log.e("tff", "Got a start command " + intent!!.action)

        if (intent == null) {
            Log.d("TunService", "Intent is null")
            return START_NOT_STICKY
        }
        return when (intent.action ?: ACTION_STOP) {
            ACTION_STOP -> {
                Log.d("TunService", "Stopping...")
                stop(); START_NOT_STICKY
            }

            else -> {
                Log.e("tff", "Starting...")
                start();
                START_STICKY
            }
        }
    }

    private fun start(): Int {
        if (!started.compareAndSet(false, true)) {
            return 0
        }
        Log.e("tff", "start to create the TUN device")

        val builder = Builder()
            .addAddress("192.168.2.2", 24)
            //.addRoute("200::", 7)
            //.allowBypass()
            //.allowFamily(OsConstants.AF_INET)
            //.setBlocking(true)
            //.setMtu(yggdrasil.mtu.toInt())
            .setSession("mycelium")

        Log.e("tff", "Builder created")

        parcel = builder.establish()

        Log.e("tff", "Builder established")
        val parcel = parcel
        if (parcel == null || !parcel.fileDescriptor.valid()) {
            stop()
            return 0
        }

        Log.e("tff", "#########   parcel fd: " + parcel.fd)

        // broadcast the parcel fd
        val intent = Intent(RECEIVER_INTENT)
        intent.putExtra("type", "state")
        intent.putExtra("parcel_fd", parcel.fd)
        intent.putExtra("started", true)
        Log.d("TunService", "BROADCAST")
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent)

        return parcel.fd
    }

    private fun stop() {
        Log.e("tff", "stop called, without real handler")
    }
}