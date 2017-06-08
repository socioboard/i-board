package com.socioboard.iboardpro;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.annotation.TargetApi;
import android.app.AlarmManager;
import android.app.AlertDialog;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.Point;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.widget.DrawerLayout;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.widget.Toolbar;
import android.util.TypedValue;
import android.view.Display;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewAnimationUtils;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.flurry.android.FlurryAgent;
import com.socioboard.iboardpro.adapter.AccountAdapter;
import com.socioboard.iboardpro.adapter.DrawerAdapter;
import com.socioboard.iboardpro.database.util.InstagramManyLocalData;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.database.util.ModelUserDatas;
import com.socioboard.iboardpro.dialog.Multi_Dialog;
import com.socioboard.iboardpro.dialog.Radio_Dialog;
import com.socioboard.iboardpro.dialog.Single_Dialog;
import com.socioboard.iboardpro.dialog.Standard_Dialog;
import com.socioboard.iboardpro.fragments.Copy_follows;
import com.socioboard.iboardpro.fragments.Fans_Fragments;
import com.socioboard.iboardpro.fragments.Followed_By;
import com.socioboard.iboardpro.fragments.Follows_Fragment;
import com.socioboard.iboardpro.fragments.Mutual_Fragments;
import com.socioboard.iboardpro.fragments.NearBySearch_Fragment;
import com.socioboard.iboardpro.fragments.Nonfollowers_Fragment;
import com.socioboard.iboardpro.fragments.Photo_Bucket;
import com.socioboard.iboardpro.fragments.Schedule_fragment;
import com.socioboard.iboardpro.fragments.Search_Tag;
import com.socioboard.iboardpro.instagramlibrary.InstagramApp;
import com.socioboard.iboardpro.instagramlibrary.InstagramApp.OAuthAuthenticationListener;
import com.socioboard.iboardpro.ui.Items;
import com.socioboard.iboardpro.ui.MultiSwipeRefreshLayout;

import java.util.ArrayList;

public class MainActivity extends ActionBarActivity implements
		MultiSwipeRefreshLayout.CanChildScrollUpCallback {

	/*
	 * first configure client secret and application key in ApplicationData.java
	 */
	boolean doubleBackToExitPressedOnce;
	public static FragmentManager mainfragmentManager;
	FragmentManager fragmentManager;
	private InstagramApp mApp;
	public static Menu yoyo;
	private String[] mDrawerTitles;

	private ArrayList<ModelUserDatas> accountList;
	private TypedArray mDrawerIcons;
	private ArrayList<Items> drawerItems;
	private DrawerLayout mDrawerLayout;

	private ListView mDrawerList_Left, mDrawerList_Right;

	private ActionBarDrawerToggle mDrawerToggle;
	private CharSequence mDrawerTitle;
	private CharSequence mTitle;

	private AccountAdapter accountAdapter;
	private static FragmentManager mManager;

	// SwipeRefreshLayout allows the user to swipe the screen down to trigger a
	// manual refresh
	private MultiSwipeRefreshLayout mSwipeRefreshLayout;

	TextView current_user_name, curret_user_username, feedbacktxt;
	ImageView curret_user_profilepic,settings_view;

	RelativeLayout addacount_view, feedback_view,
			configurekeys_view;

	CommonUtilss utills;
	InstagramManyLocalData db;

	int selected_fragment;

	public static PendingIntent pendingIntent;
	public static AlarmManager alarmManager;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		
		Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
		if (toolbar != null)
			setSupportActionBar(toolbar);

		mManager = getSupportFragmentManager();

		accountList = new ArrayList<ModelUserDatas>();

		// mDrawerTitles = getResources().getStringArray(R.array.drawer_titles);
		mDrawerIcons = getResources().obtainTypedArray(R.array.drawer_icons);
		drawerItems = new ArrayList<Items>();
		mDrawerList_Left = (ListView) findViewById(R.id.left_drawer);
		mDrawerTitles = getResources().getStringArray(R.array.drawer_titles);
		mDrawerList_Right = (ListView) findViewById(R.id.right_drawer);
		mainfragmentManager = getSupportFragmentManager();
		utills = new CommonUtilss();

		// initialise sqllite db
		db = new InstagramManyLocalData(getApplicationContext());

		accountList.clear();

		// load data from sql-locallite n save in accountlist array list

		for (int i = 0; i < MainSingleTon.useridlist.size(); i++) {
			ModelUserDatas model = MainSingleTon.userdetails
					.get(MainSingleTon.useridlist.get(i));

			model.setUserid(model.getUserid());
			model.setUserAcessToken(model.getUserAcessToken());
			model.setUserimage(model.getUserimage());
			model.setUsername(model.getUsername());
			accountList.add(model);
		}

		// set left navigation drawer item

		for (int i = 0; i < mDrawerTitles.length; i++) {
			drawerItems.add(new Items(mDrawerTitles[i], mDrawerIcons
					.getResourceId(i, -(i + 1))));
		}

		mTitle = mDrawerTitle = getTitle();

		mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
		mDrawerToggle = new ActionBarDrawerToggle(this, /* host Activity */
		mDrawerLayout, /* DrawerLayout object */
		toolbar, /* nav drawer icon to replace 'Up' caret */
		R.string.drawer_open, /* "open drawer" description */
		R.string.drawer_close /* "close drawer" description */
		) {

			/** Called when a drawer has settled in a completely closed state. */
			public void onDrawerClosed(View view) {
				super.onDrawerClosed(view);
				getSupportActionBar().setTitle(mTitle);
				yoyo.findItem(R.id.action_settings).setVisible(true);
				// invalidateOptionsMenu();

			}

			/** Called when a drawer has settled in a completely open state. */
			public void onDrawerOpened(View drawerView) {
				super.onDrawerOpened(drawerView);
				getSupportActionBar().setTitle(mDrawerTitle);
				// invalidateOptionsMenu();

			}
		};

		// Set the drawer toggle as the DrawerListener
		mDrawerLayout.setDrawerListener(mDrawerToggle);

		LayoutInflater inflater = getLayoutInflater();

	

		final ViewGroup headerR = (ViewGroup) inflater.inflate(R.layout.header,
				mDrawerList_Right, false);

		final ViewGroup footerR = (ViewGroup) inflater.inflate(R.layout.footer,
				mDrawerList_Right, false);
		final ViewGroup footerL = (ViewGroup) inflater.inflate(
				R.layout.left_footer, mDrawerList_Right, false);

		feedback_view = (RelativeLayout) footerR.findViewById(R.id.feedback);
		configurekeys_view = (RelativeLayout) footerR
				.findViewById(R.id.configurekeys);

		current_user_name = (TextView) headerR.findViewById(R.id.currentname);
		curret_user_username = (TextView) headerR
				.findViewById(R.id.currentusername);
		curret_user_profilepic = (ImageView) headerR
				.findViewById(R.id.current_profile_pic);

		addacount_view = (RelativeLayout) footerR
				.findViewById(R.id.add_account);
		settings_view = (ImageView) footerR.findViewById(R.id.settings);
		feedback_view = (RelativeLayout) footerR.findViewById(R.id.feedback);

		curret_user_username.setText(MainSingleTon.username);
		curret_user_profilepic.setImageBitmap(utills
				.getBitmapFromString(MainSingleTon.userimage));

		curret_user_profilepic.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				Toast.makeText(getApplicationContext(), "profile image",
						Toast.LENGTH_LONG).show();
			}
		});

		// type mail address to send feedback mail
		feedback_view.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				Intent emailIntent = new Intent(Intent.ACTION_SENDTO, Uri
						.fromParts("mailto", ApplicationData.feedback_emailID,
								null));
				emailIntent.putExtra(Intent.EXTRA_SUBJECT,
						"Feedback for inBoardpro");
				startActivity(Intent
						.createChooser(emailIntent, "Send email..."));

			}
		});

		configurekeys_view.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				AlertDialog.Builder builder = new AlertDialog.Builder(
						MainActivity.this);

				builder.setTitle("Warning!!");
				builder.setMessage("This will remove all existing accounts,click Yes to continue");

				builder.setPositiveButton("YES",
						new DialogInterface.OnClickListener() {

							public void onClick(DialogInterface dialog,
									int which) {

								dialog.dismiss();

								MainSingleTon.accesstoken = null;
								MainSingleTon.userid = null;
								InstagramManyLocalData dbdata = new InstagramManyLocalData(
										getApplicationContext());

								dbdata.deleteAllRows();
								
								Editor editor = getSharedPreferences(
										"iboardpro", Context.MODE_PRIVATE)
										.edit();

								MainSingleTon.userdetails.clear();
								MainSingleTon.useridlist.clear();

								editor.clear();

								Intent in = new Intent(getApplicationContext(),
										WelcomeActivity.class);
								startActivity(in);
								finish();

							}

						});

				builder.setNegativeButton("NO",
						new DialogInterface.OnClickListener() {

							@Override
							public void onClick(DialogInterface dialog,
									int which) {
								// Do nothing
								dialog.dismiss();
							}
						});

				AlertDialog alert = builder.create();
				alert.show();

			}
		});

		addacount_view.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				mApp = new InstagramApp(MainActivity.this,
						MainSingleTon.api_key, MainSingleTon.api_secret,
						MainSingleTon.api_redirect_url);
				mApp.setListener(listener);
				mApp.authorize();

			}
		});

		// Give your Toolbar a subtitle!
		/* mToolbar.setSubtitle("Subtitle"); */

		// clickable
		mDrawerList_Left.addFooterView(footerL, null, false); // true =
																// clickable

		mDrawerList_Right.addHeaderView(headerR, null, true); // true =
																// clickable
		mDrawerList_Right.addFooterView(footerR, null, true); // true =
																// clickable

		// Set width of drawer
		DrawerLayout.LayoutParams lp = (DrawerLayout.LayoutParams) mDrawerList_Left
				.getLayoutParams();
		lp.width = calculateDrawerWidth();
		mDrawerList_Left.setLayoutParams(lp);

		// Set width of drawer
		DrawerLayout.LayoutParams lpR = (DrawerLayout.LayoutParams) mDrawerList_Right
				.getLayoutParams();
		lpR.width = calculateDrawerWidth();
		mDrawerList_Right.setLayoutParams(lpR);

		// Set the adapter for the list view
		mDrawerList_Left.setAdapter(new DrawerAdapter(getApplicationContext(),
				drawerItems));
		// Set the list's click listener
		mDrawerList_Left.setOnItemClickListener(new DrawerItemClickListener());

		// Set the adapter for the list view
		mDrawerList_Right.setAdapter(new AccountAdapter(MainActivity.this,
				accountList));
		// Set the list's click listener
		mDrawerList_Right
				.setOnItemClickListener(new RightDrawerItemClickListener());

		/*
		 * Initialise broadcast intent
		 * 
		 * using alaram manager service for getting local notification for
		 * reminding user to send photo
		 */

		Intent myIntent = new Intent(MainActivity.this,
				SchedulerCustomReceiver.class);
		pendingIntent = PendingIntent.getBroadcast(MainActivity.this, 0,
				myIntent, PendingIntent.FLAG_UPDATE_CURRENT);
		alarmManager = (AlarmManager) getSystemService(ALARM_SERVICE);

		NotificationManager mNotificationManager = (NotificationManager) this
				.getApplicationContext().getSystemService(
						this.getApplicationContext().NOTIFICATION_SERVICE);
		mNotificationManager.cancelAll();
		alarmManager.cancel(pendingIntent);

		mainfragmentManager = getSupportFragmentManager();
		mainfragmentManager.beginTransaction()
				.replace(R.id.main_content, new Photo_Bucket()).commit();

		// Parse installation class for Devices

		// ParseInstallation.getCurrentInstallation().saveInBackground();

		// new GetProfileData().execute();

	}

	

	OAuthAuthenticationListener listener = new OAuthAuthenticationListener() {

		@Override
		public void onSuccess() {

			new Setuserdata().execute(mApp.getProfileimageUrl());

		}

		@Override
		public void onFail(String error) {
			Toast.makeText(MainActivity.this, error, Toast.LENGTH_SHORT).show();
		}
	};

	@Override
	protected void onPostCreate(Bundle savedInstanceState) {
		super.onPostCreate(savedInstanceState);
		// Sync the toggle state after onRestoreInstanceState has occurred.
		mDrawerToggle.syncState();
		trySetupSwipeRefresh();
	}

	@Override
	public void onConfigurationChanged(Configuration newConfig) {
		super.onConfigurationChanged(newConfig);
		mDrawerToggle.onConfigurationChanged(newConfig);
		System.out.println(" + + + + +   onConfigurationChanged + + + + +");
	}

	/**
	 * Swaps fragments in the main content view
	 */

	private void selectItem(int position) {
		Fragment fragment = null;

		selected_fragment = position;
		switch (position) {

		case 0:
			MainSingleTon.location_arraylist.clear();
			fragment = new NearBySearch_Fragment();
			break;
		case 1:

			fragment = new Follows_Fragment();
			break;
		case 2:

			fragment = new Photo_Bucket();
			break;

		case 3:
			fragment = new Schedule_fragment();

			break;
		case 4:
			fragment = new Search_Tag();
			break;


		}
		if (fragment != null) {
			// Insert the fragment by replacing any existing fragment
			mainfragmentManager = getSupportFragmentManager();
			mainfragmentManager.beginTransaction()
					.replace(R.id.main_content, fragment).addToBackStack(null)
					.commit();
		}

		// Highlight the selected item, update the title, and close the drawer
		if (mDrawerList_Left.isEnabled()) {
			mDrawerList_Left.setItemChecked(position, true);

			setTitle(mDrawerTitles[position]);
			updateView(position, position, true, mDrawerList_Left);

			mDrawerLayout.closeDrawer(mDrawerList_Left);
		} else {
			mDrawerList_Right.setItemChecked(position, true);
			if (position != 0) {
				setTitle(mDrawerTitles[position - 1]);
				updateView(position, position, true, mDrawerList_Right);
			}
			mDrawerLayout.closeDrawer(mDrawerList_Right);
		}

	}

	private class RightDrawerItemClickListener implements
			ListView.OnItemClickListener {
		@Override
		public void onItemClick(AdapterView parent, View view, int position,
				long id) {
			selectItemRight(position);
		}
	}

	private void selectItemRight(final int position) {

		System.out.println("position===" + position);
		if (position > 0) {

			runOnUiThread(new Runnable() {

				@Override
				public void run() {

					/*
					 * after selecting account store all data in public variable
					 * to use it everywhere.
					 */

					ModelUserDatas model = MainSingleTon.userdetails
							.get(accountList.get(position - 1).getUserid());
					MainSingleTon.userid = model.getUserid();
					MainSingleTon.username = model.getUsername();
					MainSingleTon.userimage = model.getUserimage();
					MainSingleTon.accesstoken = model.getUserAcessToken();

					// store current profile in shared preference to reuse after
					// restarting app

					MainSingleTon.userdetails.put(MainSingleTon.userid, model);
					MainSingleTon.useridlist.add(MainSingleTon.userid);
					SharedPreferences lifesharedpref = getSharedPreferences(
							"FacebookBoard", Context.MODE_PRIVATE);
					SharedPreferences.Editor editor = lifesharedpref.edit();
					editor.putString("userid", MainSingleTon.userid);
					editor.commit();

					curret_user_username.setText(MainSingleTon.username);
					curret_user_profilepic.setImageBitmap(utills
							.getBitmapFromString(MainSingleTon.userimage));

					Fragment fragment = null;

					switch (selected_fragment) {
					
					case 0:

						fragment = new Follows_Fragment();
						break;
					case 1:

						fragment = new Followed_By();
						break;
					case 2:

						fragment = new Photo_Bucket();
						break;
					case 3:
						fragment = new Nonfollowers_Fragment();

						break;

					case 4:
						fragment = new Schedule_fragment();
						break;
					case 5:
						fragment = new Fans_Fragments();
						break;
					case 6:
						fragment = new Mutual_Fragments();
						break;
					case 7:
						fragment = new Copy_follows();
						break;
					}

					if (fragment != null) {
						// Insert the fragment by replacing any existing
						// fragment
						mainfragmentManager = getSupportFragmentManager();
						mainfragmentManager.beginTransaction()
								.replace(R.id.main_content, fragment)
								.addToBackStack(null).commit();
					}

					mDrawerLayout.closeDrawer(mDrawerList_Right);
				}
			});
		}
	}

	@Override
	public void setTitle(CharSequence title) {
		mTitle = title;
		getSupportActionBar().setTitle(mTitle);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		System.out.println("onCreateOptionsMenu");
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.menu_main, menu);

		return true;
	}

	/* Called whenever we call invalidateOptionsMenu() */
	@Override
	public boolean onPrepareOptionsMenu(Menu menu) {
		yoyo = menu;
		System.out.println("onPrepareOptionsMenu");
		// If the nav drawer is open, hide action items related to the content
		// view
		boolean drawerOpen = mDrawerLayout.isDrawerOpen(mDrawerList_Left);

		boolean drawerOpenR = mDrawerLayout.isDrawerOpen(mDrawerList_Right);

		if (mDrawerLayout.isDrawerOpen(mDrawerList_Right)) {
			mDrawerLayout.closeDrawer(mDrawerList_Right);
			yoyo.findItem(R.id.action_settings).setVisible(true);
		} else {
			yoyo.findItem(R.id.action_settings).setVisible(false);
			mDrawerLayout.openDrawer(mDrawerList_Right);

		}
		return super.onPrepareOptionsMenu(menu);
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		System.out.println("onOptionsItemSelected");
		if (mDrawerToggle.onOptionsItemSelected(item)) {
			return true;

		}
		if (mDrawerLayout.isDrawerOpen(mDrawerList_Right)) {
			mDrawerLayout.closeDrawer(mDrawerList_Right);
		} else {
			mDrawerLayout.openDrawer(mDrawerList_Right);
		}
		return super.onOptionsItemSelected(item);
	}

	public int calculateDrawerWidth() {
		// Calculate ActionBar height
		TypedValue tv = new TypedValue();
		int actionBarHeight = 0;
		if (getTheme().resolveAttribute(android.R.attr.actionBarSize, tv, true)) {
			actionBarHeight = TypedValue.complexToDimensionPixelSize(tv.data,
					getResources().getDisplayMetrics());
		}

		Display display = getWindowManager().getDefaultDisplay();
		int width;
		int height;
		if (android.os.Build.VERSION.SDK_INT >= 13) {
			Point size = new Point();
			display.getSize(size);
			width = size.x;
			height = size.y;
		} else {
			width = display.getWidth(); // deprecated
			height = display.getHeight(); // deprecated
		}
		return width - actionBarHeight;
	}

	private void updateView(int position, int counter, boolean visible,
			ListView mDrawerList) {

		View v = mDrawerList.getChildAt(position
				- mDrawerList.getFirstVisiblePosition());
		TextView someText = (TextView) v.findViewById(R.id.item_new);
		Resources res = getResources();
		String articlesFound = "";

		switch (position) {
		case 1:
			articlesFound = res.getQuantityString(
					R.plurals.numberOfNewArticles, counter, counter);
			someText.setBackgroundResource(R.drawable.new_apps);
			break;
		case 2:
			articlesFound = res.getQuantityString(
					R.plurals.numberOfNewArticles, counter, counter);
			someText.setBackgroundResource(R.drawable.new_sales);
			break;
		case 3:
			articlesFound = res.getQuantityString(
					R.plurals.numberOfNewArticles, counter, counter);
			someText.setBackgroundResource(R.drawable.new_blog);
			break;
		case 4:
			articlesFound = res.getQuantityString(
					R.plurals.numberOfNewArticles, counter, counter);
			someText.setBackgroundResource(R.drawable.new_bookmark);
			break;
		case 5:
			articlesFound = res.getQuantityString(
					R.plurals.numberOfNewArticles, counter, counter);
			someText.setBackgroundResource(R.drawable.new_community);
			break;
		}

		someText.setText(articlesFound);
		if (visible) {
			// someText.setVisibility(View.VISIBLE);
		}
	}

	@Override
	public boolean canSwipeRefreshChildScrollUp() {
		return false;
	}

	private void trySetupSwipeRefresh() {
		mSwipeRefreshLayout = (MultiSwipeRefreshLayout) findViewById(R.id.swipe_refresh_layout);
		if (mSwipeRefreshLayout != null) {
			mSwipeRefreshLayout.setColorSchemeResources(
					R.color.refresh_progress_1, R.color.refresh_progress_2,
					R.color.refresh_progress_3);
			mSwipeRefreshLayout
					.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
						@Override
						public void onRefresh() {
							Toast.makeText(getApplication(), "Refresh!",
									Toast.LENGTH_LONG);
						}
					});

			if (mSwipeRefreshLayout instanceof MultiSwipeRefreshLayout) {
				MultiSwipeRefreshLayout mswrl = (MultiSwipeRefreshLayout) mSwipeRefreshLayout;
				mswrl.setCanChildScrollUpCallback(this);
			}
		}
	}

	private class DrawerItemClickListener implements
			ListView.OnItemClickListener {
		@Override
		public void onItemClick(AdapterView parent, View view, int position,
				long id) {
			selectItem(position);
		}
	}

	@TargetApi(Build.VERSION_CODES.LOLLIPOP)
	public void circleIn(View view) {

		// get the center for the clipping circle
		int cx = (view.getLeft() + view.getRight()) / 2;
		int cy = (view.getTop() + view.getBottom()) / 2;

		// get the final radius for the clipping circle
		int finalRadius = Math.max(view.getWidth(), view.getHeight());

		// create the animator for this view (the start radius is zero)
		Animator anim = ViewAnimationUtils.createCircularReveal(view, cx, cy,
				0, finalRadius);

		// make the view visible and start the animation
		view.setVisibility(View.VISIBLE);
		anim.start();
	}

	@TargetApi(Build.VERSION_CODES.LOLLIPOP)
	public void circleOut(final View view) {

		// get the center for the clipping circle
		int cx = (view.getLeft() + view.getRight()) / 2;
		int cy = (view.getTop() + view.getBottom()) / 2;

		// get the initial radius for the clipping circle
		int initialRadius = view.getWidth();

		// create the animation (the final radius is zero)
		Animator anim = ViewAnimationUtils.createCircularReveal(view, cx, cy,
				initialRadius, 0);

		// make the view invisible when the animation is done
		anim.addListener(new AnimatorListenerAdapter() {
			@Override
			public void onAnimationEnd(Animator animation) {
				super.onAnimationEnd(animation);
				view.setVisibility(View.INVISIBLE);
			}
		});

		// start the animation
		anim.start();
	}

	/**
	 * Sets the components of the standard dialog.
	 *
	 * @param title
	 *            Title of the dialog
	 * @param message
	 *            Message of the dialog
	 * @param negativeButton
	 *            Text of negative Button
	 * @param positiveButton
	 *            Text of postive Button
	 */
	public static void showMyDialog(String title, String message,
			String negativeButton, String positiveButton) {
		Standard_Dialog newDialog = Standard_Dialog.newInstance(title, message,
				negativeButton, positiveButton);
		newDialog.show(mManager, "dialog");
	}

	/**
	 * Sets the components of the traditional single-choice dialog.
	 *
	 * @param title
	 *            Title of the dialog
	 * @param dialogItems
	 *            Content of the dialog
	 * @param negativeButton
	 *            Text of negative Button
	 * @param positiveButton
	 *            Text of postive Button
	 */
	public static void showMySingleDialog(String title,
			ArrayList<String> dialogItems, String negativeButton,
			String positiveButton) {
		Single_Dialog newDialog = Single_Dialog.newInstance(title, dialogItems,
				negativeButton, positiveButton);
		newDialog.show(mManager, "dialog");
	}

	/**
	 * Sets the components of the persistent single-choice dialog.
	 *
	 * @param title
	 *            Title of the dialog
	 * @param dialogItems
	 *            Content of the dialog
	 * @param negativeButton
	 *            Text of negative Button
	 * @param positiveButton
	 *            Text of postive Button
	 */
	public static void showMyRadioDialog(String title,
			ArrayList<String> dialogItems, String negativeButton,
			String positiveButton) {
		Radio_Dialog newDialog = Radio_Dialog.newInstance(title, dialogItems,
				negativeButton, positiveButton);
		newDialog.show(mManager, "dialog");
	}

	/**
	 * Sets the components of the persistent multiple-choice dialog.
	 *
	 * @param title
	 *            Title of the dialog
	 * @param dialogItems
	 *            Content of the dialog
	 * @param negativeButton
	 *            Text of negative Button
	 * @param positiveButton
	 *            Text of postive Button
	 */
	public static void showMyMultiDialog(String title,
			ArrayList<String> dialogItems, String negativeButton,
			String positiveButton) {
		Multi_Dialog newDialog = Multi_Dialog.newInstance(title, dialogItems,
				negativeButton, positiveButton);
		newDialog.show(mManager, "dialog");
	}

	class Setuserdata extends AsyncTask<String, Void, Void> {
		String imageString;

		@Override
		protected Void doInBackground(String... params) {

			String photourl = params[0];

			imageString = utills.getImageBytearray(photourl);

			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			// TODO Auto-generated method stub
			super.onPostExecute(result);

			ModelUserDatas datas = new ModelUserDatas();
			datas.setUserAcessToken(mApp.getAccessToken());
			datas.setUserid(mApp.getId());
			datas.setUsername(mApp.getName());
			datas.setUserimage(imageString);

			db.addNewUserAccount(datas);

			accountList.add(datas);

			accountAdapter = new AccountAdapter(MainActivity.this, accountList);
			// Set the adapter for the list view
			mDrawerList_Right.setAdapter(accountAdapter);

			MainSingleTon.userdetails.put(mApp.getId(), datas);
			MainSingleTon.useridlist.add(mApp.getId());

			Toast.makeText(MainActivity.this, "sucess", Toast.LENGTH_SHORT)
					.show();

			// new GetProfileData().execute();

		}

	}

	public void notifyadapter() {

		// after removing account notify the account list adapter

		accountList.clear();

		for (int i = 0; i < MainSingleTon.useridlist.size(); i++) {
			ModelUserDatas model = MainSingleTon.userdetails
					.get(MainSingleTon.useridlist.get(i));

			model.setUserid(model.getUserid());
			model.setUserAcessToken(model.getUserAcessToken());
			model.setUserimage(model.getUserimage());
			model.setUsername(model.getUsername());
			accountList.add(model);
		}
		accountAdapter.notifyDataSetChanged();
	}

	@Override
	public void onBackPressed() {
		// TODO Auto-generated method stub

		if (mDrawerLayout.isDrawerOpen(Gravity.RIGHT)) {
			mDrawerLayout.closeDrawer(Gravity.RIGHT);
		} else if (mainfragmentManager.getBackStackEntryCount() < 1) {

			if (doubleBackToExitPressedOnce) {
				super.onBackPressed();
				return;
			}

			this.doubleBackToExitPressedOnce = true;
			Toast.makeText(this, "Please click BACK again to exit",
					Toast.LENGTH_SHORT).show();

			new Handler().postDelayed(new Runnable() {

				@Override
				public void run() {
					doubleBackToExitPressedOnce = false;
				}
			}, 2000);
		} else {
			mainfragmentManager.popBackStack();
		}

	}

	@Override
	protected void onStart() {
		// TODO Auto-generated method stub
		super.onStart();
		FlurryAgent.onStartSession(MainActivity.this);
	}

	@Override
	protected void onStop() {
		// TODO Auto-generated method stub
		super.onStop();
		FlurryAgent.onEndSession(MainActivity.this);
	}

}
