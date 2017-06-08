package com.socioboard.iboardpro.models;

 

public class RowItemLocations {


    private String displayAddres;
    private String latitute;
    private String longitute;
    private String lastMessage;
    private String online;
    private String xmppId;

    public String getLastMessage() {
		return lastMessage;
	}

	public void setLastMessage(String lastMessage) {
		this.lastMessage = lastMessage;
	}

	public RowItemLocations(String displayAddres, String latitute, String longitute, String lastMessage, String online, String xmppId ){
        this.displayAddres = displayAddres;
        this.latitute = latitute;
        this.longitute=longitute;
        this.lastMessage =lastMessage;
        this.online = online;
        this.xmppId = xmppId;
    }

     

	@Override
	public String toString() {
		return "RowItemMessage [latitute=" + latitute + ", longitute=" + longitute
				+ ", lastMessage=" + lastMessage + ", online=" + online
				+ ", xmppId=" + xmppId + "]";
	}

	public RowItemLocations() {

    }

	public String getdisplayAddres() {
		return displayAddres;
	}

	public void setdisplayAddres(String displayAddres) {
		this.displayAddres = displayAddres;
	}

	public String getlatitute() {
		return latitute;
	}

	public void setlatitute(String latitute) {
		this.latitute = latitute;
	}

	public String getlongitute() {
		return longitute;
	}

	public void setlongitute(String longitute) {
		this.longitute = longitute;
	}

	public String getOnline() {
		return online;
	}

	public void setOnline(String online) {
		this.online = online;
	}

	public String getXmppId() {
		return xmppId;
	}

	public void setXmppId(String xmppId) {
		this.xmppId = xmppId;
	}




}
