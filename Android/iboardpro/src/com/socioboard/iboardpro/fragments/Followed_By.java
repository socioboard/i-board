package com.socioboard.iboardpro.fragments;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.ProgressDialog;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.animation.Interpolator;
import android.view.animation.LinearInterpolator;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.Toast;

import com.socioboard.iboardpro.ConnectionDetector;
import com.socioboard.iboardpro.ConstantTags;
import com.socioboard.iboardpro.ConstantUrl;
import com.socioboard.iboardpro.JSONParser;
import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.adapter.FollowByAdapter;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.models.FollowModel;
import com.socioboard.iboardpro.ui.WaveDrawable;

/**
 * fragment is used for fetching followed by list of user and showing in list
 * view
 */
public class Followed_By extends Fragment {

	ArrayList<FollowModel> arrayList = new ArrayList<FollowModel>();
	JSONParser jParser = new JSONParser();
	FollowByAdapter adapter;
	ListView list;
	private WaveDrawable waveDrawable;
	ImageView progressimage;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View rootView = inflater.inflate(R.layout.fragment_followers,
				container, false);
		list = (ListView) rootView.findViewById(R.id.listView);

		progressimage = (ImageView) rootView.findViewById(R.id.image);

		waveDrawable = new WaveDrawable(Color.parseColor("#8DD2FA"), 500);
		progressimage.setBackground(waveDrawable);

		Interpolator interpolator = new LinearInterpolator();

		waveDrawable.setWaveInterpolator(interpolator);
		waveDrawable.startAnimation();

		ConnectionDetector detector = new ConnectionDetector(getActivity());
		if (detector.isConnectingToInternet()) {
			new getUserFollowers().execute();
		} else {
			Toast.makeText(getActivity(), "Please connect to internet!",
					Toast.LENGTH_LONG).show();
		}

		return rootView;
	}

	class getUserFollowers extends AsyncTask<Void, Void, Void> {

		@Override
		protected void onPreExecute() {
			// TODO Auto-generated method stub
			super.onPreExecute();
			progressimage.setVisibility(View.VISIBLE);
		}

		@Override
		protected Void doInBackground(Void... params) {

			arrayList.clear();
			JSONObject json = jParser
					.getJSONFromUrlByGet(ConstantUrl.URL_FollowedBy
							+ MainSingleTon.accesstoken);
			System.out.println("jsonresponse" + json);
			try {

				JSONObject pagination_obj = json
						.getJSONObject(ConstantTags.TAG_PAGINATION);

				JSONArray data = json.getJSONArray(ConstantTags.TAG_DATA);

				for (int data_i = 0; data_i < data.length(); data_i++) {

					JSONObject data_obj = data.getJSONObject(data_i);
					String str_full_name = data_obj
							.getString(ConstantTags.TAG_FULL_NAME);
					String str_profile_picture = data_obj
							.getString(ConstantTags.TAG_PROFILE_PICTURE);
					String str_id = data_obj.getString(ConstantTags.TAG_ID);
					String str_username = data_obj
							.getString(ConstantTags.TAG_USERNAME);

					FollowModel model = new FollowModel();
					model.setFull_name(str_full_name);
					model.setProfile_pic_url(str_profile_picture);
					model.setUserid(str_id);
					model.setUsername(str_username);
					arrayList.add(model);
					System.out.println("inside array name=str_full_name"
							+ str_full_name);
				}
				JSONObject meta_obj = pagination_obj
						.getJSONObject(ConstantTags.TAG_META);
				String str_code = meta_obj.getString(ConstantTags.TAG_CODE);

			} catch (JSONException e) {
				System.out.println("catch block");
			}

			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			super.onPostExecute(result);

			setAdapter();
			progressimage.setVisibility(View.INVISIBLE);
		}

	}

	void setAdapter() {
		adapter = new FollowByAdapter(getActivity(), arrayList);

		list.setAdapter(adapter);
	}

	@Override
	public void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		list.setAdapter(null);
		adapter.imageLoader.clearCache();
	}
}
