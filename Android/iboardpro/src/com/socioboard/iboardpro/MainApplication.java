package com.socioboard.iboardpro;

import com.appnext.appnextsdk.AppnextTrack;
import com.flurry.android.FlurryAgent;
import com.parse.Parse;

import android.app.Application;

public class MainApplication extends Application {
	
	@Override
	public void onCreate() {
		// TODO Auto-generated method stub
		super.onCreate();
		AppnextTrack.track(this);
		Parse.initialize(MainApplication.this, "Mkrk7mvkJWi9jlp1vFnoF2XqWujFvMARLS9tNGTF","JaU9gaRLcSELIYBod0fslwniLVAOiMCIEVG7mGrn");
		FlurryAgent.setLogEnabled(false);
		 // init Flurry
        FlurryAgent.init(this, ApplicationData.flurryID);
        
	}

}
