package com.socioboard.iboardpro.adapter;

import java.util.ArrayList;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.socioboard.iboardpro.CommonUtilss;
import com.socioboard.iboardpro.MainActivity;
import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.database.util.InstagramManyLocalData;
import com.socioboard.iboardpro.database.util.ModelUserDatas;


/**
 * Created by d4ddy-lild4rk on 11/8/14.
 */
public class AccountAdapter extends BaseAdapter
{

	CommonUtilss utilss;
    private Context context;
    private ArrayList<ModelUserDatas> navDrawerItems;
    MainActivity mainActivity =null;
    public AccountAdapter(Context context, ArrayList<ModelUserDatas> navDrawerItems) 
    {
        this.context = context;
        this.navDrawerItems = navDrawerItems;
        utilss=new CommonUtilss();
        mainActivity =(MainActivity) context;
    }

    @Override
    public int getCount() {
        return navDrawerItems.size();
    }

    @Override
    public Object getItem(int position) {
        return navDrawerItems.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent)
    {

        if (convertView == null)
        {
            LayoutInflater mInflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = mInflater.inflate(R.layout.account_item, parent, false);
        }

        ImageView profilePic = (ImageView) convertView.findViewById(R.id.profile_pic);
        ImageView settingspic = (ImageView) convertView.findViewById(R.id.settings);
        
        TextView text = (TextView) convertView.findViewById(R.id.user_name);

      
       profilePic.setImageBitmap(utilss.getBitmapFromString(navDrawerItems.get(position).getUserimage()));
       
        text.setText(navDrawerItems.get(position).getUsername());

        settingspic.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
				AlertDialog.Builder builder = new AlertDialog.Builder(mainActivity);

			    builder.setTitle("Delete account!!");
			    builder.setMessage("Are you sure to remove this account?");

			    builder.setPositiveButton("YES", new DialogInterface.OnClickListener() {

			        public void onClick(DialogInterface dialog, int which) {
			           
			        	
			        	if (navDrawerItems.size()>1) {
			        		InstagramManyLocalData dbdata = new InstagramManyLocalData(context);

				        	dbdata.deleteThisUserData(navDrawerItems.get(position).getUserid());
				        	dbdata.getAllUsersData();
				            
				        	mainActivity.notifyadapter();
						}
			        	else {
			        		
			        		Toast.makeText(context, "Sorry !!, You can not remove your primary account",Toast.LENGTH_LONG ).show();
			        		 dialog.dismiss();
						}

			           
			        }

			    });

			    builder.setNegativeButton("NO", new DialogInterface.OnClickListener() {

			        @Override
			        public void onClick(DialogInterface dialog, int which) {
			            // Do nothing
			            dialog.dismiss();
			        }
			    });

			    AlertDialog alert = builder.create();
			    alert.show();
				
			}
		});
       
        
        
        return convertView;
    }

    
}
