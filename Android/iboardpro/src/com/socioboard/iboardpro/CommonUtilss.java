package com.socioboard.iboardpro;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Calendar;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.MediaScannerConnection;
import android.media.MediaScannerConnection.MediaScannerConnectionClient;
import android.net.Uri;
import android.os.Environment;
import android.util.Log;
import android.widget.Toast;

public class CommonUtilss {

	File imageFileFolder;
	MediaScannerConnection msConn = null;
	
	public Bitmap getImageBitmap(String photourl) {
		Bitmap bitmap = null;
		try {
			URL url = new URL(photourl);
			HttpURLConnection connection = null;
			connection = (HttpURLConnection) url.openConnection();
			connection.setDoInput(true);
			connection.connect();
			// InputStream input = connection.getInputStream();
			bitmap = BitmapFactory.decodeStream(url.openConnection()
					.getInputStream());

		} catch (MalformedURLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return bitmap;

	}

	public String getImageBytearray(String photourl) {
		String imagestring = null;
		Bitmap bitmap = null;
		byte[] imagearray = null;
		try {
			URL url = new URL(photourl);
			HttpURLConnection connection = null;
			connection = (HttpURLConnection) url.openConnection();
			connection.setDoInput(true);
			connection.connect();
			// InputStream input = connection.getInputStream();
			bitmap = BitmapFactory.decodeStream(url.openConnection()
					.getInputStream());

			ByteArrayOutputStream bmpStream = new ByteArrayOutputStream();

			bitmap.compress(Bitmap.CompressFormat.PNG, 100, bmpStream);

			imagearray = bmpStream.toByteArray();
			imagestring = Base64.encode(imagearray);

		} catch (MalformedURLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return imagestring;

	}

	public Bitmap getBitmapFromString(String imageEncodeString) {
		Bitmap bitmap = null;
		byte[] imagearray = null;
		try {

			imagearray = Base64.decode(imageEncodeString);
			bitmap = BitmapFactory.decodeByteArray(imagearray, 0,
					imagearray.length);
		} catch (Exception e) {
			// TODO: handle exception
		}

		return bitmap;

	}

	public void savePhoto(Bitmap bmp,Context context) {
		File imageFileName;

		imageFileFolder = new File(Environment.getExternalStorageDirectory(),
				"iBoardPro");
		imageFileFolder.mkdir();
		FileOutputStream out = null;
		Calendar c = Calendar.getInstance();
		String date = fromInt(c.get(Calendar.MONTH))
				+ fromInt(c.get(Calendar.DAY_OF_MONTH))
				+ fromInt(c.get(Calendar.YEAR))
				+ fromInt(c.get(Calendar.HOUR_OF_DAY))
				+ fromInt(c.get(Calendar.MINUTE))
				+ fromInt(c.get(Calendar.SECOND));
		imageFileName = new File(imageFileFolder, date.toString() + ".jpg");
		try {
			out = new FileOutputStream(imageFileName);
			bmp.compress(Bitmap.CompressFormat.JPEG, 100, out);
			out.flush();
			out.close();
			scanPhoto(imageFileName.toString(),context);
			out = null;
			
			
			Toast.makeText(context, "Photo Saved in gallery ",Toast.LENGTH_LONG).show();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public String fromInt(int val) {
		return String.valueOf(val);
	}

	public void scanPhoto(final String imageFileName,Context context) {

		msConn = new MediaScannerConnection(context,
				new MediaScannerConnectionClient() {
					public void onMediaScannerConnected() {
						msConn.scanFile(imageFileName, null);
						Log.i("msClient obj  in Photo Utility",
								"connection established");
					}

					public void onScanCompleted(String path, Uri uri) {
						msConn.disconnect();
						Log.i("msClient obj in Photo Utility", "scan completed");
					}

				});
		msConn.connect();
	}

}
