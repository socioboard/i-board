package com.socioboard.iboardpro.fragments;

import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.lazylist.ImageLoader;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;

public class PhotoViewFragment extends Fragment{

	ImageView image;
	ProgressBar progress;
	public ImageLoader imageLoader;
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		
		View rootView = inflater.inflate(R.layout.photo_view,
				container, false);
		 
		image=(ImageView) rootView.findViewById(R.id.photo_view);
		progress=(ProgressBar) rootView.findViewById(R.id.progrss);
		imageLoader = new ImageLoader(getActivity());
		
		imageLoader.DisplayImage(MainSingleTon.photo_url, image);
		
		
		return rootView;
		
		
	}
}
