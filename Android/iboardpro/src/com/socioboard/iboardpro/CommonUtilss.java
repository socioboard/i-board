package com.socioboard.iboardpro;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

public class CommonUtilss {

	public Bitmap getImageBitmap(String photourl)
	{
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
	
	public String getImageBytearray(String photourl)
	{
		String imagestring=null;
		Bitmap bitmap = null;
		byte[] imagearray=null;
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
		       
		        imagearray=bmpStream.toByteArray();
			    imagestring=Base64.encode(imagearray);
			    
		        
			   } catch (MalformedURLException e1) {
			    // TODO Auto-generated catch block
			    e1.printStackTrace();
			   } catch (IOException e) {
			    // TODO Auto-generated catch block
			    e.printStackTrace();
			   }
		
		return imagestring;
		
	}
	
	public Bitmap getBitmapFromString(String imageEncodeString)
	{
		Bitmap bitmap=null;
		byte[] imagearray=null;
		try {
			
			imagearray=Base64.decode(imageEncodeString);
			bitmap=BitmapFactory.decodeByteArray(imagearray, 0, imagearray.length);
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		return bitmap;
		
		
	}
	
	
}
