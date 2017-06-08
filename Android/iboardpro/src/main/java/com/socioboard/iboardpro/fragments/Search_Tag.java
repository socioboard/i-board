package com.socioboard.iboardpro.fragments;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.animation.Interpolator;
import android.view.animation.LinearInterpolator;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;

import com.android.volley.AuthFailureError;
import com.android.volley.Request.Method;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.socioboard.iboardpro.AppController;
import com.socioboard.iboardpro.ConstantTags;
import com.socioboard.iboardpro.ConstantUrl;
import com.socioboard.iboardpro.MainActivity;
import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.adapter.TagSearchAdapter;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.models.TagModel;
import com.socioboard.iboardpro.ui.WaveDrawable;

public class Search_Tag extends Fragment {

	View rootview;
	ImageView search_image;
	EditText captionText;
	ImageView progressimage;
	private WaveDrawable waveDrawable;
	private String tag_json_obj = "jobj_req", tag_json_arry = "jarray_req";

	ArrayList<TagModel> arraylist = new ArrayList<TagModel>();
	String nexturl;
	TagSearchAdapter adapter;
	ListView list;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {

		rootview = inflater.inflate(R.layout.tag_search_ui, container, false);
		InitUi();
		return rootview;
	}

	void InitUi() {
		search_image = (ImageView) rootview.findViewById(R.id.searchimage);
		captionText = (EditText) rootview.findViewById(R.id.captionText);
		progressimage = (ImageView) rootview.findViewById(R.id.image);
		list = (ListView) rootview.findViewById(R.id.listview);

		search_image.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				if (captionText.getText().toString().length() > 0) {
					String keywords = captionText.getText().toString().trim();
					String searchkeyword=keywords.replace("#", "");
					Fetch_taggeduser(searchkeyword);
				} else {
					captionText.setError("Type keywords");
				}
			}
		});

		waveDrawable = new WaveDrawable(Color.parseColor("#8DD2FA"), 500);
		if (Build.VERSION.SDK_INT >= 16) {

			progressimage.setBackground(waveDrawable);

		} else {

			progressimage.setBackgroundDrawable(waveDrawable);
		}
		Interpolator interpolator = new LinearInterpolator();

		waveDrawable.setWaveInterpolator(interpolator);
		waveDrawable.startAnimation();

		list.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {

				MainSingleTon.selected_tagged_item = arraylist.get(position)
						.getName();
				MainActivity.mainfragmentManager.beginTransaction()
						.replace(R.id.main_content, new Tag_Feeds_Fragmets()).addToBackStack(null)
						.commit();

			}
		});
		
		setAdapter();
	}

	/**
	 * Making json object request
	 * */
	private void Fetch_taggeduser(String keywords) {
		adapter.notifyDataSetChanged();
		
		progressimage.setVisibility(View.VISIBLE);
		arraylist.clear();
		JsonObjectRequest jsonObjReq = new JsonObjectRequest(Method.GET,
				ConstantUrl.URL_Tag_Search + "?q=" + keywords.replace(" ", "%20")
						+ "&access_token=" + MainSingleTon.accesstoken, null,
				new Response.Listener<JSONObject>() {

					@Override
					public void onResponse(JSONObject json) {

						try {
							System.out.println("josn tag data" + json);
							if (json.has("pagination")) {
								JSONObject jsonObject = json
										.getJSONObject("pagination");
								if (jsonObject.has("next_url")) {
									nexturl = jsonObject.getString("next_url");
								}

							}

							JSONArray data = json
									.getJSONArray(ConstantTags.TAG_DATA);

							for (int data_i = 0; data_i < data.length(); data_i++) {

								JSONObject data_obj = data
										.getJSONObject(data_i);
								String mediacount = data_obj
										.getString(ConstantTags.TAG_MEDIA_COUNT);
								String name = data_obj
										.getString(ConstantTags.TAG_MEDIA_NAME);

								TagModel model = new TagModel();
								model.setMedia_count(mediacount);
								model.setName(name);

								arraylist.add(model);

							}

						} catch (Exception e) {
							e.printStackTrace();
						}
						adapter.notifyDataSetChanged();
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

	void setAdapter() {
		list.setVisibility(View.VISIBLE);
		adapter = new TagSearchAdapter(getActivity(), arraylist);
		list.setAdapter(adapter);
	}

}
