package com.socioboard.iboardpro.adapter;

import java.io.IOException;
import java.io.InputStream;
import java.lang.ref.WeakReference;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONObject;

import android.app.ProgressDialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.socioboard.iboardpro.JSONParser;
import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.lazylist.ImageLoader;
import com.socioboard.iboardpro.models.FollowModel;

public class FollowsAdapter extends BaseAdapter
{

	ArrayList<FollowModel> arrayList;
	FollowModel model;
	Context context;
	private ProgressDialog mSpinner;
	public ImageLoader imageLoader; 
	JSONParser jParser = new JSONParser();
	public FollowsAdapter(Context context,ArrayList<FollowModel> arrayList) {
		this.arrayList=arrayList;
		this.context=context;
		
		imageLoader=new ImageLoader(context);
	}
	
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return arrayList.size();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {
		
		model=arrayList.get(position);
		if (convertView == null)
        {
            LayoutInflater mInflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = mInflater.inflate(R.layout.follow_list_item, parent, false);
        }
		
		ImageView profile_imagView=(ImageView) convertView.findViewById(R.id.current_profile_pic);
		TextView user_nameText=(TextView) convertView.findViewById(R.id.user_name);
		ImageView unfollow_button=(ImageView) convertView.findViewById(R.id.unfollow_button);
		
		if (model.getFull_name().length()>2) {
			user_nameText.setText(model.getFull_name());
		}
		else {
			user_nameText.setText(model.getUsername());
		}
		
		 imageLoader.DisplayImage(model.getProfile_pic_url(), profile_imagView);
		
		
		unfollow_button.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
				model=arrayList.get(position);
				new follow_task().execute(model.getUserid());
			}
		});

		return convertView;
	}

	private class getBitmap extends AsyncTask<String, Void, Bitmap> {
		private final WeakReference imageViewReference;
		 Bitmap myBitmap;
		 
		 public  getBitmap(ImageView imageView) {
			 imageViewReference = new WeakReference(imageView);
		}
		@Override
		protected void onPreExecute() {
			myBitmap=null;
			super.onPreExecute();
		}
		@Override
		protected Bitmap doInBackground(String... params) {
			
			String src=params[0];
			System.out.println("src=="+src);
			 try {
			        URL url = new URL(src);
			        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			        connection.setDoInput(true);
			        connection.connect();
			        InputStream input = connection.getInputStream();
			        myBitmap = BitmapFactory.decodeStream(input);
			        return myBitmap;
			    } catch (IOException e) {
			        // Log exception
			        return null;
			    }
		}
		
		@Override
		protected void onPostExecute(Bitmap bitmap) {
			super.onPostExecute(bitmap);
			if (imageViewReference != null) {
				ImageView imageView = (ImageView) imageViewReference.get();
				if (imageView != null) {

					if (bitmap != null) {
						imageView.setImageBitmap(bitmap);
					} else {
						imageView.setImageDrawable(imageView.getContext().getResources()
								.getDrawable(R.drawable.account_image));
					}
				}

			}
		
		
		
	
	}

}
	
	 public class  follow_task extends AsyncTask<String, Void, Void>{

		 @Override
		protected void onPreExecute() {
			 mSpinner = new ProgressDialog(context);
				mSpinner.requestWindowFeature(Window.FEATURE_NO_TITLE);
				mSpinner.setMessage("Loading...");
		        
			 mSpinner.show();
		super.onPreExecute();
		}
		 
			@Override
			protected Void doInBackground(String... params) {
			
				String userid=params[0];
				
				String url="https://api.instagram.com/v1/users/"+userid+"/relationship/?access_token="+MainSingleTon.accesstoken;
				// key and value pair
		        List<NameValuePair> nameValuePair = new ArrayList<NameValuePair>(1);
		        nameValuePair.add(new BasicNameValuePair("action","unfollow"));
		        
				
		        JSONObject json=jParser.getJSONFromUrlByPost(url, nameValuePair);
				
				System.out.println("Unfollowed user status=="+json );
				
				
				return null;
			}
			 @Override
			protected void onPostExecute(Void result) {
				// TODO Auto-generated method stub
				super.onPostExecute(result);
				mSpinner.hide();
			}
		 }
}
