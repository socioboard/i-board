package com.socioboard.iboardpro;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;
import android.net.Uri;
import android.support.v4.app.NotificationCompat;

public class MyCustomReceiver extends BroadcastReceiver {
	public static boolean beatrequest = false;

	@Override
	public void onReceive(Context context, Intent intent) {

		String action = intent.getAction();
		try {
			JSONObject json = new JSONObject(intent.getExtras().getString(
					"com.parse.Data"));
			System.out.println("@@@@@@@@@@@@@@@@@@@@@@ " + json.toString());
			if (!json.isNull("Message")) {
				beatrequest = true;
				json.getString("Message");

				if (json.has("Type")) {

				}
				Intent intent1 = new Intent(context, MainActivity.class);
				PendingIntent pIntent = PendingIntent.getActivity(context, 0,
						intent1, 0);
				NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(
						context);
				mBuilder.setSmallIcon(R.drawable.ic_launcher);
				mBuilder.setContentIntent(pIntent);
				mBuilder.setContentTitle("iBoardPro");
				System.out.println("message" + json.getString("Message"));
				mBuilder.setContentText(json.getString("Message"));
				Uri alarmSound = RingtoneManager
						.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
				mBuilder.setSound(alarmSound);
				NotificationManager mNotificationManager = (NotificationManager) context
						.getSystemService(context.NOTIFICATION_SERVICE);

				// notificationID allows you to update the
				// notification later on.
				mNotificationManager.notify(1, mBuilder.build());

			}

			System.out.println("");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
