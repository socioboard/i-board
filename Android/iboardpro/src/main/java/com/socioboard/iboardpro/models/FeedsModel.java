package com.socioboard.iboardpro.models;

import java.util.ArrayList;

public class FeedsModel {
	String createdTime;
	ArrayList<String> tag_array;

	String type;
	String location_lattitude;
	String location_name;
	String location_longitude;
	String location_id;
	ArrayList<CommentsModel> commentlist;
	String filter;
	String likes_count;

	String comments_count;

	String link_toinstgram;
	ArrayList<LikesModel> likesList;
	String low_resolution_url;
	String thumbnail_url;
	String standard_resolution_url;
	ArrayList<UserInPhotoModel> user_in_photo_list;
	String text;

	String from_username;
	String from_profilepicture;
	String from_user_id;

	String from_fullname;
	String post_id;
	String feed_post_id;
	String caption_id;

	Boolean islike;

	public Boolean getIslike() {
		return islike;
	}

	public void setIslike(Boolean islike) {
		this.islike = islike;
	}

	public String getCaption_id() {
		return caption_id;
	}

	public void setCaption_id(String caption_id) {
		this.caption_id = caption_id;
	}

	public String getCreatedTime() {
		return createdTime;
	}

	public void setCreatedTime(String createdTime) {
		this.createdTime = createdTime;
	}

	public ArrayList<String> getTag_array() {
		return tag_array;
	}

	public void setTag_array(ArrayList<String> tag_array) {
		this.tag_array = tag_array;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getLocation_lattitude() {
		return location_lattitude;
	}

	public void setLocation_lattitude(String location_lattitude) {
		this.location_lattitude = location_lattitude;
	}

	public String getLocation_name() {
		return location_name;
	}

	public void setLocation_name(String location_name) {
		this.location_name = location_name;
	}

	public String getLocation_longitude() {
		return location_longitude;
	}

	public void setLocation_longitude(String location_longitude) {
		this.location_longitude = location_longitude;
	}

	public String getLocation_id() {
		return location_id;
	}

	public void setLocation_id(String location_id) {
		this.location_id = location_id;
	}

	public ArrayList<CommentsModel> getCommentlist() {
		return commentlist;
	}

	public void setCommentlist(ArrayList<CommentsModel> commentlist) {
		this.commentlist = commentlist;
	}

	public String getFilter() {
		return filter;
	}

	public void setFilter(String filter) {
		this.filter = filter;
	}

	public String getLink_toinstgram() {
		return link_toinstgram;
	}

	public void setLink_toinstgram(String link_toinstgram) {
		this.link_toinstgram = link_toinstgram;
	}

	public ArrayList<LikesModel> getLikesList() {
		return likesList;
	}

	public void setLikesList(ArrayList<LikesModel> likesList) {
		this.likesList = likesList;
	}

	public String getLow_resolution_url() {
		return low_resolution_url;
	}

	public void setLow_resolution_url(String low_resolution_url) {
		this.low_resolution_url = low_resolution_url;
	}

	public String getThumbnail_url() {
		return thumbnail_url;
	}

	public void setThumbnail_url(String thumbnail_url) {
		this.thumbnail_url = thumbnail_url;
	}

	public String getStandard_resolution_url() {
		return standard_resolution_url;
	}

	public void setStandard_resolution_url(String standard_resolution_url) {
		this.standard_resolution_url = standard_resolution_url;
	}

	public ArrayList<UserInPhotoModel> getUser_in_photo_list() {
		return user_in_photo_list;
	}

	public void setUser_in_photo_list(
			ArrayList<UserInPhotoModel> user_in_photo_list) {
		this.user_in_photo_list = user_in_photo_list;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getFrom_username() {
		return from_username;
	}

	public void setFrom_username(String from_username) {
		this.from_username = from_username;
	}

	public String getFrom_profilepicture() {
		return from_profilepicture;
	}

	public void setFrom_profilepicture(String from_profilepicture) {
		this.from_profilepicture = from_profilepicture;
	}

	public String getFrom_fullname() {
		return from_fullname;
	}

	public void setFrom_fullname(String from_fullname) {
		this.from_fullname = from_fullname;
	}

	public String getFeed_post_id() {
		return feed_post_id;
	}

	public void setFeed_post_id(String feed_post_id) {
		this.feed_post_id = feed_post_id;
	}

	public String getFrom_user_id() {
		return from_user_id;
	}

	public void setFrom_user_id(String from_user_id) {
		this.from_user_id = from_user_id;
	}

	public String getPost_id() {
		return post_id;
	}

	public void setPost_id(String post_id) {
		this.post_id = post_id;
	}

	public String getLikes_count() {
		return likes_count;
	}

	public void setLikes_count(String likes_count) {
		this.likes_count = likes_count;
	}

	public String getComments_count() {
		return comments_count;
	}

	public void setComments_count(String comments_count) {
		this.comments_count = comments_count;
	}
}
