package com.socioboard.iboardpro.fragments;

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
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.Toast;

import com.socioboard.iboardpro.ConnectionDetector;
import com.socioboard.iboardpro.ConstantTags;
import com.socioboard.iboardpro.ConstantUrl;
import com.socioboard.iboardpro.JSONParser;
import com.socioboard.iboardpro.MainActivity;
import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.adapter.PhotoBucketAdapter;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.models.CommentsModel;
import com.socioboard.iboardpro.models.LikesModel;
import com.socioboard.iboardpro.models.UserMediaModel;
import com.socioboard.iboardpro.ui.WaveDrawable;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * fratgment is used for fetching photo bucket list of user and showing in list
 * view
 */
public class Photo_Bucket extends Fragment {

	ArrayList<UserMediaModel> media_arrayList = new ArrayList<UserMediaModel>();
	ArrayList<CommentsModel> comments_arraylist = new ArrayList<CommentsModel>();
	ArrayList<LikesModel> likes_arraylist = new ArrayList<LikesModel>();
	PhotoBucketAdapter adapter;
	JSONParser jParser = new JSONParser();
	GridView list;

	private WaveDrawable waveDrawable;
	ImageView progressimage;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View rootView = inflater.inflate(R.layout.photo_bucket, container,
				false);
		System.out.println("Url== " + ConstantUrl.URL_Media
				+ MainSingleTon.accesstoken);

		progressimage = (ImageView) rootView.findViewById(R.id.image);
		list = (GridView) rootView.findViewById(R.id.gridView);
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
			new getUserMedia().execute();
		} else {
			Toast.makeText(getActivity(), "Please connect to internet!",
					Toast.LENGTH_LONG).show();
		}

		list.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {

				Integer position1 = (Integer) view.getTag();
				MainSingleTon.photo_url = media_arrayList.get(position1)
						.getStandard_resolution_url();

				Fragment fragment = new PhotoViewFragment();

				MainActivity.mainfragmentManager.beginTransaction()
						.replace(R.id.main_content, fragment)
						.addToBackStack(null).commit();

			}
		});

		return rootView;
	}

	class getUserMedia extends AsyncTask<Void, Void, Void> {

		@Override
		protected void onPreExecute() {
			// TODO Auto-generated method stub
			super.onPreExecute();
			progressimage.setVisibility(View.VISIBLE);
		}

		@Override
		protected Void doInBackground(Void... params) {

			media_arrayList.clear();
			comments_arraylist.clear();
			likes_arraylist.clear();
			JSONObject json = jParser.getJSONFromUrlByGet(ConstantUrl.URL_Media
					+ MainSingleTon.accesstoken);
			System.out.println("getUserMedia " + json);
			try {

				if (json.has(ConstantTags.TAG_DATA)) {
					JSONArray data = json.getJSONArray(ConstantTags.TAG_DATA);
					System.out.println("2");
					for (int data_i = 0; data_i < data.length(); data_i++) {

						JSONObject data_obj = data.getJSONObject(data_i);

						String type = data_obj.getString(ConstantTags.TAG_TYPE);

						String location = data_obj
								.getString(ConstantTags.TAG_LOCATION);

						JSONObject comm_obj = data_obj
								.getJSONObject(ConstantTags.TAG_COMMENTS);

						String comment_count = comm_obj
								.getString(ConstantTags.TAG_COUNT);
						// ------------------------------------------------------------------------------
						JSONArray commentarray = comm_obj
								.optJSONArray(ConstantTags.TAG_DATA);

						if (commentarray != null) {

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
								;
								comments_model.setUsername(from_username);
								comments_model
										.setProfile_picture_url(from_profile_picture_url);
								comments_model.setUserid(from_use_id);
								comments_model.setFullname(from_full_name);

								comments_arraylist.add(comments_model);

							}
						}
						// ---------------------------------------------------------------------------

						String filter = data_obj
								.getString(ConstantTags.TAG_FILTER);
						String created_time = data_obj
								.getString(ConstantTags.TAG_CREATED_TIME);
						String post_link = data_obj
								.getString(ConstantTags.TAG_LINK);

						JSONObject likes_obj = data_obj
								.getJSONObject(ConstantTags.TAG_LIKES);
						String likes_count = likes_obj
								.getString(ConstantTags.TAG_COUNT);

						JSONArray likesarray = likes_obj
								.optJSONArray(ConstantTags.TAG_DATA);

						if (likesarray != null) {

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

						// String
						// caption=data_obj.getString(ConstantTags.TAG_CAPTION);
						String postid = data_obj.getString(ConstantTags.TAG_ID);

						UserMediaModel mediaModel = new UserMediaModel();
						mediaModel.setType(type);
						mediaModel.setLocation(location);
						mediaModel.setCommentsCount(comment_count);
						mediaModel.setCommentlist(comments_arraylist);
						mediaModel.setFilter(filter);
						mediaModel.setCreated_time(created_time);
						mediaModel.setLink(post_link);
						mediaModel.setLikesList(likes_arraylist);
						mediaModel.setLow_resolution_url(low_res_url);
						mediaModel.setLike_count(likes_count);
						mediaModel.setThumbnail_url(thumbnail_url);
						mediaModel.setStandard_resolution_url(standardres_url);
						mediaModel.setPostid(postid);
						media_arrayList.add(mediaModel);

					}
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
			System.out.println("arrayList" + media_arrayList.size());
			progressimage.setVisibility(View.INVISIBLE);
			setAdapter();
		}

	}

	void setAdapter() {
		adapter = new PhotoBucketAdapter(getActivity(), media_arrayList);

		list.setAdapter(adapter);
	}

	@Override
	public void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		list.setAdapter(null);

	}
}
