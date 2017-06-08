package com.socioboard.iboardpro;

import java.io.UnsupportedEncodingException;
import java.util.Map;

import android.app.Activity;
import android.app.Dialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.util.Base64;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.socioboard.iboardpro.database.util.InstagramManyLocalData;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.database.util.ModelUserDatas;

public class SplashActivity extends Activity {

	/*
	 * check user already have stored token in local db or not , if there then
	 * redirect to feed fragment(Main activity) or redirect to login screen
	 */

	InstagramManyLocalData twiterManyLocalData;
	
	SharedPreferences preferences;

	@Override
	protected void onCreate(Bundle savedInstanceState) {

		super.onCreate(savedInstanceState);

		
	
		
		setContentView(R.layout.activity_splash);

		ConnectionDetector cd = new ConnectionDetector(getApplicationContext());

		Boolean isInternetPresent = cd.isConnectingToInternet();

		if (isInternetPresent) {
			twiterManyLocalData = new InstagramManyLocalData(
					getApplicationContext());

			twiterManyLocalData.CreateTable();
			twiterManyLocalData.getAllUsersData();

			if (MainSingleTon.userdetails.size() == 0) {

				Intent intent = new Intent(SplashActivity.this,
						WelcomeActivity.class);

				startActivity(intent);

				finish();

			} else {
				// if app is lunched for 2nd time , get saved data from shared
				// prefernce and sql lite db.
				
				SharedPreferences preferences1 = getSharedPreferences("iboardprokey", Context.MODE_PRIVATE);
				String clientid = GetClientIDKeys(ApplicationData.CLIENT_ID);
				String clientsecret = GetClientSecretKeys(ApplicationData.CLIENT_SECRET);

				MainSingleTon.api_key = preferences1.getString(MainSingleTon.Tag_key,
						clientid);
				MainSingleTon.api_secret = preferences1.getString(
						MainSingleTon.Tag_secret, clientsecret);
				MainSingleTon.api_redirect_url = preferences1.getString(
						MainSingleTon.Tag_redirectUri, ApplicationData.CALLBACK_URL);
				
				

				SharedPreferences lifesharedpref = getSharedPreferences(
						"iboardpro", Context.MODE_PRIVATE);
				MainSingleTon.userid = lifesharedpref.getString("userid", null);
				if (MainSingleTon.userid != null) {
					ModelUserDatas model = MainSingleTon.userdetails
							.get(MainSingleTon.userid);
					MainSingleTon.username = model.getUsername();
					MainSingleTon.userimage = model.getUserimage();
					MainSingleTon.accesstoken = model.getUserAcessToken();

					Intent in = new Intent(SplashActivity.this,
							MainActivity.class);
					startActivity(in);
					SplashActivity.this.finish();

				} else {
					Map.Entry<String, ModelUserDatas> entry = MainSingleTon.userdetails
							.entrySet().iterator().next();
					MainSingleTon.userid = entry.getKey();
					ModelUserDatas value = entry.getValue();
					MainSingleTon.username = value.getUsername();
					MainSingleTon.userimage = value.getUserimage();
					MainSingleTon.accesstoken = value.getUserAcessToken();

					Intent in = new Intent(SplashActivity.this,
							MainActivity.class);
					startActivity(in);
					SplashActivity.this.finish();
				}

			}
		} else {

			Toast.makeText(getApplicationContext(), "No Internet Access",
					Toast.LENGTH_LONG).show();
		}

	}

	public String GetClientIDKeys(String key)

	{
		String text1 = null;
		String finalkey = null;
		try {
			byte[] data1 = Base64
					.decode(ApplicationData.base64, Base64.DEFAULT);
			text1 = new String(data1, "UTF-8");
			System.out.println("base64 key" + text1);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();

		}

		try {
			finalkey = Encrypt.decrypt(text1, key);
		} catch (Exception e) {

			e.printStackTrace();
		}

		return finalkey;

	}

	public String GetClientSecretKeys(String key)

	{
		String text1 = null;
		String finalkey = null;
		try {
			byte[] data1 = Base64
					.decode(ApplicationData.base64, Base64.DEFAULT);
			text1 = new String(data1, "UTF-8");

		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();

		}

		try {
			finalkey = Encrypt.decrypt(text1, key);
		} catch (Exception e) {

			e.printStackTrace();
		}

		return finalkey;

	}
}
