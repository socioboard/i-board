package com.socioboard.iboardpro.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnLongClickListener;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.socioboard.iboardpro.CommonUtilss;
import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.lazylist.ImageLoader;
import com.socioboard.iboardpro.models.FeedsModel;

public class FeedsAdapter extends BaseAdapter {

	ArrayList<FeedsModel> arrayList;
	FeedsModel model;
	Context context;
	public ImageLoader imageLoader;
	CommonUtilss commonUtilss;
	private int lastPosition = -1;
	public FeedsAdapter(Context context, ArrayList<FeedsModel> arrayList) {
		this.arrayList = arrayList;
		this.context = context;
		imageLoader = new ImageLoader(context);
		commonUtilss = new CommonUtilss();
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
			convertView = mInflater.inflate(R.layout.feeds_list_item, parent,
					false);
		}

		final ImageView profile_imagView = (ImageView) convertView
				.findViewById(R.id.image);
		TextView like_countText = (TextView) convertView
				.findViewById(R.id.like_count_text);
		TextView comment_countText = (TextView) convertView
				.findViewById(R.id.comment_count_text);
		ImageView user_profile_pic = (ImageView) convertView
				.findViewById(R.id.current_profile_pic);
		TextView username = (TextView) convertView.findViewById(R.id.username);
		ImageView likeimg = (ImageView) convertView
				.findViewById(R.id.like_imgview);

		like_countText.setText(model.getLikes_count());
		comment_countText.setText(model.getComments_count());
		username.setText(model.getFrom_fullname());
		// user_nameText.setText(model.getFull_name());

		if (model.getIslike()) {
			likeimg.setImageResource(R.drawable.red_like);
		} else {
			likeimg.setImageResource(R.drawable.icon_like);
		}

		imageLoader.DisplayImage(model.getLow_resolution_url(),
				profile_imagView);
		
		System.out.println("IMAGE URL"+model.getLow_resolution_url());

		imageLoader.DisplayImage(model.getFrom_profilepicture(),
				user_profile_pic);

		// new
		// getBitmap(profile_imagView).execute(model.getLow_resolution_url());

		// new
		// getBitmap(user_profile_pic).execute(model.getFrom_profilepicture());

		profile_imagView.setOnLongClickListener(new OnLongClickListener() {

			@Override
			public boolean onLongClick(View v) {

				Bitmap bitmap = ((BitmapDrawable) profile_imagView
						.getDrawable()).getBitmap();

				commonUtilss.savePhoto(bitmap, context);
				return false;
			}
		});


		 Animation animation = AnimationUtils.loadAnimation(context, (position > lastPosition) ? R.anim.up_from_bottom : R.anim.down_from_top);
		    convertView.startAnimation(animation);
		    lastPosition = position;
		return convertView;
	}

}
