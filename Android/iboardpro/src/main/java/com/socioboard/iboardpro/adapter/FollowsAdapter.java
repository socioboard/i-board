package com.socioboard.iboardpro.adapter;

import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdView;
import com.socioboard.iboardpro.JSONParser;
import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.fragments.Follows_Fragment;
import com.socioboard.iboardpro.models.FollowModel;
import com.squareup.picasso.Picasso;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class FollowsAdapter extends BaseAdapter {

	ArrayList<FollowModel> arrayList;
	FollowModel model;
	Context context;
	private ProgressDialog mSpinner;

	JSONParser jParser = new JSONParser();

	int selected_position;
	AdRequest adRequest;
	public FollowsAdapter(Context context, ArrayList<FollowModel> arrayList) {
		this.arrayList = arrayList;
		this.context = context;
		adRequest = new AdRequest.Builder().build();

	}

	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return arrayList.size();
	}

	@Override
	public FollowModel getItem(int position) {
		// TODO Auto-generated method stub
		return arrayList.get(position);
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {

		model = arrayList.get(position);
		

			if (model.getFull_name().equals("1")) {
				LayoutInflater mInflater = (LayoutInflater) context
						.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
				convertView = mInflater.inflate(R.layout.banner_ad_listitem,
						parent, false);
				AdView mAdView = (AdView) convertView.findViewById(R.id.adView);

			
				mAdView.loadAd(adRequest);
			} else {
				LayoutInflater mInflater = (LayoutInflater) context
						.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
				convertView = mInflater.inflate(R.layout.follow_list_item,
						parent, false);
				ImageView profile_imagView = (ImageView) convertView
						.findViewById(R.id.current_profile_pic);
				TextView user_nameText = (TextView) convertView
						.findViewById(R.id.user_name);
				final ImageView unfollow_button = (ImageView) convertView
						.findViewById(R.id.unfollow_button);
				final ImageView follow_button = (ImageView) convertView
						.findViewById(R.id.follow_button);

				if (model.getFull_name().length() > 2) {
					user_nameText.setText(model.getFull_name());
				} else {
					user_nameText.setText(model.getUsername());
				}
				Picasso.with(context).load(model.getProfile_pic_url()).into(profile_imagView);


				unfollow_button.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// follow_button.setVisibility(View.VISIBLE);
						// unfollow_button.setVisibility(View.INVISIBLE);
						model = arrayList.get(position);
						selected_position = position;
						new unfollow_task().execute(model.getUserid());
					}
				});

				follow_button.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						follow_button.setVisibility(View.INVISIBLE);
						unfollow_button.setVisibility(View.VISIBLE);
						model = arrayList.get(position);

						new follow_task().execute(model.getUserid());
					}
				});

			}

		

		return convertView;
	}

	public class follow_task extends AsyncTask<String, Void, Void> {

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

			String userid = params[0];

			String url = "https://api.instagram.com/v1/users/" + userid
					+ "/relationship/?access_token="
					+ MainSingleTon.accesstoken;
			// key and value pair
			List<NameValuePair> nameValuePair = new ArrayList<NameValuePair>(1);
			nameValuePair.add(new BasicNameValuePair("action", "follow"));

			JSONObject json = jParser.getJSONFromUrlByPost(url, nameValuePair);

			System.out.println("followed user status==" + json);

			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			// TODO Auto-generated method stub
			super.onPostExecute(result);
			mSpinner.hide();
		}
	}

	public class unfollow_task extends AsyncTask<String, Void, Void> {

		@Override
		protected void onPreExecute() {
			/*
			 * mSpinner = new ProgressDialog(context);
			 * mSpinner.requestWindowFeature(Window.FEATURE_NO_TITLE);
			 * mSpinner.setMessage("Loading...");
			 * 
			 * mSpinner.show();
			 */

			Follows_Fragment.arrayList.remove(selected_position);
			Follows_Fragment.adapter.notifyDataSetChanged();
			super.onPreExecute();
		}

		@Override
		protected Void doInBackground(String... params) {

			String userid = params[0];

			String url = "https://api.instagram.com/v1/users/" + userid
					+ "/relationship/?access_token="
					+ MainSingleTon.accesstoken;
			// key and value pair
			List<NameValuePair> nameValuePair = new ArrayList<NameValuePair>(1);
			nameValuePair.add(new BasicNameValuePair("action", "unfollow"));

			JSONObject json = jParser.getJSONFromUrlByPost(url, nameValuePair);

			System.out.println("Unfollowed user status==" + json);

			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			// TODO Auto-generated method stub
			super.onPostExecute(result);
			// mSpinner.hide();
		}
	}
}
