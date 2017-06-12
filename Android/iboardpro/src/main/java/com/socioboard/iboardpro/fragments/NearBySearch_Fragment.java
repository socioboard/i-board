package com.socioboard.iboardpro.fragments;

import android.Manifest;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.location.Location;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Interpolator;
import android.view.animation.LinearInterpolator;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.Request.Method;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.socioboard.iboardpro.AppController;
import com.socioboard.iboardpro.ConstantTags;
import com.socioboard.iboardpro.ConstantUrl;
import com.socioboard.iboardpro.JSONParser;
import com.socioboard.iboardpro.MainActivity;
import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.adapter.CustomAdpLocations;
import com.socioboard.iboardpro.adapter.LocationSearchAdapter;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.models.LocationModel;
import com.socioboard.iboardpro.models.RowItemLocations;
import com.socioboard.iboardpro.ui.WaveDrawable;
import com.socioboard.iboardpro.utils.AppLocationService;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class NearBySearch_Fragment extends Fragment {

	View rootview;
	TextView click_here_text;
	ImageView searchbtn;
	EditText text;
	ImageView progressimage, nearby_btn;
	ListView list, locationlist;
	String location, latitute, longitude;
	private WaveDrawable waveDrawable;
	private String tag_json_obj = "jobj_req", tag_json_arry = "jarray_req";
	String nexturl;
	ArrayList<RowItemLocations> locationsList = new ArrayList<RowItemLocations>();

	LocationSearchAdapter adapter;

	AppLocationService appLocationService;
	public static final int MY_PERMISSIONS_REQUEST_LOCATION = 123;
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		rootview = inflater.inflate(R.layout.nearbysearch, container, false);
		InitUI();

		return rootview;
	}

	void InitUI() {

		

		searchbtn = (ImageView) rootview.findViewById(R.id.searchimage);
		text = (EditText) rootview.findViewById(R.id.captionText);
		progressimage = (ImageView) rootview.findViewById(R.id.image);
		locationlist = (ListView) rootview.findViewById(R.id.listview);
		click_here_text = (TextView) rootview.findViewById(R.id.clicktext);
		nearby_btn = (ImageView) rootview.findViewById(R.id.nearby_btn);

		searchbtn.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				locationsList.clear();
				if (!text.getText().toString().trim().isEmpty()) {
					String place = text.getText().toString().trim();
					OpenLocationChnageDialog();
					new ChangeLocAynctask().execute(place);
				} else {
					Toast.makeText(getActivity(), "Please enter location name",
							Toast.LENGTH_SHORT).show();
				}

			}
		});

		locationlist.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {

				MainSingleTon.selected_location_id = MainSingleTon.location_arraylist
						.get(position).getId();
				MainActivity.mainfragmentManager.beginTransaction()
						.replace(R.id.main_content, new NearByFeed_Fragment())
						.addToBackStack(null).commit();

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

		setAdapter();
		if (MainSingleTon.location_arraylist.size() > 0) {

			nearby_btn.setVisibility(View.INVISIBLE);
			click_here_text.setVisibility(View.INVISIBLE);
		}
		nearby_btn.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {


				if (ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
					// TODO: Consider calling
					ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.ACCESS_FINE_LOCATION,Manifest.permission.ACCESS_COARSE_LOCATION}, MY_PERMISSIONS_REQUEST_LOCATION);
				}
				else
				{
					appLocationService = new AppLocationService(getActivity());
					// fetch current lat & long from network
					Location nwLocation = appLocationService
							.getLocation(LocationManager.NETWORK_PROVIDER);
					if (nwLocation != null) {

						double latitude = nwLocation.getLatitude();
						double longitude = nwLocation.getLongitude();

						if (MainSingleTon.location_arraylist.size() == 0) {

							FetchLocation(latitude + "", longitude + "");
						}

					} else {
						showSettingsAlert("Location");
					}
				}


			}
		});
	}

	public void OpenLocationChnageDialog() {
		final Dialog dialog = new Dialog(getActivity());

		dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		dialog.getWindow().setLayout(WindowManager.LayoutParams.MATCH_PARENT,
				WindowManager.LayoutParams.MATCH_PARENT);

		dialog.setContentView(R.layout.dialog_changelocation);

		list = (ListView) dialog.findViewById(R.id.list);

		list.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				location = locationsList.get(position).getdisplayAddres();
				latitute = locationsList.get(position).getlatitute();
				longitude = locationsList.get(position).getlongitute();

				dialog.hide();
				System.out.println("lat*******************" + latitute);

				FetchLocation(latitute, longitude);
				// new ChangeLocation().execute(latitute,longitude);
			}
		});

		dialog.show();

	}

	class ChangeLocAynctask extends AsyncTask<String, Void, Void> {
		String response = null;
		
		
		@Override
		protected Void doInBackground(String... params) {
			String place = params[0];

			String parametes = "http://maps.google.com/maps/api/geocode/json?address="
					+ place.replace(" ", "%20") + "&sensor=false";

			JSONParser jParser = new JSONParser();

			JSONObject jsonOj = jParser.getJSONFromUrlByGet(parametes);

			try {
				response = jsonOj.getString("status");

				if (response.equalsIgnoreCase("OK")) {
					JSONArray jsonArray = jsonOj.getJSONArray("results");

					for (int i = 0; i < jsonArray.length(); i++) {

						RowItemLocations itemLocations = new RowItemLocations();
						itemLocations.setdisplayAddres(jsonArray.getJSONObject(
								i).getString("formatted_address"));
						itemLocations.setlatitute(jsonArray.getJSONObject(i)
								.getJSONObject("geometry")
								.getJSONObject("location").getString("lat"));
						itemLocations.setlongitute(jsonArray.getJSONObject(i)
								.getJSONObject("geometry")
								.getJSONObject("location").getString("lng"));
						locationsList.add(itemLocations);
					}

				} 

			} catch (JSONException e) {

				e.printStackTrace();
			}

			System.out.println("RESULT=" + jsonOj);
			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			// TODO Auto-generated method stub
			super.onPostExecute(result);
			
			if (locationsList.size()==0) {
				Toast.makeText(getActivity(), "No such locations found!!",
						Toast.LENGTH_SHORT).show();
			}
			
			CustomAdpLocations adpLocations = new CustomAdpLocations(
					getActivity(), locationsList);
			list.setAdapter(adpLocations);

		}
	}

	/**
	 * Making json object request
	 * */
	private void FetchLocation(String lat, String longi) {
		progressimage.setVisibility(View.VISIBLE);
		MainSingleTon.location_arraylist.clear();
		nearby_btn.setVisibility(View.INVISIBLE);
		click_here_text.setVisibility(View.INVISIBLE);
		locationlist.setVisibility(View.INVISIBLE);
		JsonObjectRequest jsonObjReq = new JsonObjectRequest(Method.GET,
				ConstantUrl.URL_Location_search + "lat=" + lat + "&lng="
						+ longi + "&access_token=" + MainSingleTon.accesstoken,
				null, new Response.Listener<JSONObject>() {

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
									.optJSONArray(ConstantTags.TAG_DATA);

							if (data!=null) {
								
							
							
							for (int data_i = 0; data_i < data.length(); data_i++) {

								JSONObject data_obj = data
										.getJSONObject(data_i);
								String id = data_obj
										.getString(ConstantTags.TAG_ID);
								String name = data_obj
										.getString(ConstantTags.TAG_NAME);
								String lat = data_obj
										.getString(ConstantTags.TAG_LATITUDE);
								String lng = data_obj
										.getString(ConstantTags.TAG_LONGITUDE);

								LocationModel model = new LocationModel();
								model.setId(id);
								model.setName(name);
								model.setLat(lat);
								model.setLng(lng);

								MainSingleTon.location_arraylist.add(model);

							}
							}

						} catch (Exception e) {
							e.printStackTrace();
						}
						progressimage.setVisibility(View.INVISIBLE);
						adapter.notifyDataSetChanged();
						locationlist.setVisibility(View.VISIBLE);

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
		locationlist.setVisibility(View.VISIBLE);
		adapter = new LocationSearchAdapter(getActivity(),
				MainSingleTon.location_arraylist);
		locationlist.setAdapter(adapter);
	}

	public void showSettingsAlert(String provider) {
		AlertDialog.Builder alertDialog = new AlertDialog.Builder(getActivity());

		alertDialog.setTitle(provider + " Settings");

		alertDialog.setMessage(provider
				+ " settings is not enabled! Want to go to settings menu?");

		alertDialog.setPositiveButton("Settings",
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						Intent intent = new Intent(
								Settings.ACTION_LOCATION_SOURCE_SETTINGS);
						startActivity(intent);
					}
				});

		alertDialog.setNegativeButton("Cancel",
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						dialog.cancel();
					}
				});

		alertDialog.show();
	}


	@Override
	public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
		super.onRequestPermissionsResult(requestCode, permissions, grantResults);
		if (requestCode==MY_PERMISSIONS_REQUEST_LOCATION)
		{
			if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
				appLocationService = new AppLocationService(getActivity());
				// fetch current lat & long from network
				Location nwLocation = appLocationService
						.getLocation(LocationManager.NETWORK_PROVIDER);
				if (nwLocation != null) {

					double latitude = nwLocation.getLatitude();
					double longitude = nwLocation.getLongitude();

					if (MainSingleTon.location_arraylist.size() == 0) {

						FetchLocation(latitude + "", longitude + "");
					}

				} else {
					showSettingsAlert("Location");
				}
			} else {
						Toast.makeText(getActivity(),"Permission not granted",Toast.LENGTH_SHORT).show();
			}

		}
	}
}
