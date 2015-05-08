package com.socioboard.iboardpro.fragments;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.ListView;
import android.widget.Toast;

import com.socioboard.iboardpro.ConnectionDetector;
import com.socioboard.iboardpro.ConstantTags;
import com.socioboard.iboardpro.ConstantUrl;
import com.socioboard.iboardpro.JSONParser;
import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.adapter.FollowsAdapter;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.models.FollowModel;

/**fragment is used for  fetching nonfollowers  list of user and showing in list viewCreated by Daniel on 09.11.2014.
 */
public class Mutual_Fragments extends Fragment {

	ArrayList<FollowModel> Follows_arrayList = new ArrayList<FollowModel>();
	ArrayList<FollowModel> Followed_by_arrayList = new ArrayList<FollowModel>();
	JSONParser jParser = new JSONParser();
	ArrayList<FollowModel> Mutual_arraylist = new ArrayList<FollowModel>();
	FollowsAdapter adapter;
	ListView list;
	private ProgressDialog mSpinner;
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View rootView = inflater.inflate(R.layout.mutual,
				container, false);

		list = (ListView) rootView.findViewById(R.id.listView);
		mSpinner = new ProgressDialog(getActivity());
		mSpinner.requestWindowFeature(Window.FEATURE_NO_TITLE);
		mSpinner.setMessage("Loading...");
		
		
		ConnectionDetector detector=new ConnectionDetector(getActivity());
		if (detector.isConnectingToInternet()) {
			new getUserFollowers().execute();
		}
		else {
			Toast.makeText(getActivity(), "Please connect to internet!", Toast.LENGTH_LONG).show();
		}
		
		return rootView;
	}

	class getUserFollowers extends AsyncTask<Void, Void, Void> {

		@Override
		protected void onPreExecute() {
			// TODO Auto-generated method stub
			super.onPreExecute();
			mSpinner.show();
		}
		@Override
		protected Void doInBackground(Void... params) {

			Follows_arrayList.clear();
			JSONObject json = jParser
					.getJSONFromUrlByGet(ConstantUrl.URL_Follows
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
					Follows_arrayList.add(model);
					
				}
			
				//String str_code = meta_obj.getString(ConstantTags.TAG_CODE);

			} catch (JSONException e) {
				System.out.println("catch block Follows");
				e.printStackTrace();
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

	class getFollowedBy extends AsyncTask<Void, Void, Void> {

		@Override
		protected Void doInBackground(Void... params) {

			Followed_by_arrayList.clear();
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
					Followed_by_arrayList.add(model);
					System.out.println("inside array name=str_full_name"
							+ str_full_name);
				}
				

			} catch (JSONException e) {
				System.out.println("catch block getFollowedBy");
				
				e.printStackTrace();
			}

			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			super.onPostExecute(result);
			Mutual_arraylist.clear();
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

				if (isContain) {
					FollowModel model = new FollowModel();
					model.setFull_name(Follows_arrayList.get(i).getFull_name());
					model.setProfile_pic_url(Follows_arrayList.get(i)
							.getProfile_pic_url());
					model.setUserid(Follows_arrayList.get(i).getUserid());
					model.setUsername(Follows_arrayList.get(i).getUsername());
					Mutual_arraylist.add(model);
				}

			}

			setAdapter();

		}

	}

	void setAdapter() {
		 adapter = new FollowsAdapter(getActivity(),
				 Mutual_arraylist);

		list.setAdapter(adapter);
		mSpinner.hide();
	}

	
	 @Override
		public void onDestroy() {
			// TODO Auto-generated method stub
			super.onDestroy();
			list.setAdapter(null);
			adapter.imageLoader.clearCache();
		}
}
