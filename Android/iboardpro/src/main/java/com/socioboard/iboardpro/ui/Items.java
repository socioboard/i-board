package com.socioboard.iboardpro.ui;

/**
 * 
 */
public class Items {


	private String title;// Name
	private String item_new;
	private int icon;
	String userid;
	String userAcessToken;

	public Items() {

	}

	public Items(String title, String item_new, int icon, String userid,
			String userAcessToken) {
 		this.title = title;
		this.item_new = item_new;
		this.icon = icon;
		this.userid = userid;
		this.userAcessToken = userAcessToken;
	}
	public Items(String title,   int icon ) {
 		this.title = title;
 		this.icon = icon;
		 
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getUserAcessToken() {
		return userAcessToken;
	}

	public void setUserAcessToken(String userAcessToken) {
		this.userAcessToken = userAcessToken;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public int getIcon() {
		return icon;
	}

	public void setIcon(int icon) {
		this.icon = icon;
	}

	public String getItem_new() {
		return item_new;
	}

	public void setItem_new(String item_new) {
		this.item_new = item_new;
	}
}
