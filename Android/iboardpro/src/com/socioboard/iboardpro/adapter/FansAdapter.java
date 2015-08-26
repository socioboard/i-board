package com.socioboard.iboardpro.adapter;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONObject;

import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.socioboard.iboardpro.JSONParser;
import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.adapter.FollowsAdapter.follow_task;
import com.socioboard.iboardpro.adapter.FollowsAdapter.unfollow_task;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.fragments.Fans_Fragments;
import com.socioboard.iboardpro.lazylist.ImageLoader;
import com.socioboard.iboardpro.models.FollowModel;

public class FansAdapter extends BaseAdapter {

	ArrayList<FollowModel> arrayList;
	FollowModel model;
	Context context;
	public ImageLoader imageLoader;
	private ProgressDialog mSpinner;
	JSONParser jParser = new JSONParser();

	int selected_position;
	public FansAdapter(Context context, ArrayList<FollowModel> arrayList) {
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
	public View getView(final int position, View convertView, ViewGroup parent) {

		model = arrayList.get(position);
		if (convertView == null) {
			LayoutInflater mInflater = (LayoutInflater) context
					.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = mInflater.inflate(R.layout.follow_by_list_item, parent,
					false);
		}
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

			imageLoader.DisplayImage(model.getProfile_pic_url(),
					profile_imagView);

			unfollow_button.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					follow_button.setVisibility(View.VISIBLE);
					unfollow_button.setVisibility(View.INVISIBLE);
					model = arrayList.get(position);

					new unfollow_task().execute(model.getUserid());
				}
			});

			follow_button.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					//follow_button.setVisibility(View.INVISIBLE);
					//unfollow_button.setVisibility(View.VISIBLE);
					selected_position=position;
					model = arrayList.get(position);

					System.out.println("name followingg"+model.getFull_name());
					new follow_task().execute(model.getUserid());
				}
			});
		
		return convertView;
	}

	public class follow_task extends AsyncTask<String, Void, Void> {

		@Override
		protected void onPreExecute() {
			/*mSpinner = new ProgressDialog(context);
			mSpinner.requestWindowFeature(Window.FEATURE_NO_TITLE);
			mSpinner.setMessage("Loading...");

			mSpinner.show();*/
			Fans_Fragments.Fans_arraylist.remove(selected_position);
			Fans_Fragments.adapter.notifyDataSetChanged();
			
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
			//mSpinner.hide();
		}
	}

	public class unfollow_task extends AsyncTask<String, Void, Void> {

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
			nameValuePair.add(new BasicNameValuePair("action", "unfollow"));

			JSONObject json = jParser.getJSONFromUrlByPost(url, nameValuePair);

			System.out.println("Unfollowed user status==" + json);

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
