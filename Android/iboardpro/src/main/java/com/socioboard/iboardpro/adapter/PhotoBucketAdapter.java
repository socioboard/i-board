package com.socioboard.iboardpro.adapter;

import android.content.Context;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;

import com.socioboard.iboardpro.MainActivity;
import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.fragments.PhotoViewFragment;
import com.socioboard.iboardpro.models.UserMediaModel;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;

public class PhotoBucketAdapter extends BaseAdapter {

    Context context;
    ArrayList<UserMediaModel> list;

    UserMediaModel model = new UserMediaModel();

    public PhotoBucketAdapter(Context context, ArrayList<UserMediaModel> list) {
        this.context = context;
        this.list = list;

    }

    @Override
    public int getCount() {
        // TODO Auto-generated method stub
        return list.size();
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


        model = list.get(position);
        if (convertView == null) {
            LayoutInflater mInflater = (LayoutInflater) context
                    .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = mInflater.inflate(R.layout.photo_bucket_listitem,
                    parent, false);
            convertView.setTag(Integer.valueOf(position));
        }
        ImageView profile_imagView = (ImageView) convertView
                .findViewById(R.id.image);

        Picasso.with(context).load(model.getLow_resolution_url()).into(profile_imagView);


        profile_imagView.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {

                MainSingleTon.photo_url = list.get(position).getStandard_resolution_url();

                Fragment fragment = new PhotoViewFragment();

                MainActivity.mainfragmentManager.beginTransaction().replace(R.id.main_content, fragment).addToBackStack(null)
                        .commit();

            }
        });


        return convertView;
    }

}
