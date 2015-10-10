package com.socioboard.iboardpro.fragments;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Base64;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.animation.Interpolator;
import android.view.animation.LinearInterpolator;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;

import com.socioboard.iboardpro.ApplicationData;
import com.socioboard.iboardpro.ConstantTags;
import com.socioboard.iboardpro.Encrypt;
import com.socioboard.iboardpro.JSONParser;
import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.adapter.CopyFollowAdapter;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.models.FollowModel;
import com.socioboard.iboardpro.ui.WaveDrawable;

public class Copy_follows extends Fragment implements OnScrollListener {

	String getUserIDURl = "https://api.instagram.com/v1/users/search?q=";

	private String[] choose_category;
	JSONParser jParser = new JSONParser();
	int mainposition = 0;
	ListView list;
	TextView alerttext;
	public static ArrayList<FollowModel> follows_arrayList = new ArrayList<FollowModel>();

	private WaveDrawable waveDrawable;
	ImageView progressimage;

	public static CopyFollowAdapter adapter;
	// loadmore
	ViewGroup viewGroup;
	boolean isAlreadyScrolling = true;
	String nexturl;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View rootView = inflater.inflate(R.layout.copy_follows_fragment,
				container, false);

		Spinner spinner = (Spinner) rootView.findViewById(R.id.spinner);
		ImageView searchView = (ImageView) rootView
				.findViewById(R.id.searchimage);
		list = (ListView) rootView.findViewById(R.id.listview);

		addFooterView();
		list.setOnScrollListener(Copy_follows.this);

		choose_category = getResources().getStringArray(R.array.chooselist);
		alerttext = (TextView) rootView.findViewById(R.id.alerttext);

		alerttext.setVisibility(View.INVISIBLE);
		final EditText text = (EditText) rootView
				.findViewById(R.id.captionText);

		ArrayAdapter<String> dataAdapter = new ArrayAdapter<String>(
				getActivity(), android.R.layout.simple_spinner_item,
				choose_category);
		dataAdapter
				.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
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

		spinner.setAdapter(dataAdapter);

		spinner.setOnItemSelectedListener(new OnItemSelectedListener() {

			@Override
			public void onItemSelected(AdapterView<?> parent, View view,
					int position, long id) {
				TextView selectedText = (TextView) parent.getChildAt(0);
				if (selectedText != null) {
					selectedText.setTextColor(Color.WHITE);

				}

				if (position == 0) {
					mainposition = 0;

					System.out.println("POSITION==========" + position);
				} else {

					System.out.println("POSITION else==========" + position);
					mainposition = 1;
				}
			}

			@Override
			public void onNothingSelected(AdapterView<?> arg0) {

			}
		});

		searchView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				alerttext.setVisibility(View.INVISIBLE);

				String user = text.getText().toString();

				if (user.length() > 0) {

					new getUserNameFromID().execute(user);
				}

			}
		});

		SetAdapter();
		
		if (follows_arrayList.size()==0) {
			viewGroup.setVisibility(View.INVISIBLE);
		}
		return rootView;

	}
	
	private void addFooterView() {

		LayoutInflater inflater = getActivity().getLayoutInflater();

		viewGroup = (ViewGroup) inflater.inflate(R.layout.progress_layout,
				list, false);

		list.addFooterView(viewGroup);

	}

	class getUserNameFromID extends AsyncTask<String, Void, Void> {

		String id;

		@Override
		protected void onPreExecute() {
			// TODO Auto-generated method stub
			super.onPreExecute();
			progressimage.setVisibility(View.VISIBLE);
			list.setVisibility(View.INVISIBLE);
		}

		@Override
		protected Void doInBackground(String... params) {

			String username = params[0];
			
			JSONObject json = jParser.getJSONFromUrlByGet(getUserIDURl
					+ username.replace(" ", "%20") + "&client_id=" + GetClientIDKeys(ApplicationData.CLIENT_ID));

			
			try {
				if (json.has(ConstantTags.TAG_DATA)) {
					
				
				JSONArray data = json.getJSONArray(ConstantTags.TAG_DATA);
				if (data.length() > 0) {
					JSONObject object = data.getJSONObject(0);
					id = object.getString(ConstantTags.TAG_ID);

				}
				}
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				progressimage.setVisibility(View.INVISIBLE);
			}

			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			super.onPostExecute(result);
		
			list.setVisibility(View.VISIBLE);
			String url;

			if (id != null) {

				if (mainposition == 0) {

					url = "https://api.instagram.com/v1/users/" + id
							+ "/follows/?access_token="
							+ MainSingleTon.accesstoken;
				}

				else {
					url = "https://api.instagram.com/v1/users/" + id
							+ "/followed-by/?access_token="
							+ MainSingleTon.accesstoken;
				}

				new getUserFollowers().execute(url);
			} else {
				list.setVisibility(View.INVISIBLE);
				progressimage.setVisibility(View.INVISIBLE);
				alerttext.setVisibility(View.VISIBLE);
			}
		}
	}

	class getUserFollowers extends AsyncTask<String, Void, Void> {

		@Override
		protected void onPreExecute() {
			// TODO Auto-generated method stub
			super.onPreExecute();
			follows_arrayList.clear();
			adapter.notifyDataSetChanged();

		}

		@Override
		protected Void doInBackground(String... params) {

			String url = params[0];

			
			JSONObject json = jParser.getJSONFromUrlByGet(url);
			System.out.println("jsonresponse" + json);
			try {

				if (json.has("pagination")) {
					JSONObject jsonObject = json.getJSONObject("pagination");
					if (jsonObject.has("next_url")) {
						nexturl = jsonObject.getString("next_url");
					}

				}
				
				if (json.has(ConstantTags.TAG_DATA)) {
				JSONArray data = json.getJSONArray(ConstantTags.TAG_DATA);

				if (data.length() > 0) {

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
						follows_arrayList.add(model);
						System.out.println("inside array name=str_full_name"
								+ str_full_name);
						if (data_i % 4 == 0) {
							if (data_i != 0) {
								//if full name is "1" then inflate banner ad
								FollowModel model1 = new FollowModel();
								model1.setFull_name("1");
								follows_arrayList.add(model1);
							}

						}
					}
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
			progressimage.setVisibility(View.INVISIBLE);
			if (follows_arrayList.size() > 0) {
				list.setVisibility(View.VISIBLE);
				adapter.notifyDataSetChanged();
			} else {
				list.setVisibility(View.INVISIBLE);
				alerttext.setVisibility(View.VISIBLE);
			}
			isAlreadyScrolling = false;
			progressimage.setVisibility(View.INVISIBLE);
		}

	}

	class getPagedUserFollowers extends AsyncTask<String, Void, Void> {

		@Override
		protected void onPreExecute() {
			// TODO Auto-generated method stub
			super.onPreExecute();

		}

		@Override
		protected Void doInBackground(String... params) {

			String url = params[0];

			JSONObject json = jParser.getJSONFromUrlByGet(url);
			System.out.println("jsonresponse" + json);
			try {

				if (json.has("pagination")) {

					System.out.println("has peginaion true");

					JSONObject jsonObject = json.getJSONObject("pagination");
					if (jsonObject.has("next_url")) {
						nexturl = jsonObject.getString("next_url");
						System.out.println("nexturl" + nexturl);
					} else {
						nexturl = null;
					}

				}
			

				if (json.has(ConstantTags.TAG_DATA)) {
					
			
				JSONArray data = json.getJSONArray(ConstantTags.TAG_DATA);

				if (data.length() > 0) {

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
						follows_arrayList.add(model);
						if (data_i % 4 == 0) {
							if (data_i != 0) {
								//if full name is "1" then inflate banner ad
								FollowModel model1 = new FollowModel();
								model1.setFull_name("1");
								follows_arrayList.add(model1);
							}

						}
					}
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
			progressimage.setVisibility(View.INVISIBLE);
			
			
			System.out.println("$$$$$$$$$$$$$$$$$$$$$$$");

			viewGroup.setVisibility(View.INVISIBLE);
			int listCount = list.getCount();
			list.setScrollY(listCount);
			adapter.notifyDataSetChanged();
			isAlreadyScrolling = false;
			
			
			

		}

	}

	void SetAdapter() {

		adapter = new CopyFollowAdapter(getActivity(), follows_arrayList);
		list.setAdapter(adapter);

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
						new getPagedUserFollowers().execute(nexturl);
					}
					else {
						viewGroup.setVisibility(View.INVISIBLE);
					}

				}
				
			}
			
			}

		} else {

		}

	

	}
	public  String GetClientIDKeys(String key)

	{
		String text1 = null;
		String finalkey = null;
		try {
			byte[] data1 = Base64
					.decode(ApplicationData.base64, Base64.DEFAULT);
			text1 = new String(data1, "UTF-8");
			
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			
		}

		try {
			finalkey = Encrypt.decrypt(text1, key);
		} catch (Exception e) {
			
			e.printStackTrace();
		}

		
		return finalkey;

	}
	
}
