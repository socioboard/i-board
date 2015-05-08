package com.socioboard.iboardpro;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;
import android.net.Uri;
import android.support.v4.app.NotificationCompat;

public class SchedulerCustomReceiver extends BroadcastReceiver 
{
	
	@Override
	public void onReceive(Context context, Intent intent) 
	{
		 Intent intent1 = new Intent(context, Blankscheduleactivity.class);
	     PendingIntent pIntent = PendingIntent.getActivity(context, 0, intent1, 0);
		NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(context);
		mBuilder.setSmallIcon(R.drawable.ic_launcher);
		mBuilder.setContentIntent(pIntent);
		mBuilder.setContentTitle("i-boardpro");
		
		mBuilder.setContentText("Time to post photos now");
		Uri alarmSound = RingtoneManager
				.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
		mBuilder.setSound(alarmSound);
		NotificationManager mNotificationManager = (NotificationManager) context.getSystemService(context.NOTIFICATION_SERVICE);

		// notificationID allows you to update the
		// notification later on.
		mNotificationManager.notify(0, mBuilder.build());	
		
}

}
