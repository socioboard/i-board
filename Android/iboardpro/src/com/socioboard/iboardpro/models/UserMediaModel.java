package com.socioboard.iboardpro.models;

import java.util.ArrayList;

public class UserMediaModel {

	String type;
	
	String commentsCount;
	ArrayList<CommentsModel> commentlist;
	String filter;
	String created_time;
	String post_link;
	ArrayList<LikesModel> likesList;
	String low_resolution_url;
	String thumbnail_url;
	String standard_resolution_url;
	String media_id;
	String location;
	String like_count;
	
	public String getLike_count() {
		return like_count;
	}
	public void setLike_count(String like_count) {
		this.like_count = like_count;
	}
	String postid;
	public String getPostid() {
		return postid;
	}
	public void setPostid(String postid) {
		this.postid = postid;
	}
	public String getLink() {
		return link;
	}
	public void setLink(String link) {
		this.link = link;
	}
	String link;
	
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	
	public String getCommentsCount() {
		return commentsCount;
	}
	public void setCommentsCount(String commentsCount) {
		this.commentsCount = commentsCount;
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
	public String getCreated_time() {
		return created_time;
	}
	public void setCreated_time(String created_time) {
		this.created_time = created_time;
	}
	public String getPost_link() {
		return post_link;
	}
	public void setPost_link(String post_link) {
		this.post_link = post_link;
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
	public String getMedia_id() {
		return media_id;
	}
	public void setMedia_id(String media_id) {
		this.media_id = media_id;
	}

	
}
