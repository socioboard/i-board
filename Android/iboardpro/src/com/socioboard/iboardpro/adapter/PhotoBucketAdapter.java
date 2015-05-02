package com.socioboard.iboardpro.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;

import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.lazylist.ImageLoader;
import com.socioboard.iboardpro.models.UserMediaModel;

public class PhotoBucketAdapter extends BaseAdapter {

	Context context;
	ArrayList<UserMediaModel> list;
	public ImageLoader imageLoader;

	public PhotoBucketAdapter(Context context, ArrayList<UserMediaModel> list) {
		this.context = context;
		this.list = list;
		imageLoader = new ImageLoader(context);
	}

	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return list.size();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {

		UserMediaModel model = new UserMediaModel();

		model = list.get(position);
		if (convertView == null) {
			LayoutInflater mInflater = (LayoutInflater) context
					.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = mInflater.inflate(R.layout.photo_bucket_listitem,
					parent, false);
		}

		ImageView profile_imagView = (ImageView) convertView
				.findViewById(R.id.image);

		imageLoader.DisplayImage(model.getLow_resolution_url(),
				profile_imagView);
		return convertView;
	}

}
