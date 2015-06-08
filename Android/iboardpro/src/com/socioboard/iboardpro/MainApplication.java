package com.socioboard.iboardpro;

import com.flurry.android.FlurryAgent;

import android.app.Application;

public class MainApplication extends Application {
	
	@Override
	public void onCreate() {
		// TODO Auto-generated method stub
		super.onCreate();
		
		FlurryAgent.setLogEnabled(false);
		 // init Flurry
        FlurryAgent.init(this, ApplicationData.flurryID);
        
	}

}
