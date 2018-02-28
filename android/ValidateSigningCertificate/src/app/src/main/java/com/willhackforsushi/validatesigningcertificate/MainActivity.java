package com.willhackforsushi.validatesigningcertificate;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

// Code adapted from:
// Makan, Keith; Alexander-Bown, Scott (2013-12-23). Android Security Cookbook (p. 179). Packt Publishing. Kindle Edition. 

public class MainActivity extends ActionBarActivity {

    private static String CERTIFICATE_SHA1 = "DD1C1115D3E2CB99AB05F98F0C8190E16FDDA4C7";

    private static String calcSHA1(byte[] signature) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("SHA1");
        digest.update(signature);
        byte[] signatureHash = digest.digest();
        return bytesToHex(signatureHash);
    }

    public static String bytesToHex(byte[] bytes) {
        final char[] hexArray = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
        char[] hexChars = new char[bytes.length * 2];
        int v;
        for (int j = 0; j < bytes.length; j++) {
            v = bytes[j] & 0xFF;
            hexChars[j * 2] = hexArray[v >>> 4];
            hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }
        return new String(hexChars);
    }

    public static boolean validateAppSignature(Context context) {
        try {
            // get the signature form the package manager
            PackageInfo packageInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), PackageManager.GET_SIGNATURES);
            Signature[] appSignatures = packageInfo.signatures;
            // this sample only checks the first certificate
            for (Signature signature : appSignatures) {
                byte[] signatureBytes = signature.toByteArray();
                // calc sha1 in hex
                String currentSignature = calcSHA1(signatureBytes);
                // compare signatures
                Log.i("ValidateSigningCertificate", "Signature is " + currentSignature + " (" + CERTIFICATE_SHA1 + ")");
                return CERTIFICATE_SHA1.equalsIgnoreCase(currentSignature);
            }
        } catch (Exception e) { // if error assume failed to validate
            return false;
        }

        return false;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        final Button button = (Button) findViewById(R.id.button);
        button.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                TextView t;
                t = (TextView) findViewById(R.id.textView);
                if (validateAppSignature(getApplicationContext())) {
                    t.setText("Signature is good.");
                } else {
                    t.setText("Signature is bad.");
                }
            }
        });

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
