/*package com.socioboard.iboardpro;

import java.util.HashMap;

import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.database.util.ModelUserDatas;
import com.socioboard.iboardpro.database.util.TwiterManyLocalData;
import com.socioboard.iboardpro.instagramlibrary.Controller;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.AsyncTask;
import android.support.v4.app.NotificationCompat;

public class CustomReciver extends BroadcastReceiver {

	String UserID, accesstoken;
	String[] profile_data=new String[2];
	Intent intent1;
	PendingIntent pIntent;
	Context context;
	public static HashMap<String, ModelUserDatas> userdetails = new HashMap<String, ModelUserDatas>();
	TwiterManyLocalData twiterManyLocalData;

	@Override
	public void onReceive(Context context, Intent intent) {
		
		this.context=context;
		intent1 = new Intent(context, MainActivity.class);
		pIntent = PendingIntent.getActivity(context, 0, intent1, 0);
		twiterManyLocalData = new TwiterManyLocalData(context);

		
		twiterManyLocalData.getAllUsersData();
		System.out.println("inside reciver");
		SharedPreferences lifesharedpref = context.getSharedPreferences(
				"iboardpro", Context.MODE_PRIVATE);
		UserID = lifesharedpref.getString("userid", null);
		System.out.println(UserID + "UserID");
		if (UserID != null) {
			ModelUserDatas model = MainSingleTon.userdetails.get(UserID);

			accesstoken = model.getUserAcessToken();

			new GetProfileData().execute();
		}

	}

	class GetProfileData extends AsyncTask<Void, Void, Void> {

		String followed_by_count, follows_count;

		@Override
		protected Void doInBackground(Void... params) {
			System.out.println("URL"+ConstantUrl.URL_Userdata
					+ accesstoken);
			profile_data = Controller.GetProfileData(ConstantUrl.URL_Userdata
					+ accesstoken);
			
			return null;
		}

		@Override
		protected void onPostExecute(Void result) {

			super.onPostExecute(result);

			System.out.println("profile_data[0]" + profile_data[0]);
			followed_by_count = profile_data[0];
			follows_count = profile_data[1];

			NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(
					context);
			mBuilder.setSmallIcon(R.drawable.ic_launcher);
			mBuilder.setContentIntent(pIntent);
			mBuilder.setContentTitle("iBoardPro");

			mBuilder.setContentText("You have" + followed_by_count
					+ "new followers");
			Uri alarmSound = RingtoneManager
					.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
			mBuilder.setSound(alarmSound);
			NotificationManager mNotificationManager = (NotificationManager) context.getSystemService(context.NOTIFICATION_SERVICE);

			// notificationID allows you to update the
			// notification later on.
			mNotificationManager.notify(0, mBuilder.build());
		}
	}
}
*/