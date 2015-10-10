package com.socioboard.iboardpro.adapter;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.RadioButton;
import android.widget.TextView;

import com.socioboard.iboardpro.R;
import com.socioboard.iboardpro.models.RowItemLocations;

public class CustomAdpLocations extends BaseAdapter  
{
	private Context context;
	private ArrayList<RowItemLocations> heightList;
	RadioButton radioButton;
	TextView height;
	 
	public CustomAdpLocations(Context context, ArrayList<RowItemLocations> heightList)
	{
		this.context=context;
		this.heightList = heightList;
		 
	}

	@Override
	public int getCount() {
		return heightList.size();
	}

	@Override
	public Object getItem(int position) 
	{
		return heightList.get(position);
	}

	@Override
	public long getItemId(int position) 
	{
		return position;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {

		LayoutInflater mInflater = (LayoutInflater)
				context.getSystemService(Activity.LAYOUT_INFLATER_SERVICE);

		convertView = mInflater.inflate(R.layout.height_dialog_listitem, null);
		height = (TextView) convertView.findViewById(R.id.heighttextview);
		radioButton = (RadioButton) convertView.findViewById(R.id.radioButton1);
		radioButton.setVisibility(View.INVISIBLE);

		height.setText(heightList.get(position).getdisplayAddres());
	
		return convertView;
	}



}
