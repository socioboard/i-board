package com.socioboard.iboardpro.adapter;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONObject;

import android.app.ProgressDialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.os.AsyncTask;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.view.View.OnLongClickListener;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.socioboard.iboardpro.CommonUtilss;
import com.socioboard.iboardpro.JSONParser;
import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.lazylist.ImageLoader;
import com.socioboard.iboardpro.models.FeedsModel;

public class FeedsAdapter extends BaseAdapter {

	ArrayList<FeedsModel> arrayList;
	FeedsModel model;
	Context context;
	JSONParser jParser = new JSONParser();
	public ImageLoader imageLoader;
	CommonUtilss commonUtilss;
	private int lastPosition = -1;
	private ProgressDialog mSpinner;

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
	public FeedsModel getItem(int position) {
		// TODO Auto-generated method stub
		return arrayList.get(position);
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
		final ImageView likeimg = (ImageView) convertView
				.findViewById(R.id.like_imgview);
		LinearLayout like_buttn = (LinearLayout) convertView
				.findViewById(R.id.likelayout);

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

		System.out.println("IMAGE URL" + model.getLow_resolution_url());

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

		Animation animation = AnimationUtils.loadAnimation(context,
				(position > lastPosition) ? R.anim.up_from_bottom
						: R.anim.down_from_top);
		convertView.startAnimation(animation);
		lastPosition = position;

		like_buttn.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				if (model.getIslike()) {
					model.setIslike(false);
					likeimg.setImageResource(R.drawable.icon_like);
				} else {
					model.setIslike(true);
					likeimg.setImageResource(R.drawable.red_like);
				}
				new like_task().execute(model.getFeed_post_id());

			}
		});

		return convertView;
	}

	public class like_task extends AsyncTask<String, Void, Void> {

		@Override
		protected void onPreExecute() {
			mSpinner = new ProgressDialog(context);
			mSpinner.requestWindowFeature(Window.FEATURE_NO_TITLE);
			mSpinner.setMessage("Loading...");

			mSpinner.show();
			super.onPreExecute();
		}

		@Override
		protected Void doInBackground(String... params) {

			String media_id = params[0];

			String url = "https://api.instagram.com/v1/media/" + media_id
					+ "/likes/?access_token=" + MainSingleTon.accesstoken;
			// key and value pair
			List<NameValuePair> nameValuePair = new ArrayList<NameValuePair>(1);
			nameValuePair.add(new BasicNameValuePair("action", "likes"));

			JSONObject json = jParser.getJSONFromUrlByPost(url, nameValuePair);

			System.out.println("Likes photo status==" + json);

			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			// TODO Auto-generated method stub
			super.onPostExecute(result);
			mSpinner.hide();

		}
	}

}
