package com.socioboard.iboardpro;

public class ConstantUrl {

	public static String URL_Follows="https://api.instagram.com/v1/users/self/follows/?access_token=";
	public static String URL_FollowedBy="https://api.instagram.com/v1/users/self/followed-by/?access_token=";
	public static String URL_Media="https://api.instagram.com/v1/users/self/media/recent/?access_token=";
	public static String URL_Feeds="https://api.instagram.com/v1/users/self/feed/?access_token=";
	//public static String URL_GetUserID="https://api.instagram.com/v1/users/search?q=[USERNAME]&client_id="+ApplicationData.CLIENT_ID;
	public static String URL_Userdata="https://api.instagram.com/v1/users/self/?access_token=";
	
	public static String URL_Tag_Search="https://api.instagram.com/v1/tags/search";
	public static String URL_Tag_feeds="https://api.instagram.com/v1/tags/";
	
	public static String URL_Location_search="https://api.instagram.com/v1/locations/search?";
	//lat=48.858844&lng=2.294351&access_token=ACCESS-TOKEN";
	
	public static String URL_Location_media="https://api.instagram.com/v1/locations/";
			//+ "{location-id}/media/recent?access_token=ACCESS-TOKEN";
}
