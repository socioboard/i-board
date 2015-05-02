package com.socioboard.iboardpro.adapter;

import java.io.IOException;
import java.io.InputStream;
import java.lang.ref.WeakReference;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.models.FollowModel;

public class NonFollowersAdapter extends BaseAdapter
{

	ArrayList<FollowModel> arrayList;
	FollowModel model;
	Context context;
	
	
	public NonFollowersAdapter(Context context,ArrayList<FollowModel> arrayList) {
		this.arrayList=arrayList;
		this.context=context;
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
	public View getView(int position, View convertView, ViewGroup parent) {
		
		model=arrayList.get(position);
		if (convertView == null)
        {
            LayoutInflater mInflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = mInflater.inflate(R.layout.follow_by_list_item, parent, false);
        }
		
		ImageView profile_imagView=(ImageView) convertView.findViewById(R.id.current_profile_pic);
		TextView user_nameText=(TextView) convertView.findViewById(R.id.user_name);
		Button follow_button=(Button) convertView.findViewById(R.id.follow_button);
		
		if (model.getFull_name().length()>2) {
			user_nameText.setText(model.getFull_name());
		}
		else {
			user_nameText.setText(model.getUsername());
		}
		
		if (profile_imagView != null) {
			new getBitmap(profile_imagView).execute(model.getProfile_pic_url());
		}

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
}
