package com.socioboard.iboardpro.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.lazylist.ImageLoader;
import com.socioboard.iboardpro.models.FollowModel;

public class FollowByAdapter extends BaseAdapter {

	ArrayList<FollowModel> arrayList;
	FollowModel model;
	Context context;
	public ImageLoader imageLoader;

	public FollowByAdapter(Context context, ArrayList<FollowModel> arrayList) {
		this.arrayList = arrayList;
		this.context = context;
		imageLoader = new ImageLoader(context);
	}

	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return arrayList.size();
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

		model = arrayList.get(position);
		if (convertView == null) {
			LayoutInflater mInflater = (LayoutInflater) context
					.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = mInflater.inflate(R.layout.follow_by_list_item,
					parent, false);
		}

		ImageView profile_imagView = (ImageView) convertView
				.findViewById(R.id.current_profile_pic);
		TextView user_nameText = (TextView) convertView
				.findViewById(R.id.user_name);
		ImageView follow_button = (ImageView) convertView
				.findViewById(R.id.follow_button);

		if (model.getFull_name().length() > 2) {
			user_nameText.setText(model.getFull_name());
		} else {
			user_nameText.setText(model.getUsername());
		}

		imageLoader.DisplayImage(model.getProfile_pic_url(), profile_imagView);

		return convertView;
	}

}
