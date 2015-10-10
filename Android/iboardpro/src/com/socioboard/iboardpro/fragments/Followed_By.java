package com.socioboard.iboardpro.fragments;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Build;
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
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.Request.Method;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.socioboard.iboardpro.AppController;
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
public class Followed_By extends Fragment implements OnScrollListener {

	ArrayList<FollowModel> arrayList = new ArrayList<FollowModel>();
	JSONParser jParser = new JSONParser();
	FollowByAdapter adapter;
	ListView list;
	private WaveDrawable waveDrawable;
	ImageView progressimage;

	// loadmore
	ViewGroup viewGroup;
	boolean isAlreadyScrolling = true;
	String nexturl;
	private String tag_json_obj = "jobj_req", tag_json_arry = "jarray_req";
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View rootView = inflater.inflate(R.layout.fragment_followers,
				container, false);
		list = (ListView) rootView.findViewById(R.id.listView);
		addFooterView();
		list.setOnScrollListener(Followed_By.this);
		progressimage = (ImageView) rootView.findViewById(R.id.image);

		waveDrawable = new WaveDrawable(Color.parseColor("#8DD2FA"), 500);
		if (Build.VERSION.SDK_INT >= 16) {

			progressimage.setBackground(waveDrawable);

		} else {

			progressimage.setBackgroundDrawable(waveDrawable);
		}

		Interpolator interpolator = new LinearInterpolator();

		waveDrawable.setWaveInterpolator(interpolator);
		waveDrawable.startAnimation();

		ConnectionDetector detector = new ConnectionDetector(getActivity());
		if (detector.isConnectingToInternet()) {
			FetchFollowed_by();
		} else {
			Toast.makeText(getActivity(), "Please connect to internet!",
					Toast.LENGTH_LONG).show();
		}

		return rootView;
	}

	private void addFooterView() {

		LayoutInflater inflater = getActivity().getLayoutInflater();

		viewGroup = (ViewGroup) inflater.inflate(R.layout.progress_layout,
				list, false);

		list.addFooterView(viewGroup);

	}

	/**
	 * Making json object request
	 * */
	private void FetchFollowed_by() {
		progressimage.setVisibility(View.VISIBLE);
		arrayList.clear();
		JsonObjectRequest jsonObjReq = new JsonObjectRequest(Method.GET,
				ConstantUrl.URL_FollowedBy
				+ MainSingleTon.accesstoken, null,
				new Response.Listener<JSONObject>() {

					@Override
					public void onResponse(JSONObject json) {

						try {

							if (json.has("pagination")) {
								JSONObject jsonObject = json.getJSONObject("pagination");
								if (jsonObject.has("next_url")) {
									nexturl = jsonObject.getString("next_url");
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

							}

						} catch (Exception e) {
							e.printStackTrace();
						}
						setAdapter();
						isAlreadyScrolling = false;
						progressimage.setVisibility(View.INVISIBLE);
					}
				}, new Response.ErrorListener() {

					@Override
					public void onErrorResponse(VolleyError error) {
						progressimage.setVisibility(View.INVISIBLE);
					}
				}) {

			/**
			 * Passing some request headers
			 * */
			@Override
			public Map<String, String> getHeaders() throws AuthFailureError {
				HashMap<String, String> headers = new HashMap<String, String>();
				headers.put("Content-Type", "application/json");
				return headers;
			}

		};

		// Adding request to request queue
		AppController.getInstance().addToRequestQueue(jsonObjReq, tag_json_obj);

		// Cancelling request
		// ApplicationController.getInstance().getRequestQueue().cancelAll(tag_json_obj);
	}

	private void FetchLoadMoreFollowedBy(String next_url) {
		
		JsonObjectRequest jsonObjReq = new JsonObjectRequest(Method.GET,
				next_url, null,
				new Response.Listener<JSONObject>() {

					@Override
					public void onResponse(JSONObject json) {

						try {

							if (json.has("pagination")) {
								JSONObject jsonObject = json.getJSONObject("pagination");
								if (jsonObject.has("next_url")) {
									nexturl = jsonObject.getString("next_url");
								}
								else {
									nexturl = null;
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

							}

						} catch (Exception e) {
							e.printStackTrace();
						}

						viewGroup.setVisibility(View.INVISIBLE);
						int listCount = list.getCount();
						list.setScrollY(listCount);
						adapter.notifyDataSetChanged();
						isAlreadyScrolling = false;
					}
				}, new Response.ErrorListener() {

					@Override
					public void onErrorResponse(VolleyError error) {
					
					}
				}) {

			/**
			 * Passing some request headers
			 * */
			@Override
			public Map<String, String> getHeaders() throws AuthFailureError {
				HashMap<String, String> headers = new HashMap<String, String>();
				headers.put("Content-Type", "application/json");
				return headers;
			}

		};

		// Adding request to request queue
		AppController.getInstance().addToRequestQueue(jsonObjReq, tag_json_obj);

		// Cancelling request
		// ApplicationController.getInstance().getRequestQueue().cancelAll(tag_json_obj);
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
			
			try {

				if (json.has("pagination")) {
					JSONObject jsonObject = json.getJSONObject("pagination");
					if (jsonObject.has("next_url")) {
						nexturl = jsonObject.getString("next_url");
					}

					
				}

				
				if (json.has(ConstantTags.TAG_DATA)) {
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

	class getUserPagedFollowers extends AsyncTask<String, Void, Void> {

		@Override
		protected void onPreExecute() {
			// TODO Auto-generated method stub
			super.onPreExecute();

		}

		@Override
		protected Void doInBackground(String... params) {

			String next_url = params[0].toString();

			JSONObject json = jParser.getJSONFromUrlByGet(next_url);
			System.out.println("jsonresponse" + json);
			try {

				if (json.has("pagination")) {
					JSONObject jsonObject = json.getJSONObject("pagination");
					if (jsonObject.has("next_url")) {
						nexturl = jsonObject.getString("next_url");
					}
					else {
						nexturl = null;
					}

				}

			
				if (json.has(ConstantTags.TAG_DATA)) {
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
			}

			} catch (JSONException e) {
				System.out.println("catch block");
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
				
				if (adapter!=null) {
					
				
				if (adapter.getCount() != 0) {
					System.out.println("inside adapter.getCount()"
							+ adapter.getCount());
					if (nexturl != null) {
						FetchLoadMoreFollowedBy(nexturl);
					} else {
						viewGroup.setVisibility(View.INVISIBLE);
					}

				} }
			}

		} 

	}
}
