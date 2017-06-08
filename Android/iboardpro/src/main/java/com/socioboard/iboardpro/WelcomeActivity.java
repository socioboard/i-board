package com.socioboard.iboardpro;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

import android.app.Activity;
import android.app.Dialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.graphics.drawable.ColorDrawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.util.Base64;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.socioboard.iboardpro.adapter.viewpageradapter;
import com.socioboard.iboardpro.database.util.InstagramManyLocalData;
import com.socioboard.iboardpro.database.util.MainSingleTon;
import com.socioboard.iboardpro.database.util.ModelUserDatas;
import com.socioboard.iboardpro.instagramlibrary.InstagramApp;
import com.socioboard.iboardpro.instagramlibrary.InstagramApp.OAuthAuthenticationListener;
import com.socioboard.iboardpro.models.IntroViewPagerModel;
import com.viewpagerindicator.PageIndicator;

public class WelcomeActivity extends Activity {
	private InstagramApp mApp;
	ImageView connect;
	CommonUtilss utilss;
	InstagramManyLocalData db;
	PageIndicator indicator;
	ArrayList<IntroViewPagerModel> arrayList = new ArrayList<IntroViewPagerModel>();

	viewpageradapter viewpageradapter;
	Editor editor;
	TextView configureKey;
	SharedPreferences preferences;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.log_in);

		preferences = getSharedPreferences("iboardprokey", Context.MODE_PRIVATE);

		editor = getSharedPreferences("iboardprokey", Context.MODE_PRIVATE).edit();

		String clientid = GetClientIDKeys(ApplicationData.CLIENT_ID);
		String clientsecret = GetClientSecretKeys(ApplicationData.CLIENT_SECRET);

		MainSingleTon.api_key = preferences.getString(MainSingleTon.Tag_key,
				clientid);
		MainSingleTon.api_secret = preferences.getString(
				MainSingleTon.Tag_secret, clientsecret);
		MainSingleTon.api_redirect_url = preferences.getString(
				MainSingleTon.Tag_redirectUri, ApplicationData.CALLBACK_URL);

	
		connect = (ImageView) findViewById(R.id.signin);
		db = new InstagramManyLocalData(getApplicationContext());
		utilss = new CommonUtilss();

		final ConnectionDetector detector = new ConnectionDetector(
				getApplicationContext());

		connect.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				if (detector.isConnectingToInternet()) {
					mApp = new InstagramApp(WelcomeActivity.this, MainSingleTon.api_key,MainSingleTon.api_secret, MainSingleTon.api_redirect_url);
					mApp.setListener(listener);
					mApp.authorize();
				} else {
					Toast.makeText(getApplicationContext(),
							"Please connect to internet!", Toast.LENGTH_LONG)
							.show();
				}

			}
		});

		db.getAllUsersData();

		initviewpager();
	}

	void initviewpager() {
		// View Pager initialization
		configureKey = (TextView) findViewById(R.id.textView_privacy_prompt);
		ViewPager pager = (ViewPager) findViewById(R.id.pager);
		indicator = (PageIndicator) findViewById(R.id.indicator);

		IntroViewPagerModel model = new IntroViewPagerModel();
		model.setDrawable(R.drawable.intro_screen1);

		arrayList.add(model);

		IntroViewPagerModel model2 = new IntroViewPagerModel();
		model2.setDrawable(R.drawable.intro_screen2);

		arrayList.add(model2);

		IntroViewPagerModel model3 = new IntroViewPagerModel();
		model3.setDrawable(R.drawable.intro_screen3);

		arrayList.add(model3);

		IntroViewPagerModel model4 = new IntroViewPagerModel();
		model4.setDrawable(R.drawable.intro_screen4);

		arrayList.add(model4);

		IntroViewPagerModel model5 = new IntroViewPagerModel();
		model5.setDrawable(R.drawable.intro_screen5);

		arrayList.add(model5);

		viewpageradapter = new viewpageradapter(getApplicationContext(),
				arrayList);

		pager.setAdapter(viewpageradapter);
		indicator.setViewPager(pager);

		configureKey.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				initKeyDialog();
			}
		});

	}

	OAuthAuthenticationListener listener = new OAuthAuthenticationListener() {

		@Override
		public void onSuccess() {

			System.out.println("accessToken" + mApp.getAccessToken());

			new Setuserdata().execute(mApp.getProfileimageUrl());

		}

		@Override
		public void onFail(String error) {
			Toast.makeText(WelcomeActivity.this, error, Toast.LENGTH_SHORT)
					.show();
		}
	};

	class Setuserdata extends AsyncTask<String, Void, Void> {
		String imageString;

		@Override
		protected Void doInBackground(String... params) {

			String photourl = params[0];

			imageString = utilss.getImageBytearray(photourl);

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

			MainSingleTon.username = mApp.getName();
			MainSingleTon.userimage = imageString;
			MainSingleTon.accesstoken = mApp.getAccessToken();
			MainSingleTon.userid = mApp.getId();

			MainSingleTon.userdetails.put(mApp.getId(), datas);
			MainSingleTon.useridlist.add(mApp.getId());
			SharedPreferences lifesharedpref = getSharedPreferences(
					"iboardpro", Context.MODE_PRIVATE);
			SharedPreferences.Editor editor = lifesharedpref.edit();
			editor.putString("userid", mApp.getId());
			editor.commit();
			Intent intent = new Intent(getApplicationContext(),
					MainActivity.class);
			startActivity(intent);

			finish();
			Toast.makeText(WelcomeActivity.this, "sucess", Toast.LENGTH_SHORT)
					.show();
		}

	}

	public String GetClientIDKeys(String key)

	{
		String text1 = null;
		String finalkey = null;
		try {
			byte[] data1 = Base64
					.decode(ApplicationData.base64, Base64.DEFAULT);
			text1 = new String(data1, "UTF-8");
			System.out.println("base64 key" + text1);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();

		}

		try {
			finalkey = Encrypt.decrypt(text1, key);
		} catch (Exception e) {

			e.printStackTrace();
		}

		return finalkey;

	}

	public String GetClientSecretKeys(String key)

	{
		String text1 = null;
		String finalkey = null;
		try {
			byte[] data1 = Base64
					.decode(ApplicationData.base64, Base64.DEFAULT);
			text1 = new String(data1, "UTF-8");

		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();

		}

		try {
			finalkey = Encrypt.decrypt(text1, key);
		} catch (Exception e) {

			e.printStackTrace();
		}

		return finalkey;

	}

	private void initKeyDialog() {

		final int sdk = android.os.Build.VERSION.SDK_INT;

		final Dialog dialogIntkey = new Dialog(WelcomeActivity.this);

		dialogIntkey.requestWindowFeature(Window.FEATURE_NO_TITLE);

		dialogIntkey.setContentView(R.layout.apikeydialog);

		dialogIntkey.getWindow().setBackgroundDrawable(
				new ColorDrawable(android.graphics.Color.TRANSPARENT));

		WindowManager.LayoutParams lp = new WindowManager.LayoutParams();

		Window window = dialogIntkey.getWindow();

		lp.copyFrom(window.getAttributes());

		lp.width = WindowManager.LayoutParams.MATCH_PARENT;

		lp.height = WindowManager.LayoutParams.MATCH_PARENT;

		window.setAttributes(lp);

		dialogIntkey.getWindow().setBackgroundDrawable(new ColorDrawable(0));

		final EditText editText1Key;

		final EditText editText1Secret;

		final EditText editTextCallbcak;

		editText1Key = (EditText) dialogIntkey.findViewById(R.id.editText1Key);

		editText1Secret = (EditText) dialogIntkey
				.findViewById(R.id.editText1Secret);

		editTextCallbcak = (EditText) dialogIntkey
				.findViewById(R.id.editTextCallbcak);

		Button buttonPaste1, buttonPaste2, buttonPaste3;

		ImageView imageView2Info = (ImageView) dialogIntkey
				.findViewById(R.id.imageView2Info);

		imageView2Info.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				infoDialog();

			}
		});

		buttonPaste1 = (Button) dialogIntkey.findViewById(R.id.buttonPaste1);

		buttonPaste2 = (Button) dialogIntkey.findViewById(R.id.buttonPaste2);

		buttonPaste3 = (Button) dialogIntkey.findViewById(R.id.buttonPaste3);

		buttonPaste1.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				String pasteText;

				// TODO Auto-generated method stub

				if (sdk < android.os.Build.VERSION_CODES.HONEYCOMB) {

					android.text.ClipboardManager clipboard = (android.text.ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);

					pasteText = clipboard.getText().toString();

					editText1Key.append(pasteText);

				} else {

					ClipboardManager clipboard = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);

					if (clipboard.hasPrimaryClip() == true) {

						ClipData.Item item = clipboard.getPrimaryClip()
								.getItemAt(0);
						pasteText = item.getText().toString();
						editText1Key.append(pasteText);

					} else {

						Toast.makeText(getApplicationContext(),
								"Nothing to Paste", Toast.LENGTH_SHORT).show();

					}
				}

			

			}
		});

		buttonPaste2.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				String pasteText;

				if (sdk < android.os.Build.VERSION_CODES.HONEYCOMB) {

					android.text.ClipboardManager clipboard = (android.text.ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);

					pasteText = clipboard.getText().toString();

					editText1Secret.append(pasteText);

				} else {

					ClipboardManager clipboard = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);

					if (clipboard.hasPrimaryClip() == true) {

						ClipData.Item item = clipboard.getPrimaryClip()
								.getItemAt(0);
						pasteText = item.getText().toString();
						editText1Secret.append(pasteText);
					} else {

						Toast.makeText(getApplicationContext(),
								"Nothing to Paste", Toast.LENGTH_SHORT).show();
					}
				}
				

			}
		});

		buttonPaste3.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				String pasteText;

				if (sdk < android.os.Build.VERSION_CODES.HONEYCOMB) {

					android.text.ClipboardManager clipboard = (android.text.ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);

					pasteText = clipboard.getText().toString();

					editTextCallbcak.append(pasteText);

				} else {

					ClipboardManager clipboard = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);

					if (clipboard.hasPrimaryClip() == true) {

						ClipData.Item item = clipboard.getPrimaryClip()
								.getItemAt(0);
						pasteText = item.getText().toString();
						editTextCallbcak.append(pasteText);

					} else {

						Toast.makeText(getApplicationContext(),
								"Nothing to Paste", Toast.LENGTH_SHORT).show();

					}

				}

				

			}
		});

		RelativeLayout relativeLayout = (RelativeLayout) dialogIntkey
				.findViewById(R.id.reloutbottom);

		relativeLayout.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				boolean isEverythingOk1 = true, isEverythingOk2 = true, isEverythingOk3 = true;

				if (editText1Key.getText().toString().isEmpty()) {

					editText1Key.setError("Cannot be Empty");

					isEverythingOk1 = false;
				}

				if (editText1Secret.getText().toString().isEmpty()) {

					editText1Secret.setError("Cannot be Empty");

					isEverythingOk2 = false;
				}

				if (editTextCallbcak.getText().toString().isEmpty()) {

					editTextCallbcak.setError("Cannot be Empty");

					isEverythingOk3 = false;
				}

				if (isEverythingOk1 && isEverythingOk2 && isEverythingOk3) {

					MainSingleTon.api_key = editText1Key.getText().toString();

					MainSingleTon.api_secret = editText1Secret.getText().toString();

					MainSingleTon.api_redirect_url = editTextCallbcak.getText().toString();

					editor.putString(MainSingleTon.Tag_key, MainSingleTon.api_key);

					editor.putString(MainSingleTon.Tag_secret, MainSingleTon.api_secret);

					editor.putString(MainSingleTon.Tag_redirectUri, MainSingleTon.api_redirect_url);

					editor.commit();

					dialogIntkey.hide();
				}
			}
		});

		dialogIntkey.show();
	}

	protected void infoDialog() {

		final Dialog dialogIntkey = new Dialog(WelcomeActivity.this);

		dialogIntkey.requestWindowFeature(Window.FEATURE_NO_TITLE);

		dialogIntkey.setContentView(R.layout.keyhelp);

		dialogIntkey.getWindow().setBackgroundDrawable(
				new ColorDrawable(android.graphics.Color.TRANSPARENT));

		WindowManager.LayoutParams lp = new WindowManager.LayoutParams();

		Window window = dialogIntkey.getWindow();

		lp.copyFrom(window.getAttributes());

		lp.width = WindowManager.LayoutParams.MATCH_PARENT;

		lp.height = WindowManager.LayoutParams.MATCH_PARENT;

		window.setAttributes(lp);

		ImageView imageView2Info = (ImageView) dialogIntkey
				.findViewById(R.id.imageView1);

		imageView2Info.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				dialogIntkey.cancel();
			}
		});

		dialogIntkey.getWindow().setBackgroundDrawable(new ColorDrawable(0));

		dialogIntkey.setCancelable(true);

		dialogIntkey.show();
	}

}
