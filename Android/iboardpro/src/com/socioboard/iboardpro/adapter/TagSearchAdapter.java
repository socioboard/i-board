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
import com.socioboard.iboardpro.models.TagModel;

public class TagSearchAdapter extends BaseAdapter {

	ArrayList<TagModel> arrayList;
	TagModel model;
	Context context;

	public TagSearchAdapter(Context context, ArrayList<TagModel> arrayList) {
		this.arrayList = arrayList;
		this.context = context;

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
			convertView = mInflater.inflate(R.layout.tag_search_item,
					parent, false);
		}

		
		TextView name = (TextView) convertView
				.findViewById(R.id.name);
		
        TextView count=(TextView) convertView.findViewById(R.id.count);
	
        name.setText("#"+model.getName());
		count.setText(model.getMedia_count()+" posts");

		return convertView;
	}

}
