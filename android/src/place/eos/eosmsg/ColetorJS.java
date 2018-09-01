package place.eos.eosmsg;

import android.content.Context;
import android.webkit.JavascriptInterface;
import android.telephony.TelephonyManager;
import android.telephony.SmsManager;
import android.widget.Toast;
import android.content.Intent;
import java.io.*;
import android.os.*;
import android.view.*;
import java.util.*;
import java.text.*;
import java.security.*;
import android.view.inputmethod.*;

public class ColetorJS {
  MainActivity main;
  private Intent intent;  
  private String result;

  /** Instantiate the interface and set the context */
  ColetorJS(MainActivity c) {
    main = c;
  }
  
  /** Show a toast from the web page */
  @JavascriptInterface
  public void showToast(String toast) {
    Toast.makeText(main, toast, Toast.LENGTH_SHORT).show();
  }

  @JavascriptInterface
  public String getMyPhoneNumber(){
    TelephonyManager mTelephonyMgr;
    mTelephonyMgr = (TelephonyManager)
      main.getSystemService(Context.TELEPHONY_SERVICE); 
    return mTelephonyMgr.getLine1Number();
  }
  
  @JavascriptInterface
  public String getIMEI(){
    TelephonyManager mTelephonyMgr;
    mTelephonyMgr = (TelephonyManager)
      main.getSystemService(Context.TELEPHONY_SERVICE); 
    return mTelephonyMgr.getDeviceId();
  }

  @JavascriptInterface
  public boolean sendSMS(String phoneNo, String msg) {
	  try {      
		  SmsManager smsManager = SmsManager.getDefault();
		  smsManager.sendTextMessage(phoneNo, null, msg, null, null);    
		  return true;
	  } catch (Exception ex) {
		  ex.printStackTrace();
		  return false;
	  } 
  }

  @JavascriptInterface
  public void showKeyboard() {
    InputMethodManager imm = (InputMethodManager) main.getSystemService(Context.INPUT_METHOD_SERVICE);
    View v = main.getCurrentFocus();
    if (v != null)
        imm.showSoftInput(v, 0);
  }
  
  @JavascriptInterface
  public void hideKeyboard() {
    InputMethodManager imm = (InputMethodManager) main.getSystemService(Context.INPUT_METHOD_SERVICE);
    View v = main.getCurrentFocus();
    if (v != null)
        imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
  }

  @JavascriptInterface
  public boolean isKeyboardActive() {
    InputMethodManager imm = (InputMethodManager)
                             main.getSystemService(Context.INPUT_METHOD_SERVICE);
    if(imm != null){
      return imm.isActive();
    }
    return false;
  }

  private String md5(String s) {
    try {
      // Create MD5 Hash
      MessageDigest digest = java.security.MessageDigest.getInstance("MD5");
      digest.update(s.getBytes());
      byte messageDigest[] = digest.digest();

      // Create Hex String
      StringBuffer hexString = new StringBuffer();
      for (int i=0; i<messageDigest.length; i++)
        hexString.append(Integer.toHexString(0xFF & messageDigest[i]));
      return hexString.toString();

    } catch (NoSuchAlgorithmException e) {
      e.printStackTrace();
    }
    return "";
  }

  @JavascriptInterface
  public String hash(String s){
    return md5(s + "vapt" + s + "line");
  }

  @JavascriptInterface
  public String getStoredPhone() {
    String ret = ConfiguracaoManager.getStoredPhone(main);
    if (ret == null) {
      ret = "";
    }
    return ret;
  }

  @JavascriptInterface
  public String getStoredCode() {
    String ret = ConfiguracaoManager.getStoredCode(main);
    if (ret == null) {
      ret = "";
    }
    return ret;
  }

  @JavascriptInterface
  public String getStoredHash() {
    String ret = ConfiguracaoManager.getStoredHash(main);
    if (ret == null) {
      ret = "";
    }
    return ret;
  }

  @JavascriptInterface
  public void setStoredPhone(String s) {
    ConfiguracaoManager.setStoredPhone(main, s);
  }

  @JavascriptInterface
  public void setStoredCode(String s) {
    ConfiguracaoManager.setStoredCode(main, s);
  }

  @JavascriptInterface
  public void setStoredHash(String s) {
    ConfiguracaoManager.setStoredHash(main, s);
  }

  @JavascriptInterface
  public void finish() {
    android.os.Process.killProcess(android.os.Process.myPid());
  }

}

