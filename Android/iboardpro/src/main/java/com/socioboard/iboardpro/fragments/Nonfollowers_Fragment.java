package com.socioboard.iboardpro.fragments;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.ProgressDialog;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Build;
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

import com.android.volley.AuthFailureError;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.Request.Method;
import com.android.volley.toolbox.JsonObjectRequest;
import com.socioboard.iboardpro.AppController;
import com.socioboard.iboardpro.ConnectionDetector;
import com.socioboard.iboardpro.ConstantTags;
import com.socioboard.iboardpro.ConstantUrl;
import com.socioboard.iboardpro.JSONParser;
import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.adapter.FollowsAdapter;
import com.socioboard.iboardpro.adapter.NonFollowersAdapter;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.models.FollowModel;
import com.socioboard.iboardpro.ui.WaveDrawable;

/**
 * fragment is used for fetching nonfollowers list of user and showing in list
 * viewCreated by Daniel on 09.11.2014.
 */
public class Nonfollowers_Fragment extends Fragment {

	ArrayList<FollowModel> Follows_arrayList = new ArrayList<FollowModel>();
	ArrayList<FollowModel> Followed_by_arrayList = new ArrayList<FollowModel>();
	JSONParser jParser = new JSONParser();
	public static ArrayList<FollowModel> Non_follwer_arraylist = new ArrayList<FollowModel>();
	
	private String tag_json_obj = "jobj_req", tag_json_arry = "jarray_req";
	public static NonFollowersAdapter adapter;
	
	ListView list;
	private WaveDrawable waveDrawable;
	ImageView progressimage;
	String nexturl;
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View rootView = inflater.inflate(R.layout.fragment_followers,
				container, false);

		list = (ListView) rootView.findViewById(R.id.listView);
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
			FetchFollows();
		} else {
			Toast.makeText(getActivity(), "Please connect to internet!",
					Toast.LENGTH_LONG).show();
		}

		return rootView;
	}
	
	
	/**
	 * Making json object request
	 * */
	private void FetchFollows() {
		progressimage.setVisibility(View.VISIBLE);
		Follows_arrayList.clear();
		JsonObjectRequest jsonObjReq = new JsonObjectRequest(Method.GET,
				ConstantUrl.URL_Follows
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
								Follows_arrayList.add(model);

							}

						} catch (Exception e) {
							e.printStackTrace();
						}
				
						
						FetchFollowed_by();
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

	
	/**
	 * Making json object request
	 * */
	private void FetchFollowed_by() {
	
		Followed_by_arrayList.clear();
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
								Followed_by_arrayList.add(model);

							}
						
						} catch (Exception e) {
							e.printStackTrace();
						}
						
					
						
						
						Non_follwer_arraylist.clear();
						System.out.println("arrayList" + Followed_by_arrayList.size());
						// setAdapter();

						for (int i = 0; i < Follows_arrayList.size(); i++) {

							boolean isContain = false;
							for (int j = 0; j < Followed_by_arrayList.size(); j++) {
								if (Follows_arrayList.get(i).getUserid()
										.equals(Followed_by_arrayList.get(j).getUserid())) {
									isContain = true;
								}

							}

							if (!isContain) {
								FollowModel model = new FollowModel();
								model.setFull_name(Follows_arrayList.get(i).getFull_name());
								model.setProfile_pic_url(Follows_arrayList.get(i)
										.getProfile_pic_url());
								model.setUserid(Follows_arrayList.get(i).getUserid());
								model.setUsername(Follows_arrayList.get(i).getUsername());
								
								
								Non_follwer_arraylist.add(model);
								if (i % 4 == 0) {
									if (i != 0) {
										//if full name is "1" then inflate banner ad
										FollowModel model1 = new FollowModel();
										model1.setFull_name("1");
										Non_follwer_arraylist.add(model1);
									}

								}
							}
							
						

						}
						progressimage.setVisibility(View.INVISIBLE);
						setAdapter();
						
						
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

	

	/*class getUserFollowers extends AsyncTask<Void, Void, Void> {

		@Override
		protected void onPreExecute() {
			// TODO Auto-generated method stub
			super.onPreExecute();
			progressimage.setVisibility(View.VISIBLE);
		}

		@Override
		protected Void doInBackground(Void... params) {

			Follows_arrayList.clear();
			JSONObject json = jParser
					.getJSONFromUrlByGet(ConstantUrl.URL_Follows
							+ MainSingleTon.accesstoken);
			System.out.println("jsonresponse" + json);
			try {

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
					Follows_arrayList.add(model);
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
			System.out.println("arrayList" + Follows_arrayList.size());
			// setAdapter();
			new getFollowedBy().execute();
		}

	}
*/
	/*class getFollowedBy extends AsyncTask<Void, Void, Void> {

		@Override
		protected Void doInBackground(Void... params) {

			Followed_by_arrayList.clear();
			JSONObject json = jParser
					.getJSONFromUrlByGet(ConstantUrl.URL_FollowedBy
							+ MainSingleTon.accesstoken);
			System.out.println("jsonresponse" + json);
			try {

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
					Followed_by_arrayList.add(model);
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
			Non_follwer_arraylist.clear();
			System.out.println("arrayList" + Followed_by_arrayList.size());
			// setAdapter();

			for (int i = 0; i < Follows_arrayList.size(); i++) {

				boolean isContain = false;
				for (int j = 0; j < Followed_by_arrayList.size(); j++) {
					if (Follows_arrayList.get(i).getUserid()
							.equals(Followed_by_arrayList.get(j).getUserid())) {
						isContain = true;
					}

				}

				if (!isContain) {
					FollowModel model = new FollowModel();
					model.setFull_name(Follows_arrayList.get(i).getFull_name());
					model.setProfile_pic_url(Follows_arrayList.get(i)
							.getProfile_pic_url());
					model.setUserid(Follows_arrayList.get(i).getUserid());
					model.setUsername(Follows_arrayList.get(i).getUsername());
					Non_follwer_arraylist.add(model);
				}

			}

			setAdapter();

		}

	}
*/
	void setAdapter() {
		adapter = new NonFollowersAdapter(getActivity(), Non_follwer_arraylist);

		list.setAdapter(adapter);
		progressimage.setVisibility(View.INVISIBLE);
	}

	@Override
	public void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		list.setAdapter(null);
		adapter.imageLoader.clearCache();
	}
}
