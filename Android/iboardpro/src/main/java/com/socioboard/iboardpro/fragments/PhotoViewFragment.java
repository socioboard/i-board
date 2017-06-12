package com.socioboard.iboardpro.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;

import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.squareup.picasso.Picasso;

public class PhotoViewFragment extends Fragment{

	ImageView image;
	ProgressBar progress;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		
		View rootView = inflater.inflate(R.layout.photo_view,
				container, false);
		 
		image=(ImageView) rootView.findViewById(R.id.photo_view);
		progress=(ProgressBar) rootView.findViewById(R.id.progrss);

		Picasso.with(getActivity()).load(MainSingleTon.photo_url).into(image);

		
		
		return rootView;
		
		
	}
}
