package com.socioboard.iboardpro;

import java.util.Map;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;

import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.database.util.ModelUserDatas;
import com.socioboard.iboardpro.database.util.TwiterManyLocalData;

public class SplashActivity extends Activity {

	/*
	 * check user already have stored token in local db or not , 
	 * if there then redirect to feed fragment(Main activity)
	 * or redirect to login screen
	 * 
	 * 
	 */
	
	
	TwiterManyLocalData twiterManyLocalData;

	SharedPreferences preferences;

	

	@Override
	protected void onCreate(Bundle savedInstanceState) {

		super.onCreate(savedInstanceState);

		setContentView(R.layout.activity_splash);

		twiterManyLocalData = new TwiterManyLocalData(getApplicationContext());
		
		twiterManyLocalData.CreateTable();
		twiterManyLocalData.getAllUsersData();
		
		
		if (MainSingleTon.userdetails.size() == 0) 
		{
		
			Intent intent = new Intent(SplashActivity.this,WelcomeActivity.class);

			startActivity(intent);

			finish();

		} 
		else
		{
			//if app is lunched for 2nd time , get saved data from shared prefernce and sql lite db.
			
			SharedPreferences lifesharedpref=getSharedPreferences("FacebookBoard", Context.MODE_PRIVATE);
			MainSingleTon.userid= lifesharedpref.getString("userid", null);
			if(MainSingleTon.userid!=null)
			{
				ModelUserDatas model=MainSingleTon.userdetails.get(MainSingleTon.userid);
				MainSingleTon.username=model.getUsername();
				MainSingleTon.userimage=model.getUserimage();
				MainSingleTon.accesstoken=model.getUserAcessToken();
				
				Intent in=new Intent(SplashActivity.this,MainActivity.class);
				startActivity(in);
				SplashActivity.this.finish();
				
			}else
			{
				Map.Entry<String,ModelUserDatas> entry=MainSingleTon.userdetails.entrySet().iterator().next();
				 MainSingleTon.userid = entry.getKey();
				 ModelUserDatas value=entry.getValue();
				 MainSingleTon.username=value.getUsername();
					MainSingleTon.userimage=value.getUserimage();
					MainSingleTon.accesstoken=value.getUserAcessToken();
					
					Intent in=new Intent(SplashActivity.this,MainActivity.class);
					startActivity(in);
					SplashActivity.this.finish();
			}
			

		}

	}

	/*private void automaticSignIn() {

		MainSingleTon.signedInStatus = true;

		MainSingleTon.currentTwitterSignedInUser = new ModelUserDatas();

		MainSingleTon.currentTwitterSignedInUser.setUserAcessToken(preferences
				.getString("usertwitteracccesstoken", ""));

		MainSingleTon.currentTwitterSignedInUser.setUserid(preferences
				.getString("usertwitteraccountid", ""));

		MainSingleTon.currentTwitterSignedInUser.setUsername(preferences
				.getString("usertwitterusername", ""));

		// .... Sign in process from this AcessTOken ........ //


	}*/

}
