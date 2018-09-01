package place.eos.eosmsg;

import android.os.Bundle;
import android.net.Uri;
import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.KeyEvent;
import android.view.Menu;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;
import android.webkit.ConsoleMessage;
import android.util.Log;
import android.view.*;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import android.net.Uri;
import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.content.pm.ActivityInfo;
import android.webkit.JavascriptInterface;
import android.content.res.AssetManager;
import java.io.*;
import java.lang.*;

public class MainActivity extends Activity
{
	protected static final String TAG = "EOSMSGMain";
	WebView myWebView;

	private static class CopyToAndroidLogThread extends Thread {
		private final BufferedReader mBufIn;
		private final String mStream;

		public CopyToAndroidLogThread(String stream, InputStream in) {
			mBufIn = new BufferedReader(new InputStreamReader(in));
			mStream = stream;
		}

		@Override
		public void run() {
			String tag = TAG + "/" + mStream + "-child";
			while (true) {
				String line = null;
				try {
					line = mBufIn.readLine();
				} catch (IOException e) {
					Log.d(tag, "CopyToAndroidLogThread: " + e.toString());
					return;
				}
				if (line == null) {
					return;
				}
				Log.d(tag, line);
			}
		}
	}

	private class MyWebViewClient extends WebViewClient {
		Activity activity;

		public MyWebViewClient(Activity a) {
			activity = a;
		}

		public boolean onConsoleMessage(ConsoleMessage cm){
			Log.d("CONTENT", String.format("%s @ %d: %s", 
						cm.message(), cm.lineNumber(), cm.sourceId()));
			return true;
		}

		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			return false;
		}

		@Override
		public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
			Toast.makeText(activity, "Oh no! " + description, Toast.LENGTH_SHORT).show();
		}
	}

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);   
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, 
				WindowManager.LayoutParams.FLAG_FULLSCREEN);

		setContentView(R.layout.main);

		myWebView = (WebView) findViewById(R.id.webview);
		WebSettings webSettings = myWebView.getSettings();
                webSettings.setLoadWithOverviewMode(true);
                webSettings.setUseWideViewPort(true);
                webSettings.setBuiltInZoomControls(true);
	        webSettings.setDisplayZoomControls(false);

		// habilita javascript
		webSettings.setJavaScriptEnabled(true);

		// inclui objeto nativo acessavel via javascript
		myWebView.addJavascriptInterface(new ColetorJS(this), "Coletor");

		// seta novo tratador de clicks em links
		myWebView.setWebViewClient(new MyWebViewClient(this));

		// Mostra carregamento de paginas
		final Activity activity = this;
		myWebView.setWebChromeClient(new WebChromeClient() {
			public void onProgressChanged(WebView view, int progress) {
				activity.setTitle("Carregando ... (" + progress + " %)");
				activity.setProgress(progress);
				if(progress == 100) {
					activity.setTitle("Game1");
				}         
			}
		});   

		try {
		   Thread.sleep(5000);
		} catch (InterruptedException e) {
		   Log.d(TAG, "Sleeping 5 secs");
		}

		// carrega pagina
		myWebView.loadUrl("https://eosplace.github.io/eosmsg/index.html");
		///myWebView.loadUrl("file:///android_asset/index.html");
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		return true;
	}

	@Override
	public void onBackPressed (){
		myWebView.loadUrl("javascript:sendEvent('back')");
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		// Check if the key event was the Back button and if there's history
		if ((keyCode == KeyEvent.KEYCODE_BACK) && myWebView.canGoBack()) {
			myWebView.goBack();
			return true;
		}

		// If it wasn't the Back key or there's no web page history, bubble up to the default
		// system behavior (probably exit the activity)
		return super.onKeyDown(keyCode, event);
	}

}
