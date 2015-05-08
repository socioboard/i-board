package com.socioboard.iboardpro.database.util;

import java.util.ArrayList;
import java.util.HashMap;

public class MainSingleTon {

	public static boolean signedInStatus = false;
	public static String userid;
	public static String username;
	public static ArrayList<String> useridlist=new ArrayList<String>();
	public static String accesstoken;
	public static String userimage;
	public static HashMap<String, ModelUserDatas> userdetails=new HashMap<String, ModelUserDatas>();
	public static boolean isPAgesLoaded;

	public static String NextUrl;
	public static String photo_url;
	
}
