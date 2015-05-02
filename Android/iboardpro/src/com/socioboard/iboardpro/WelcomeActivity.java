package com.socioboard.iboardpro;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.Toast;

import com.socioboard.iboardpro.database.util.InstagramManyLocalData;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.database.util.ModelUserDatas;
import com.socioboard.iboardpro.instagramlibrary.InstagramApp;
import com.socioboard.iboardpro.instagramlibrary.InstagramApp.OAuthAuthenticationListener;

public class WelcomeActivity extends Activity {
	private InstagramApp mApp;
	Button connect;
	CommonUtilss utilss;
	InstagramManyLocalData db;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.landing_screen);
		mApp = new InstagramApp(this, ApplicationData.CLIENT_ID,
				ApplicationData.CLIENT_SECRET, ApplicationData.CALLBACK_URL);
		mApp.setListener(listener);
		connect = (Button) findViewById(R.id.signin);
		 db = new InstagramManyLocalData(
				getApplicationContext());
		utilss = new CommonUtilss();
		final ConnectionDetector detector=new ConnectionDetector(getApplicationContext());
		
		connect.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				
				if (detector.isConnectingToInternet()) {
					mApp.authorize();
				}
				else {
					Toast.makeText(getApplicationContext(), "Please connect to internet!", Toast.LENGTH_LONG).show();
				}
				
			}
		});

		
		db.getAllUsersData();
		
		System.out.println("LocalUserData="+MainSingleTon.useridlist.toString());
	}

	OAuthAuthenticationListener listener = new OAuthAuthenticationListener() {

		@Override
		public void onSuccess() {

			System.out.println("accessToken" + mApp.getAccessToken());

			new Setuserdata().execute(mApp.getProfileimageUrl());

			
		}

		@Override
		public void onFail(String error) {
			Toast.makeText(WelcomeActivity.this, error, Toast.LENGTH_SHORT)
					.show();
		}
	};

	class Setuserdata extends AsyncTask<String, Void, Void> {
		String imageString;

		@Override
		protected Void doInBackground(String... params) {

			String photourl = params[0];

			imageString = utilss.getImageBytearray(photourl);

			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			// TODO Auto-generated method stub
			super.onPostExecute(result);

			ModelUserDatas datas = new ModelUserDatas();
			datas.setUserAcessToken(mApp.getAccessToken());
			datas.setUserid(mApp.getId());
			datas.setUsername(mApp.getName());
			datas.setUserimage(imageString);

			db.addNewUserAccount(datas);
			
			MainSingleTon.username=mApp.getName();
			MainSingleTon.userimage=imageString;
			MainSingleTon.accesstoken=mApp.getAccessToken();
			MainSingleTon.userid=mApp.getId();
			
			MainSingleTon.userdetails.put(mApp.getId(), datas);
			MainSingleTon.useridlist.add(mApp.getId());
			SharedPreferences lifesharedpref=getSharedPreferences("FacebookBoard", Context.MODE_PRIVATE);
			SharedPreferences.Editor editor=lifesharedpref.edit();
			editor.putString("userid", mApp.getId());
			editor.commit();
			Intent intent = new Intent(getApplicationContext(),
					MainActivity.class);
			startActivity(intent);

			finish();
			Toast.makeText(WelcomeActivity.this, "sucess", Toast.LENGTH_SHORT)
					.show();
		}

	}
}
