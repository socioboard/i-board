package com.socioboard.iboardpro.fragments;

import java.util.Calendar;

import android.app.AlarmManager;
import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.app.TimePickerDialog.OnTimeSetListener;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

import com.socioboard.iboardpro.MainActivity;
import com.socioboard.iboardpro.R;

/*
 * fragment is used for  scheduling users post
 */

public class Schedule_fragment extends Fragment {

	private static int RESULT_LOAD_IMG = 1;
	String imgDecodableString;
	ImageView pickedImage;
	String imagePath;
	EditText caption;
	private DatePickerDialog DatePickerDialog;
	int year, month, day;
	TextView schedulbtn, timebtn;
	int hourOfDay, minute;
	TimePicker timePicker;;
	DatePicker datePicker;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {

		View rootView = inflater.inflate(R.layout.schedule_layout, container,
				false);

		
		ImageView sendbtn = (ImageView) rootView.findViewById(R.id.bottombtn);
		pickedImage = (ImageView) rootView.findViewById(R.id.image);
		caption = (EditText) rootView.findViewById(R.id.captionText);
		schedulbtn = (TextView) rootView.findViewById(R.id.date);
		timebtn = (TextView) rootView.findViewById(R.id.time);
		pickedImage.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				Intent galleryIntent = new Intent(
						Intent.ACTION_PICK,
						android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
				// Start the Intent
				startActivityForResult(galleryIntent, RESULT_LOAD_IMG);
			}
		});

		sendbtn.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

			   //check everything filled by user or not 
				
				Calendar calendar = Calendar.getInstance();
				
				if (datePicker!=null && timePicker!=null) {
					
				
				
				calendar.set(datePicker.getYear(), datePicker.getMonth(),
						datePicker.getDayOfMonth(),
						timePicker.getCurrentHour(),
						timePicker.getCurrentMinute(), 0);

				long startTime = calendar.getTimeInMillis();

				if (startTime > System.currentTimeMillis()) {
					
					if (imagePath!=null) {
						
						//at desired time set alaram, to get local notification for sending photo.
						
						MainActivity.alarmManager.set(AlarmManager.RTC_WAKEUP,
								startTime, MainActivity.pendingIntent);
						Toast.makeText(
								getActivity(),
								"Post Sheduled successfully",
								Toast.LENGTH_LONG).show();
					}
					
					else {
						Toast.makeText(
								getActivity(),
								"Please select an image",
								Toast.LENGTH_LONG).show();
					}
					
					
				}

				else {
					Toast.makeText(
							getActivity(),
							"picked time should be more than current time",
							Toast.LENGTH_LONG).show();
				}

				
				
				SharedPreferences sharedpref=getActivity().getSharedPreferences("SavePhoto", Context.MODE_PRIVATE);
				SharedPreferences.Editor editor=sharedpref.edit();
				editor.putString("photostring", imagePath);
				
				if (caption.getText().toString()!=null) {
					editor.putString("caption", caption.getText().toString());
				}
				else {
					editor.putString("caption", "");
				}
				
				
				editor.commit();
				
			}
				else {
					Toast.makeText(
							getActivity(),
							"please select desire date or time",
							Toast.LENGTH_LONG).show();
				}
		
			}
		});

		schedulbtn.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				
				Calendar c = Calendar.getInstance(); 
				int cyear = c.get(Calendar.YEAR);
				int cmonth=c.get(Calendar.MONTH);
				int cday=c.get(Calendar.DAY_OF_MONTH);
				new DatePickerDialog(getActivity(), pickerListener, cyear,
						cmonth, cday).show();

			}
		});

		timebtn.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				
				//get the selected time
				
				Calendar c = Calendar.getInstance(); 
				int currenthour = c.get(Calendar.HOUR_OF_DAY);
				int currentminute=c.get(Calendar.MINUTE);
				System.out.println();
				
				TimePickerDialog tdialog=new TimePickerDialog(getActivity(), timelistner, currenthour,
						currentminute, false);
				
				
				
				tdialog.show();

			}
		});

		return rootView;
	}

	private DatePickerDialog.OnDateSetListener pickerListener = new DatePickerDialog.OnDateSetListener() {

		// when dialog box is closed, below method will be called.
		@Override
		public void onDateSet(DatePicker view, int selectedYear,
				int selectedMonth, int selectedDay) {

			datePicker = view;

			year = selectedYear;
			month = selectedMonth;
			day = selectedDay;

			// Show selected date
			schedulbtn.setText(new StringBuilder().append(month + 1)
					.append("-").append(day).append("-").append(year)
					.append(" "));

		}
		
		

	};

	private TimePickerDialog.OnTimeSetListener timelistner = new OnTimeSetListener() {

		@Override
		public void onTimeSet(TimePicker view, int hourOfDay, int minute) {

			timePicker = view;

			timebtn.setText(hourOfDay + ":" + minute);

		}
	};

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		super.onActivityResult(requestCode, resultCode, data);
		if (requestCode == RESULT_LOAD_IMG
				&& resultCode == getActivity().RESULT_OK && data != null) {
			// Let's read picked image data - its URI
			/*Uri pickedImageuri = data.getData();
			// Let's read picked image path using content resolver
			String[] filePath = { MediaStore.Images.Media.DATA };
			Cursor cursor = getActivity().getContentResolver().query(
					pickedImageuri, filePath, null, null, null);
			cursor.moveToFirst();
			imagePath = cursor.getString(cursor.getColumnIndex(filePath[0]));

			
			
			
			String  picturePath = cursor.getString(columnIndex);
			   cursor.close();
			   
			   //image.setImageURI(selectedImage);
			        
			        
			        
			   String selectedImagePath = getPath(selectedImage);
			   
			   Bitmap bitmap=decodeSampledBitmapFromResource(selectedImagePath,  200, 200);
			   //Bitmap bitmap=BitmapFactory.decodeFile(selectedImagePath);
			   bitmap=Bitmap.createScaledBitmap(bitmap, 100, 100, true);
			   ByteArrayOutputStream bmpStream = new ByteArrayOutputStream();
			        
			   bitmap.compress(Bitmap.CompressFormat.PNG, 100, bmpStream);
			pickedImage.setImageBitmap(BitmapFactory.decodeFile(imagePath));

			// At the end remember to close the cursor or you will end with the
			// RuntimeException!
			cursor.close();*/
			
			
			Uri selectedImage = data.getData();
			   String[] filePathColumn = { MediaStore.Images.Media.DATA };

			   Cursor cursor = getActivity().getContentResolver().query(selectedImage,
			     filePathColumn, null, null, null);
			   cursor.moveToFirst();

			   int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
			   String  picturePath = cursor.getString(columnIndex);
			   cursor.close();
			   
			   //image.setImageURI(selectedImage);
			        
			        
			        
			   String selectedImagePath = getPath(selectedImage);
			   
			   Bitmap bitmap=decodeSampledBitmapFromResource(selectedImagePath,  200, 200);
			   //Bitmap bitmap=BitmapFactory.decodeFile(selectedImagePath);
			   bitmap=Bitmap.createScaledBitmap(bitmap, 100, 100, true);
			   pickedImage.setImageBitmap(bitmap);
			   
		}

	}
	
	public String getPath(Uri uri) {
		   String[] projection = { MediaStore.Images.Media.DATA };
		   Cursor cursor=getActivity().getContentResolver().query(uri, projection, null, null, null);
		   //Cursor cursor = managedQuery(uri, projection, null, null, null);
		   int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
		   cursor.moveToFirst();
		   return cursor.getString(column_index);
		  }



		public  Bitmap decodeSampledBitmapFromResource(String res,  int reqWidth, int reqHeight) {

		    // First decode with inJustDecodeBounds=true to check dimensions
		    final BitmapFactory.Options options = new BitmapFactory.Options();
		    options.inJustDecodeBounds = true;
		    BitmapFactory.decodeFile(res,  options);

		    // Calculate inSampleSize
		    options.inSampleSize = calculateInSampleSize(options, reqWidth, reqHeight);

		    // Decode bitmap with inSampleSize set
		    options.inJustDecodeBounds = false;
		    return BitmapFactory.decodeFile(res,  options);
		}
		public  int calculateInSampleSize(
		        BitmapFactory.Options options, int reqWidth, int reqHeight) {
		// Raw height and width of image
		final int height = options.outHeight;
		final int width = options.outWidth;
		int inSampleSize = 1;

		if (height > reqHeight || width > reqWidth) {

		    final int halfHeight = height / 2;
		    final int halfWidth = width / 2;

		    // Calculate the largest inSampleSize value that is a power of 2 and keeps both
		    // height and width larger than the requested height and width.
		    while ((halfHeight / inSampleSize) > reqHeight
		            && (halfWidth / inSampleSize) > reqWidth) {
		        inSampleSize *= 2;
		    }
		}

		return inSampleSize;
		}
	
	
}
