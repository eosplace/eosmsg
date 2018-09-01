package place.eos.eosmsg;

import java.io.File;
import java.io.FileReader;
import java.util.Hashtable;
import android.content.Context;
import android.os.Environment;
import android.widget.Toast;
import java.net.*;
import java.io.*;
import android.util.Log;
import org.json.JSONArray;
import android.content.SharedPreferences;


public class ConfiguracaoManager {
  private static final String TAG = "trumae";
  private static final String TAG_PHONE = "phone";
  private static final String TAG_CODE = "code";
  private static final String TAG_HASH = "hash";

  public static String getStoredPhone(Context context) {
    SharedPreferences pref = context.getSharedPreferences(TAG, context.MODE_PRIVATE);

    String phone = pref.getString(TAG_PHONE, null);   
    return phone;
  }

  public static void setStoredPhone(Context context, String id) {
    SharedPreferences pref = context.getSharedPreferences(TAG, context.MODE_PRIVATE);

    SharedPreferences.Editor editor = pref.edit();
    editor.putString(TAG_PHONE, id);
    editor.commit();  
  }

  public static String getStoredCode(Context context) {
    SharedPreferences pref = context.getSharedPreferences(TAG, context.MODE_PRIVATE);

    String code = pref.getString(TAG_CODE, null);   
    return code;
  }

  public static void setStoredCode(Context context, String id) {
    SharedPreferences pref = context.getSharedPreferences(TAG, context.MODE_PRIVATE);

    SharedPreferences.Editor editor = pref.edit();
    editor.putString(TAG_CODE, id);
    editor.commit();  
  }

  public static String getStoredHash(Context context) {
    SharedPreferences pref = context.getSharedPreferences(TAG, context.MODE_PRIVATE);

    String hash = pref.getString(TAG_HASH, null);   
    return hash;
  }

  public static void setStoredHash(Context context, String id) {
    SharedPreferences pref = context.getSharedPreferences(TAG, context.MODE_PRIVATE);

    SharedPreferences.Editor editor = pref.edit();
    editor.putString(TAG_HASH, id);
    editor.commit();  
  }
}
