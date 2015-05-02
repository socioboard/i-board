package com.socioboard.iboardpro;

import com.socioboard.iboardpro.database.util.MainSingleTon;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;

/*
 * this is blank activity to pass intent from notification to instagram oficial app
 */

public class Blankscheduleactivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		
		
		
		SharedPreferences sharedpref=getSharedPreferences("SavePhoto", Context.MODE_PRIVATE);
		String imagepath=sharedpref.getString("photostring", "");
		String caption= sharedpref.getString("caption", "");
		
		Intent shareIntent = new Intent(
				android.content.Intent.ACTION_SEND);
		shareIntent.setType("image/*");
		shareIntent.putExtra(Intent.EXTRA_STREAM,Uri.parse("file://" + imagepath));
		shareIntent.putExtra(Intent.EXTRA_TEXT, caption);
		shareIntent.setPackage("com.instagram.android");
		startActivity(shareIntent);
	}
}
