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
import android.view.animation.Interpolator;
import android.view.animation.LinearInterpolator;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.ImageView;
import android.widget.ListView;

import com.socioboard.iboardpro.ConstantTags;
import com.socioboard.iboardpro.ConstantUrl;
import com.socioboard.iboardpro.JSONParser;
import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.adapter.FollowsAdapter;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.fragments.Feeds_Fragments.GetpagedUserdata;
import com.socioboard.iboardpro.models.FollowModel;
import com.socioboard.iboardpro.ui.WaveDrawable;

/**
 * fragment is used for fetching follows list of user and showing in list view
 */
public class Follows_Fragment extends Fragment implements OnScrollListener {

	public static ArrayList<FollowModel> arrayList = new ArrayList<FollowModel>();
	JSONParser jParser = new JSONParser();
	public static FollowsAdapter adapter;
	ListView list;

	private WaveDrawable waveDrawable;
	ImageView progressimage;

	// loadmore
	ViewGroup viewGroup;
	boolean isAlreadyScrolling = true;
	String nexturl;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View rootView = inflater.inflate(R.layout.fragment_followers,
				container, false);
		list = (ListView) rootView.findViewById(R.id.listView);
		addFooterView();
		list.setOnScrollListener(Follows_Fragment.this);
		progressimage = (ImageView) rootView.findViewById(R.id.image);

		waveDrawable = new WaveDrawable(Color.parseColor("#8DD2FA"), 500);
		progressimage.setBackground(waveDrawable);

		Interpolator interpolator = new LinearInterpolator();

		waveDrawable.setWaveInterpolator(interpolator);
		waveDrawable.startAnimation();

		new getUserFollowers().execute();
		return rootView;
	}

	private void addFooterView() {

		LayoutInflater inflater = getActivity().getLayoutInflater();

		viewGroup = (ViewGroup) inflater.inflate(R.layout.progress_layout,
				list, false);

		list.addFooterView(viewGroup);

	}

	class getUserFollowers extends AsyncTask<Void, Void, Void> {

		@Override
		protected void onPreExecute() {
			progressimage.setVisibility(View.VISIBLE);
			super.onPreExecute();

		}

		@Override
		protected Void doInBackground(Void... params) {

			arrayList.clear();
			JSONObject json = jParser
					.getJSONFromUrlByGet(ConstantUrl.URL_Follows
							+ MainSingleTon.accesstoken);
			System.out.println("Follow url" + ConstantUrl.URL_Follows
					+ MainSingleTon.accesstoken);
			System.out.println("jsonresponse" + json);
			try {

				if (json.has("pagination")) {
					JSONObject jsonObject = json.getJSONObject("pagination");
					if (jsonObject.has("next_url")) {
						nexturl = jsonObject.getString("next_url");
					}

				}

				System.out.println("follow user next url" + nexturl);

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

			} catch (JSONException e) {
				System.out.println("catch block");
			}

			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			super.onPostExecute(result);

			setAdapter();
			isAlreadyScrolling = false;
			progressimage.setVisibility(View.INVISIBLE);

		}

	}

	class getPagedFollowers extends AsyncTask<String, Void, Void> {

		@Override
		protected void onPreExecute() {

			super.onPreExecute();

		}

		@Override
		protected Void doInBackground(String... params) {

			String next_url = params[0].toString();

			JSONObject json = jParser.getJSONFromUrlByGet(next_url);

			System.out.println("jsone respnse after loadmore"+json);
			try {

				if (json.has("pagination")) {
					
					System.out.println("has peginaion true");
					
					JSONObject jsonObject = json.getJSONObject("pagination");
					if (jsonObject.has("next_url")) {
						nexturl = jsonObject.getString("next_url");
						System.out.println("nexturl"+nexturl);
					}
					else {
						nexturl=null;
					}

				}
				

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

			} catch (JSONException e) {
				System.out.println("catch block");
				e.printStackTrace();
			}

			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			super.onPostExecute(result);

			System.out.println("$$$$$$$$$$$$$$$$$$$$$$$");

			viewGroup.setVisibility(View.INVISIBLE);
			int listCount = list.getCount();
			list.setScrollY(listCount);
			adapter.notifyDataSetChanged();
			isAlreadyScrolling = false;

		}

	}

	public void setAdapter() {
		adapter = new FollowsAdapter(getActivity(), arrayList);

		list.setAdapter(adapter);
	}

	@Override
	public void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();

	}

	@Override
	public void onScrollStateChanged(AbsListView view, int scrollState) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onScroll(AbsListView view, int firstVisibleItem,
			int visibleItemCount, int totalItemCount) {

		/* maybe add a padding */

		boolean loadMore = firstVisibleItem + visibleItemCount >= totalItemCount;

		if (loadMore) {

			System.out.println("inside loadmore adapter coumt");
			if (isAlreadyScrolling) {

			} else {

				viewGroup.setVisibility(View.VISIBLE);

				isAlreadyScrolling = true;
				System.out.println("adapter.getCount()" + adapter.getCount());
				if (adapter.getCount() != 0) {
					System.out.println("inside adapter.getCount()"
							+ adapter.getCount());
					if (nexturl != null) {
						new getPagedFollowers().execute(nexturl);
					}
					else {
						viewGroup.setVisibility(View.INVISIBLE);
					}

				} else {
					
				}
			}

		} else {

		}

	}

}
