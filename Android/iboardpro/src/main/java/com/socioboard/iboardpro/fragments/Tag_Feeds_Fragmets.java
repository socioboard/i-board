package com.socioboard.iboardpro.fragments;

import java.util.ArrayList;

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
import com.socioboard.iboardpro.adapter.FeedsAdapter;
import com.socioboard.iboardpro.adapter.TagFeedAdapter;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.models.CommentsModel;
import com.socioboard.iboardpro.models.FeedsModel;
import com.socioboard.iboardpro.models.LikesModel;
import com.socioboard.iboardpro.models.UserInPhotoModel;
import com.socioboard.iboardpro.ui.WaveDrawable;

/**
 * fragment is used for fetching recent feed list of user and showing in list
 * view
 */
public class Tag_Feeds_Fragmets extends Fragment implements OnScrollListener {

	ArrayList<String> tag_list = new ArrayList<String>();
	ArrayList<CommentsModel> comments_arraylist = new ArrayList<CommentsModel>();
	ArrayList<LikesModel> likes_arraylist = new ArrayList<LikesModel>();
	ArrayList<UserInPhotoModel> user_in_photo_list = new ArrayList<UserInPhotoModel>();
	public static ArrayList<FeedsModel> user_feeds_list = new ArrayList<FeedsModel>();
	private String tag_json_obj = "jobj_req", tag_json_arry = "jarray_req";
	JSONParser jParser = new JSONParser();

	ListView feedlistview;
	private WaveDrawable waveDrawable;
	ImageView progressimage;
	public static TagFeedAdapter adapter;
	ViewGroup viewGroup;
	boolean isAlreadyScrolling = true;
	String nexturl;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View rootView = inflater.inflate(R.layout.tag_feeds_view, container,
				false);
		feedlistview = (ListView) rootView.findViewById(R.id.feed_listview);
		addFooterView();
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
			FetchFeeds(MainSingleTon.selected_tagged_item);
		} else {
			Toast.makeText(getActivity(), "Please connect to internet!",
					Toast.LENGTH_LONG).show();
		}

		feedlistview.setOnScrollListener(Tag_Feeds_Fragmets.this);

		return rootView;
	}

	private void addFooterView() {

		LayoutInflater inflater = getActivity().getLayoutInflater();

		viewGroup = (ViewGroup) inflater.inflate(R.layout.progress_layout,
				feedlistview, false);

		feedlistview.addFooterView(viewGroup);

	}

	// volley

	/**
	 * Making json object request
	 * */
	private void FetchFeeds(String keywords) {
		String url = ConstantUrl.URL_Tag_feeds + keywords
				+ "/media/recent?access_token=" + MainSingleTon.accesstoken;
		progressimage.setVisibility(View.VISIBLE);
		user_feeds_list.clear();

		JsonObjectRequest jsonObjReq = new JsonObjectRequest(Method.GET, url,
				null, new Response.Listener<JSONObject>() {

					@Override
					public void onResponse(JSONObject json) {

						try {

							if (json.has("pagination")) {
								JSONObject jsonObject = json
										.getJSONObject("pagination");
								if (jsonObject.has("next_url")) {
									nexturl = jsonObject.getString("next_url");
								}

							}

							if (json.has(ConstantTags.TAG_DATA)) {
								JSONArray data = json
										.getJSONArray(ConstantTags.TAG_DATA);
								for (int data_i = 0; data_i < data.length(); data_i++) {

									String location_lattitude = "";
									String location_name = "";
									String location_longitude = "";
									String location_id = "";
									String captiontext = "";
									String captionid = "";
									Boolean islike = false;
									JSONObject data_obj = data
											.getJSONObject(data_i);

									JSONArray tag_jsonarray = data_obj
											.getJSONArray(ConstantTags.TAG_TAGS);

									for (int i = 0; i < tag_jsonarray.length(); i++) {

										tag_list.add(tag_jsonarray.getString(i));
									}

									String type = data_obj
											.getString(ConstantTags.TAG_TYPE);

									if (!data_obj
											.isNull(ConstantTags.TAG_LOCATION)) {
										JSONObject location_obj = data_obj
												.getJSONObject(ConstantTags.TAG_LOCATION);

										if (!location_obj
												.isNull(ConstantTags.TAG_LATITUDE)) {

											location_lattitude = location_obj
													.getString(ConstantTags.TAG_LATITUDE);
										}

										if (location_obj
												.has(ConstantTags.TAG_NAME)) {
											location_name = location_obj
													.getString(ConstantTags.TAG_NAME);
										}

										if (location_obj
												.has(ConstantTags.TAG_LONGITUDE)) {
											location_longitude = location_obj
													.getString(ConstantTags.TAG_LONGITUDE);
										}

										if (location_obj
												.has(ConstantTags.TAG_ID)) {
											location_id = location_obj
													.getString(ConstantTags.TAG_ID);
										}
									}

									JSONObject comm_obj = data_obj
											.getJSONObject(ConstantTags.TAG_COMMENTS);

									String comment_count = comm_obj
											.getString(ConstantTags.TAG_COUNT);
									// ------------------------------------------------------------------------------
									JSONArray commentarray = comm_obj
											.optJSONArray(ConstantTags.TAG_DATA);

									if (commentarray!=null) {

										for (int i = 0; i < commentarray
												.length(); i++) {

											CommentsModel comments_model = new CommentsModel();
											JSONObject comm_data_obj = commentarray
													.getJSONObject(i);

											String createdTime = comm_data_obj
													.getString(ConstantTags.TAG_CREATED_TIME);
											String text = comm_data_obj
													.getString(ConstantTags.TAG_TEXT);

											JSONObject fromuser_obj = comm_data_obj
													.getJSONObject(ConstantTags.TAG_FROM);

											String from_username = fromuser_obj
													.getString(ConstantTags.TAG_USERNAME);
											String from_profile_picture_url = fromuser_obj
													.getString(ConstantTags.TAG_PROFILE_PICTURE);
											String from_use_id = fromuser_obj
													.getString(ConstantTags.TAG_ID);
											String from_full_name = fromuser_obj
													.getString(ConstantTags.TAG_FULL_NAME);

											comments_model
													.setCreated_time(createdTime);
											comments_model.setText(text);

											comments_model
													.setUsername(from_username);
											comments_model
													.setProfile_picture_url(from_profile_picture_url);
											comments_model
													.setUserid(from_use_id);
											comments_model
													.setFullname(from_full_name);

											comments_arraylist
													.add(comments_model);

										}
									}

									String filter = data_obj
											.getString(ConstantTags.TAG_FILTER);
									String created_time = data_obj
											.getString(ConstantTags.TAG_CREATED_TIME);
									String link_toinstgram = data_obj
											.getString(ConstantTags.TAG_LINK);

									JSONObject likes_obj = data_obj
											.getJSONObject(ConstantTags.TAG_LIKES);
									String likes_count = likes_obj
											.getString(ConstantTags.TAG_COUNT);

									JSONArray likesarray = likes_obj
											.optJSONArray(ConstantTags.TAG_DATA);

									if (likesarray!=null) {

										for (int i = 0; i < likesarray.length(); i++) {
											LikesModel likes_model = new LikesModel();

											JSONObject likes_data_obj = likesarray
													.getJSONObject(i);

											String from_username = likes_data_obj
													.getString(ConstantTags.TAG_USERNAME);

											String from_profile_picture_url = likes_data_obj
													.getString(ConstantTags.TAG_PROFILE_PICTURE);

											String from_use_id = likes_data_obj
													.getString(ConstantTags.TAG_ID);
											String from_full_name = likes_data_obj
													.getString(ConstantTags.TAG_FULL_NAME);

											likes_model
													.setUsername(from_username);
											likes_model
													.setProfile_picture_url(from_profile_picture_url);
											likes_model.setUserid(from_use_id);
											likes_model
													.setFullname(from_full_name);
											likes_model.setCount(likes_count);
											likes_arraylist.add(likes_model);

										}
									}

									JSONObject photoObj = data_obj
											.getJSONObject(ConstantTags.TAG_IMAGES);
									JSONObject lowRes_obj = photoObj
											.getJSONObject(ConstantTags.TAG_LOW_RESOLUTION);
									String low_res_url = lowRes_obj
											.getString(ConstantTags.TAG_URL);

									JSONObject thumbnail_obj = photoObj
											.getJSONObject(ConstantTags.TAG_THUMBNAIL);
									String thumbnail_url = thumbnail_obj
											.getString(ConstantTags.TAG_URL);

									JSONObject standardres_obj = photoObj
											.getJSONObject(ConstantTags.TAG_STANDARD_RESOLUTION);
									String standardres_url = standardres_obj
											.getString(ConstantTags.TAG_URL);

									JSONArray user_in_phots_array = data_obj
											.optJSONArray(ConstantTags.TAG_USERS_IN_PHOTO);
									if (user_in_phots_array!=null ) {

										for (int i = 0; i < user_in_phots_array
												.length(); i++) {

											JSONObject userObj = user_in_phots_array
													.getJSONObject(i)
													.getJSONObject(
															ConstantTags.TAG_USER);

											String from_username = userObj
													.getString(ConstantTags.TAG_USERNAME);
											String from_profilepicture = userObj
													.getString(ConstantTags.TAG_PROFILE_PICTURE);
											String from_id = userObj
													.getString(ConstantTags.TAG_ID);
											String from_fullname = userObj
													.getString(ConstantTags.TAG_FULL_NAME);

											UserInPhotoModel model = new UserInPhotoModel();
											model.setProfile_picture_url(from_fullname);
											model.setProfile_picture_url(from_profilepicture);
											model.setUserid(from_id);
											model.setUsername(from_username);

											user_in_photo_list.add(model);

										}
									}

									if (data_obj
											.isNull(ConstantTags.TAG_CAPTION)) {

									} else {
										JSONObject caption_obj = data_obj
												.getJSONObject(ConstantTags.TAG_CAPTION);
										captiontext = caption_obj
												.getString(ConstantTags.TAG_TEXT);
										captionid = caption_obj
												.getString(ConstantTags.TAG_ID);
									}

									islike = data_obj
											.getBoolean(ConstantTags.TAG_USER_HAS_LIKED);
									String createdtime = data_obj
											.getString(ConstantTags.TAG_CREATED_TIME);
									JSONObject fromuserObj = data_obj
											.getJSONObject(ConstantTags.TAG_USER);
									String username = fromuserObj
											.getString(ConstantTags.TAG_USERNAME);
									String usernid = fromuserObj
											.getString(ConstantTags.TAG_ID);

									String profilepicurl = fromuserObj
											.getString(ConstantTags.TAG_PROFILE_PICTURE);
									String fullname = fromuserObj
											.getString(ConstantTags.TAG_FULL_NAME);

									String feed_post_id = data_obj
											.getString(ConstantTags.TAG_ID);

									FeedsModel feedsModel = new FeedsModel();
									feedsModel.setTag_array(tag_list);
									feedsModel.setType(type);
									feedsModel.setLocation_id(location_id);
									feedsModel
											.setLocation_lattitude(location_lattitude);
									feedsModel
											.setLocation_longitude(location_longitude);
									feedsModel.setLocation_name(location_name);
									feedsModel
											.setCommentlist(comments_arraylist);
									feedsModel.setFilter(filter);
									feedsModel
											.setLink_toinstgram(link_toinstgram);
									feedsModel.setLikesList(likes_arraylist);
									feedsModel
											.setLow_resolution_url(low_res_url);
									feedsModel.setThumbnail_url(thumbnail_url);
									feedsModel
											.setStandard_resolution_url(standardres_url);
									feedsModel
											.setUser_in_photo_list(user_in_photo_list);
									feedsModel.setText(captiontext);
									feedsModel.setFrom_username(username);
									feedsModel.setFrom_user_id(usernid);
									feedsModel
											.setFrom_profilepicture(profilepicurl);
									feedsModel.setFrom_fullname(fullname);
									feedsModel.setFeed_post_id(feed_post_id);
									feedsModel.setCreatedTime(createdtime);
									feedsModel.setCaption_id(captionid);
									feedsModel.setLikes_count(likes_count);
									feedsModel.setComments_count(comment_count);
									feedsModel.setIslike(islike);
									user_feeds_list.add(feedsModel);
								}

								isAlreadyScrolling = false;
								if (user_feeds_list.size() > 0) {
									setAdapter();
								} else {
									viewGroup.setVisibility(View.INVISIBLE);
								}

							}

						} catch (Exception e) {
							e.printStackTrace();
						}
						progressimage.setVisibility(View.INVISIBLE);
					}
				}, new Response.ErrorListener() {

					@Override
					public void onErrorResponse(VolleyError error) {
						progressimage.setVisibility(View.INVISIBLE);
					}
				}) {

		};

		// Adding request to request queue
		AppController.getInstance().addToRequestQueue(jsonObjReq, tag_json_obj);

		// Cancelling request
		// ApplicationController.getInstance().getRequestQueue().cancelAll(tag_json_obj);
	}

	/**
	 * Making json object request
	 * */
	private void FetchLoadmoreFeeds(String next_url) {

		JsonObjectRequest jsonObjReq = new JsonObjectRequest(Method.GET,
				next_url, null, new Response.Listener<JSONObject>() {

					@Override
					public void onResponse(JSONObject json) {

						try {

							if (json.has("pagination")) {
								JSONObject jsonObject = json
										.getJSONObject("pagination");
								if (jsonObject.has("next_url")) {
									nexturl = jsonObject.getString("next_url");
								} else {
									nexturl = null;
								}

							}

							if (json.has(ConstantTags.TAG_DATA)) {
								JSONArray data = json
										.getJSONArray(ConstantTags.TAG_DATA);
								for (int data_i = 0; data_i < data.length(); data_i++) {

									String location_lattitude = "";
									String location_name = "";
									String location_longitude = "";
									String location_id = "";
									String captiontext = "";
									String captionid = "";
									Boolean islike = false;
									JSONObject data_obj = data
											.getJSONObject(data_i);

									JSONArray tag_jsonarray = data_obj
											.getJSONArray(ConstantTags.TAG_TAGS);

									for (int i = 0; i < tag_jsonarray.length(); i++) {

										tag_list.add(tag_jsonarray.getString(i));
									}

									String type = data_obj
											.getString(ConstantTags.TAG_TYPE);

									if (!data_obj
											.isNull(ConstantTags.TAG_LOCATION)) {
										JSONObject location_obj = data_obj
												.getJSONObject(ConstantTags.TAG_LOCATION);

										if (!location_obj
												.isNull(ConstantTags.TAG_LATITUDE)) {

											location_lattitude = location_obj
													.getString(ConstantTags.TAG_LATITUDE);
										}

										if (location_obj
												.has(ConstantTags.TAG_NAME)) {
											location_name = location_obj
													.getString(ConstantTags.TAG_NAME);
										}

										if (location_obj
												.has(ConstantTags.TAG_LONGITUDE)) {
											location_longitude = location_obj
													.getString(ConstantTags.TAG_LONGITUDE);
										}

										if (location_obj
												.has(ConstantTags.TAG_ID)) {
											location_id = location_obj
													.getString(ConstantTags.TAG_ID);
										}
									}

									JSONObject comm_obj = data_obj
											.getJSONObject(ConstantTags.TAG_COMMENTS);

									String comment_count = comm_obj
											.getString(ConstantTags.TAG_COUNT);
									// ------------------------------------------------------------------------------
									JSONArray commentarray = comm_obj
											.getJSONArray(ConstantTags.TAG_DATA);

									for (int i = 0; i < commentarray.length(); i++) {

										CommentsModel comments_model = new CommentsModel();
										JSONObject comm_data_obj = commentarray
												.getJSONObject(i);

										String createdTime = comm_data_obj
												.getString(ConstantTags.TAG_CREATED_TIME);
										String text = comm_data_obj
												.getString(ConstantTags.TAG_TEXT);

										JSONObject fromuser_obj = comm_data_obj
												.getJSONObject(ConstantTags.TAG_FROM);

										String from_username = fromuser_obj
												.getString(ConstantTags.TAG_USERNAME);
										String from_profile_picture_url = fromuser_obj
												.getString(ConstantTags.TAG_PROFILE_PICTURE);
										String from_use_id = fromuser_obj
												.getString(ConstantTags.TAG_ID);
										String from_full_name = fromuser_obj
												.getString(ConstantTags.TAG_FULL_NAME);

										comments_model
												.setCreated_time(createdTime);
										comments_model.setText(text);

										comments_model
												.setUsername(from_username);
										comments_model
												.setProfile_picture_url(from_profile_picture_url);
										comments_model.setUserid(from_use_id);
										comments_model
												.setFullname(from_full_name);

										comments_arraylist.add(comments_model);

									}

									String filter = data_obj
											.getString(ConstantTags.TAG_FILTER);
									String created_time = data_obj
											.getString(ConstantTags.TAG_CREATED_TIME);
									String link_toinstgram = data_obj
											.getString(ConstantTags.TAG_LINK);

									JSONObject likes_obj = data_obj
											.getJSONObject(ConstantTags.TAG_LIKES);
									String likes_count = likes_obj
											.getString(ConstantTags.TAG_COUNT);

									JSONArray likesarray = likes_obj
											.getJSONArray(ConstantTags.TAG_DATA);

									for (int i = 0; i < likesarray.length(); i++) {
										LikesModel likes_model = new LikesModel();

										JSONObject likes_data_obj = likesarray
												.getJSONObject(i);

										String from_username = likes_data_obj
												.getString(ConstantTags.TAG_USERNAME);

										String from_profile_picture_url = likes_data_obj
												.getString(ConstantTags.TAG_PROFILE_PICTURE);

										String from_use_id = likes_data_obj
												.getString(ConstantTags.TAG_ID);
										String from_full_name = likes_data_obj
												.getString(ConstantTags.TAG_FULL_NAME);

										likes_model.setUsername(from_username);
										likes_model
												.setProfile_picture_url(from_profile_picture_url);
										likes_model.setUserid(from_use_id);
										likes_model.setFullname(from_full_name);
										likes_model.setCount(likes_count);
										likes_arraylist.add(likes_model);

									}

									JSONObject photoObj = data_obj
											.getJSONObject(ConstantTags.TAG_IMAGES);
									JSONObject lowRes_obj = photoObj
											.getJSONObject(ConstantTags.TAG_LOW_RESOLUTION);
									String low_res_url = lowRes_obj
											.getString(ConstantTags.TAG_URL);

									JSONObject thumbnail_obj = photoObj
											.getJSONObject(ConstantTags.TAG_THUMBNAIL);
									String thumbnail_url = thumbnail_obj
											.getString(ConstantTags.TAG_URL);

									JSONObject standardres_obj = photoObj
											.getJSONObject(ConstantTags.TAG_STANDARD_RESOLUTION);
									String standardres_url = standardres_obj
											.getString(ConstantTags.TAG_URL);

									JSONArray user_in_phots_array = data_obj
											.getJSONArray(ConstantTags.TAG_USERS_IN_PHOTO);
									for (int i = 0; i < user_in_phots_array
											.length(); i++) {

										JSONObject userObj = user_in_phots_array
												.getJSONObject(i)
												.getJSONObject(
														ConstantTags.TAG_USER);

										String from_username = userObj
												.getString(ConstantTags.TAG_USERNAME);
										String from_profilepicture = userObj
												.getString(ConstantTags.TAG_PROFILE_PICTURE);
										String from_id = userObj
												.getString(ConstantTags.TAG_ID);
										String from_fullname = userObj
												.getString(ConstantTags.TAG_FULL_NAME);

										UserInPhotoModel model = new UserInPhotoModel();
										model.setProfile_picture_url(from_fullname);
										model.setProfile_picture_url(from_profilepicture);
										model.setUserid(from_id);
										model.setUsername(from_username);

										user_in_photo_list.add(model);

									}

									if (data_obj
											.isNull(ConstantTags.TAG_CAPTION)) {

									} else {
										JSONObject caption_obj = data_obj
												.getJSONObject(ConstantTags.TAG_CAPTION);
										captiontext = caption_obj
												.getString(ConstantTags.TAG_TEXT);
										captionid = caption_obj
												.getString(ConstantTags.TAG_ID);
									}

									islike = data_obj
											.getBoolean(ConstantTags.TAG_USER_HAS_LIKED);
									String createdtime = data_obj
											.getString(ConstantTags.TAG_CREATED_TIME);
									JSONObject fromuserObj = data_obj
											.getJSONObject(ConstantTags.TAG_USER);
									String username = fromuserObj
											.getString(ConstantTags.TAG_USERNAME);
									String usernid = fromuserObj
											.getString(ConstantTags.TAG_ID);

									String profilepicurl = fromuserObj
											.getString(ConstantTags.TAG_PROFILE_PICTURE);
									String fullname = fromuserObj
											.getString(ConstantTags.TAG_FULL_NAME);

									String feed_post_id = data_obj
											.getString(ConstantTags.TAG_ID);

									FeedsModel feedsModel = new FeedsModel();
									feedsModel.setTag_array(tag_list);
									feedsModel.setType(type);
									feedsModel.setLocation_id(location_id);
									feedsModel
											.setLocation_lattitude(location_lattitude);
									feedsModel
											.setLocation_longitude(location_longitude);
									feedsModel.setLocation_name(location_name);
									feedsModel
											.setCommentlist(comments_arraylist);
									feedsModel.setFilter(filter);
									feedsModel
											.setLink_toinstgram(link_toinstgram);
									feedsModel.setLikesList(likes_arraylist);
									feedsModel
											.setLow_resolution_url(low_res_url);
									feedsModel.setThumbnail_url(thumbnail_url);
									feedsModel
											.setStandard_resolution_url(standardres_url);
									feedsModel
											.setUser_in_photo_list(user_in_photo_list);
									feedsModel.setText(captiontext);
									feedsModel.setFrom_username(username);
									feedsModel.setFrom_user_id(usernid);
									feedsModel
											.setFrom_profilepicture(profilepicurl);
									feedsModel.setFrom_fullname(fullname);
									feedsModel.setFeed_post_id(feed_post_id);
									feedsModel.setCreatedTime(createdtime);
									feedsModel.setCaption_id(captionid);
									feedsModel.setLikes_count(likes_count);
									feedsModel.setComments_count(comment_count);
									feedsModel.setIslike(islike);
									user_feeds_list.add(feedsModel);
								}

								viewGroup.setVisibility(View.INVISIBLE);
								int listCount = feedlistview.getCount();
								feedlistview.setScrollY(listCount);
								adapter.notifyDataSetChanged();
								isAlreadyScrolling = false;
							}

						} catch (Exception e) {
							e.printStackTrace();
						}

					}
				}, new Response.ErrorListener() {

					@Override
					public void onErrorResponse(VolleyError error) {
						progressimage.setVisibility(View.INVISIBLE);
					}
				}) {

		};

		// Adding request to request queue
		AppController.getInstance().addToRequestQueue(jsonObjReq, tag_json_obj);

		// Cancelling request
		// ApplicationController.getInstance().getRequestQueue().cancelAll(tag_json_obj);
	}

	class getUserFeeds extends AsyncTask<Void, Void, Void> {

		@Override
		protected void onPreExecute() {
			// TODO Auto-generated method stub
			super.onPreExecute();
			progressimage.setVisibility(View.VISIBLE);
		}

		@Override
		protected Void doInBackground(Void... params) {
			JSONObject json = jParser.getJSONFromUrlByGet(ConstantUrl.URL_Feeds
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

						String location_lattitude = "";
						String location_name = "";
						String location_longitude = "";
						String location_id = "";
						String captiontext = "";
						String captionid = "";
						Boolean islike = false;
						JSONObject data_obj = data.getJSONObject(data_i);

						JSONArray tag_jsonarray = data_obj
								.getJSONArray(ConstantTags.TAG_TAGS);

						for (int i = 0; i < tag_jsonarray.length(); i++) {

							tag_list.add(tag_jsonarray.getString(i));
						}

						String type = data_obj.getString(ConstantTags.TAG_TYPE);

						if (!data_obj.isNull(ConstantTags.TAG_LOCATION)) {
							JSONObject location_obj = data_obj
									.getJSONObject(ConstantTags.TAG_LOCATION);

							if (!location_obj.isNull(ConstantTags.TAG_LATITUDE)) {

								location_lattitude = location_obj
										.getString(ConstantTags.TAG_LATITUDE);
							}

							if (location_obj.has(ConstantTags.TAG_NAME)) {
								location_name = location_obj
										.getString(ConstantTags.TAG_NAME);
							}

							if (location_obj.has(ConstantTags.TAG_LONGITUDE)) {
								location_longitude = location_obj
										.getString(ConstantTags.TAG_LONGITUDE);
							}

							if (location_obj.has(ConstantTags.TAG_ID)) {
								location_id = location_obj
										.getString(ConstantTags.TAG_ID);
							}
						}

						JSONObject comm_obj = data_obj
								.getJSONObject(ConstantTags.TAG_COMMENTS);

						String comment_count = comm_obj
								.getString(ConstantTags.TAG_COUNT);
						// ------------------------------------------------------------------------------
						JSONArray commentarray = comm_obj
								.getJSONArray(ConstantTags.TAG_DATA);

						for (int i = 0; i < commentarray.length(); i++) {

							CommentsModel comments_model = new CommentsModel();
							JSONObject comm_data_obj = commentarray
									.getJSONObject(i);

							String createdTime = comm_data_obj
									.getString(ConstantTags.TAG_CREATED_TIME);
							String text = comm_data_obj
									.getString(ConstantTags.TAG_TEXT);

							JSONObject fromuser_obj = comm_data_obj
									.getJSONObject(ConstantTags.TAG_FROM);

							String from_username = fromuser_obj
									.getString(ConstantTags.TAG_USERNAME);
							String from_profile_picture_url = fromuser_obj
									.getString(ConstantTags.TAG_PROFILE_PICTURE);
							String from_use_id = fromuser_obj
									.getString(ConstantTags.TAG_ID);
							String from_full_name = fromuser_obj
									.getString(ConstantTags.TAG_FULL_NAME);

							comments_model.setCreated_time(createdTime);
							comments_model.setText(text);

							comments_model.setUsername(from_username);
							comments_model
									.setProfile_picture_url(from_profile_picture_url);
							comments_model.setUserid(from_use_id);
							comments_model.setFullname(from_full_name);

							comments_arraylist.add(comments_model);

						}

						String filter = data_obj
								.getString(ConstantTags.TAG_FILTER);
						String created_time = data_obj
								.getString(ConstantTags.TAG_CREATED_TIME);
						String link_toinstgram = data_obj
								.getString(ConstantTags.TAG_LINK);

						JSONObject likes_obj = data_obj
								.getJSONObject(ConstantTags.TAG_LIKES);
						String likes_count = likes_obj
								.getString(ConstantTags.TAG_COUNT);

						JSONArray likesarray = likes_obj
								.getJSONArray(ConstantTags.TAG_DATA);

						for (int i = 0; i < likesarray.length(); i++) {
							LikesModel likes_model = new LikesModel();

							JSONObject likes_data_obj = likesarray
									.getJSONObject(i);

							String from_username = likes_data_obj
									.getString(ConstantTags.TAG_USERNAME);

							String from_profile_picture_url = likes_data_obj
									.getString(ConstantTags.TAG_PROFILE_PICTURE);

							String from_use_id = likes_data_obj
									.getString(ConstantTags.TAG_ID);
							String from_full_name = likes_data_obj
									.getString(ConstantTags.TAG_FULL_NAME);

							likes_model.setUsername(from_username);
							likes_model
									.setProfile_picture_url(from_profile_picture_url);
							likes_model.setUserid(from_use_id);
							likes_model.setFullname(from_full_name);
							likes_model.setCount(likes_count);
							likes_arraylist.add(likes_model);

						}

						JSONObject photoObj = data_obj
								.getJSONObject(ConstantTags.TAG_IMAGES);
						JSONObject lowRes_obj = photoObj
								.getJSONObject(ConstantTags.TAG_LOW_RESOLUTION);
						String low_res_url = lowRes_obj
								.getString(ConstantTags.TAG_URL);

						JSONObject thumbnail_obj = photoObj
								.getJSONObject(ConstantTags.TAG_THUMBNAIL);
						String thumbnail_url = thumbnail_obj
								.getString(ConstantTags.TAG_URL);

						JSONObject standardres_obj = photoObj
								.getJSONObject(ConstantTags.TAG_STANDARD_RESOLUTION);
						String standardres_url = standardres_obj
								.getString(ConstantTags.TAG_URL);

						JSONArray user_in_phots_array = data_obj
								.getJSONArray(ConstantTags.TAG_USERS_IN_PHOTO);
						for (int i = 0; i < user_in_phots_array.length(); i++) {

							JSONObject userObj = user_in_phots_array
									.getJSONObject(i).getJSONObject(
											ConstantTags.TAG_USER);

							String from_username = userObj
									.getString(ConstantTags.TAG_USERNAME);
							String from_profilepicture = userObj
									.getString(ConstantTags.TAG_PROFILE_PICTURE);
							String from_id = userObj
									.getString(ConstantTags.TAG_ID);
							String from_fullname = userObj
									.getString(ConstantTags.TAG_FULL_NAME);

							UserInPhotoModel model = new UserInPhotoModel();
							model.setProfile_picture_url(from_fullname);
							model.setProfile_picture_url(from_profilepicture);
							model.setUserid(from_id);
							model.setUsername(from_username);

							user_in_photo_list.add(model);

						}

						if (data_obj.isNull(ConstantTags.TAG_CAPTION)) {

						} else {
							JSONObject caption_obj = data_obj
									.getJSONObject(ConstantTags.TAG_CAPTION);
							captiontext = caption_obj
									.getString(ConstantTags.TAG_TEXT);
							captionid = caption_obj
									.getString(ConstantTags.TAG_ID);
						}

						islike = data_obj
								.getBoolean(ConstantTags.TAG_USER_HAS_LIKED);
						String createdtime = data_obj
								.getString(ConstantTags.TAG_CREATED_TIME);
						JSONObject fromuserObj = data_obj
								.getJSONObject(ConstantTags.TAG_USER);
						String username = fromuserObj
								.getString(ConstantTags.TAG_USERNAME);
						String usernid = fromuserObj
								.getString(ConstantTags.TAG_ID);

						String profilepicurl = fromuserObj
								.getString(ConstantTags.TAG_PROFILE_PICTURE);
						String fullname = fromuserObj
								.getString(ConstantTags.TAG_FULL_NAME);

						String feed_post_id = data_obj
								.getString(ConstantTags.TAG_ID);

						FeedsModel feedsModel = new FeedsModel();
						feedsModel.setTag_array(tag_list);
						feedsModel.setType(type);
						feedsModel.setLocation_id(location_id);
						feedsModel.setLocation_lattitude(location_lattitude);
						feedsModel.setLocation_longitude(location_longitude);
						feedsModel.setLocation_name(location_name);
						feedsModel.setCommentlist(comments_arraylist);
						feedsModel.setFilter(filter);
						feedsModel.setLink_toinstgram(link_toinstgram);
						feedsModel.setLikesList(likes_arraylist);
						feedsModel.setLow_resolution_url(low_res_url);
						feedsModel.setThumbnail_url(thumbnail_url);
						feedsModel.setStandard_resolution_url(standardres_url);
						feedsModel.setUser_in_photo_list(user_in_photo_list);
						feedsModel.setText(captiontext);
						feedsModel.setFrom_username(username);
						feedsModel.setFrom_user_id(usernid);
						feedsModel.setFrom_profilepicture(profilepicurl);
						feedsModel.setFrom_fullname(fullname);
						feedsModel.setFeed_post_id(feed_post_id);
						feedsModel.setCreatedTime(createdtime);
						feedsModel.setCaption_id(captionid);
						feedsModel.setLikes_count(likes_count);
						feedsModel.setComments_count(comment_count);
						feedsModel.setIslike(islike);
						user_feeds_list.add(feedsModel);
					}
				}
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			// TODO Auto-generated method stub
			super.onPostExecute(result);
			progressimage.setVisibility(View.INVISIBLE);
			isAlreadyScrolling = false;
			setAdapter();
		}

	}

	void setAdapter() {
		adapter = new TagFeedAdapter(getActivity(), user_feeds_list);

		feedlistview.setAdapter(adapter);
	}

	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		// ((ActionBarActivity)getActivity()).getActionBar().setTitle("Feeds");
	}

	// loadmore data fetch

	class GetpagedUserdata extends AsyncTask<String, Void, Void> {

		@Override
		protected void onPreExecute() {
			// TODO Auto-generated method stub
			super.onPreExecute();

		}

		@Override
		protected Void doInBackground(String... params) {

			String next_url = params[0].toString();

			JSONObject json = jParser.getJSONFromUrlByGet(next_url);

			try {

				if (json.has("pagination")) {
					JSONObject jsonObject = json.getJSONObject("pagination");
					if (jsonObject.has("next_url")) {
						nexturl = jsonObject.getString("next_url");
					} else {
						nexturl = null;
					}

				}
				if (json.has(ConstantTags.TAG_DATA)) {
					JSONArray data = json.getJSONArray(ConstantTags.TAG_DATA);
					for (int data_i = 0; data_i < data.length(); data_i++) {

						String location_lattitude = "";
						String location_name = "";
						String location_longitude = "";
						String location_id = "";
						String captiontext = "";
						String captionid = "";
						Boolean islike = false;
						JSONObject data_obj = data.getJSONObject(data_i);

						JSONArray tag_jsonarray = data_obj
								.getJSONArray(ConstantTags.TAG_TAGS);

						for (int i = 0; i < tag_jsonarray.length(); i++) {

							tag_list.add(tag_jsonarray.getString(i));
						}

						String type = data_obj.getString(ConstantTags.TAG_TYPE);

						if (!data_obj.isNull(ConstantTags.TAG_LOCATION)) {
							JSONObject location_obj = data_obj
									.getJSONObject(ConstantTags.TAG_LOCATION);

							if (!location_obj.isNull(ConstantTags.TAG_LATITUDE)) {

								location_lattitude = location_obj
										.getString(ConstantTags.TAG_LATITUDE);
							}

							if (location_obj.has(ConstantTags.TAG_NAME)) {
								location_name = location_obj
										.getString(ConstantTags.TAG_NAME);
							}

							if (location_obj.has(ConstantTags.TAG_LONGITUDE)) {
								location_longitude = location_obj
										.getString(ConstantTags.TAG_LONGITUDE);
							}

							if (location_obj.has(ConstantTags.TAG_ID)) {
								location_id = location_obj
										.getString(ConstantTags.TAG_ID);
							}
						}

						JSONObject comm_obj = data_obj
								.getJSONObject(ConstantTags.TAG_COMMENTS);

						String comment_count = comm_obj
								.getString(ConstantTags.TAG_COUNT);
						// ------------------------------------------------------------------------------
						JSONArray commentarray = comm_obj
								.getJSONArray(ConstantTags.TAG_DATA);

						for (int i = 0; i < commentarray.length(); i++) {

							CommentsModel comments_model = new CommentsModel();
							JSONObject comm_data_obj = commentarray
									.getJSONObject(i);

							String createdTime = comm_data_obj
									.getString(ConstantTags.TAG_CREATED_TIME);
							String text = comm_data_obj
									.getString(ConstantTags.TAG_TEXT);

							JSONObject fromuser_obj = comm_data_obj
									.getJSONObject(ConstantTags.TAG_FROM);

							String from_username = fromuser_obj
									.getString(ConstantTags.TAG_USERNAME);
							String from_profile_picture_url = fromuser_obj
									.getString(ConstantTags.TAG_PROFILE_PICTURE);
							String from_use_id = fromuser_obj
									.getString(ConstantTags.TAG_ID);
							String from_full_name = fromuser_obj
									.getString(ConstantTags.TAG_FULL_NAME);

							comments_model.setCreated_time(createdTime);
							comments_model.setText(text);

							comments_model.setUsername(from_username);
							comments_model
									.setProfile_picture_url(from_profile_picture_url);
							comments_model.setUserid(from_use_id);
							comments_model.setFullname(from_full_name);

							comments_arraylist.add(comments_model);

						}

						String filter = data_obj
								.getString(ConstantTags.TAG_FILTER);
						String created_time = data_obj
								.getString(ConstantTags.TAG_CREATED_TIME);
						String link_toinstgram = data_obj
								.getString(ConstantTags.TAG_LINK);

						JSONObject likes_obj = data_obj
								.getJSONObject(ConstantTags.TAG_LIKES);
						String likes_count = likes_obj
								.getString(ConstantTags.TAG_COUNT);

						JSONArray likesarray = likes_obj
								.getJSONArray(ConstantTags.TAG_DATA);

						for (int i = 0; i < likesarray.length(); i++) {
							LikesModel likes_model = new LikesModel();

							JSONObject likes_data_obj = likesarray
									.getJSONObject(i);

							String from_username = likes_data_obj
									.getString(ConstantTags.TAG_USERNAME);

							String from_profile_picture_url = likes_data_obj
									.getString(ConstantTags.TAG_PROFILE_PICTURE);

							String from_use_id = likes_data_obj
									.getString(ConstantTags.TAG_ID);
							String from_full_name = likes_data_obj
									.getString(ConstantTags.TAG_FULL_NAME);

							likes_model.setUsername(from_username);
							likes_model
									.setProfile_picture_url(from_profile_picture_url);
							likes_model.setUserid(from_use_id);
							likes_model.setFullname(from_full_name);
							likes_model.setCount(likes_count);
							likes_arraylist.add(likes_model);

						}

						JSONObject photoObj = data_obj
								.getJSONObject(ConstantTags.TAG_IMAGES);
						JSONObject lowRes_obj = photoObj
								.getJSONObject(ConstantTags.TAG_LOW_RESOLUTION);
						String low_res_url = lowRes_obj
								.getString(ConstantTags.TAG_URL);

						JSONObject thumbnail_obj = photoObj
								.getJSONObject(ConstantTags.TAG_THUMBNAIL);
						String thumbnail_url = thumbnail_obj
								.getString(ConstantTags.TAG_URL);

						JSONObject standardres_obj = photoObj
								.getJSONObject(ConstantTags.TAG_STANDARD_RESOLUTION);
						String standardres_url = standardres_obj
								.getString(ConstantTags.TAG_URL);

						JSONArray user_in_phots_array = data_obj
								.getJSONArray(ConstantTags.TAG_USERS_IN_PHOTO);
						for (int i = 0; i < user_in_phots_array.length(); i++) {

							JSONObject userObj = user_in_phots_array
									.getJSONObject(i).getJSONObject(
											ConstantTags.TAG_USER);

							String from_username = userObj
									.getString(ConstantTags.TAG_USERNAME);
							String from_profilepicture = userObj
									.getString(ConstantTags.TAG_PROFILE_PICTURE);
							String from_id = userObj
									.getString(ConstantTags.TAG_ID);
							String from_fullname = userObj
									.getString(ConstantTags.TAG_FULL_NAME);

							UserInPhotoModel model = new UserInPhotoModel();
							model.setProfile_picture_url(from_fullname);
							model.setProfile_picture_url(from_profilepicture);
							model.setUserid(from_id);
							model.setUsername(from_username);

							user_in_photo_list.add(model);

						}

						if (data_obj.isNull(ConstantTags.TAG_CAPTION)) {

						} else {
							JSONObject caption_obj = data_obj
									.getJSONObject(ConstantTags.TAG_CAPTION);
							captiontext = caption_obj
									.getString(ConstantTags.TAG_TEXT);
							captionid = caption_obj
									.getString(ConstantTags.TAG_ID);
						}

						islike = data_obj
								.getBoolean(ConstantTags.TAG_USER_HAS_LIKED);
						String createdtime = data_obj
								.getString(ConstantTags.TAG_CREATED_TIME);
						JSONObject fromuserObj = data_obj
								.getJSONObject(ConstantTags.TAG_USER);
						String username = fromuserObj
								.getString(ConstantTags.TAG_USERNAME);
						String usernid = fromuserObj
								.getString(ConstantTags.TAG_ID);

						String profilepicurl = fromuserObj
								.getString(ConstantTags.TAG_PROFILE_PICTURE);
						String fullname = fromuserObj
								.getString(ConstantTags.TAG_FULL_NAME);

						String feed_post_id = data_obj
								.getString(ConstantTags.TAG_ID);

						FeedsModel feedsModel = new FeedsModel();
						feedsModel.setTag_array(tag_list);
						feedsModel.setType(type);
						feedsModel.setLocation_id(location_id);
						feedsModel.setLocation_lattitude(location_lattitude);
						feedsModel.setLocation_longitude(location_longitude);
						feedsModel.setLocation_name(location_name);
						feedsModel.setCommentlist(comments_arraylist);
						feedsModel.setFilter(filter);
						feedsModel.setLink_toinstgram(link_toinstgram);
						feedsModel.setLikesList(likes_arraylist);
						feedsModel.setLow_resolution_url(low_res_url);
						feedsModel.setThumbnail_url(thumbnail_url);
						feedsModel.setStandard_resolution_url(standardres_url);
						feedsModel.setUser_in_photo_list(user_in_photo_list);
						feedsModel.setText(captiontext);
						feedsModel.setFrom_username(username);
						feedsModel.setFrom_user_id(usernid);
						feedsModel.setFrom_profilepicture(profilepicurl);
						feedsModel.setFrom_fullname(fullname);
						feedsModel.setFeed_post_id(feed_post_id);
						feedsModel.setCreatedTime(createdtime);
						feedsModel.setCaption_id(captionid);
						feedsModel.setLikes_count(likes_count);
						feedsModel.setComments_count(comment_count);
						feedsModel.setIslike(islike);
						user_feeds_list.add(feedsModel);
					}
				}
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			// TODO Auto-generated method stub
			super.onPostExecute(result);
			viewGroup.setVisibility(View.INVISIBLE);
			int listCount = feedlistview.getCount();
			feedlistview.setScrollY(listCount);
			adapter.notifyDataSetChanged();
			isAlreadyScrolling = false;
		}

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

			if (isAlreadyScrolling) {

			} else {

				viewGroup.setVisibility(View.VISIBLE);

				isAlreadyScrolling = true;

				if (adapter != null) {

					if (adapter.getCount() != 0) {

						if (nexturl != null) {
							FetchLoadmoreFeeds(nexturl);
						}
					}
				}

			}

		} else {

		}

	}

}
