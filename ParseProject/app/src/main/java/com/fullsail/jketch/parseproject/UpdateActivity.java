package com.fullsail.jketch.parseproject;

import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;


public class UpdateActivity extends ActionBarActivity {

    Bundle b;

    ParseFunc parseFunc = new ParseFunc();

    Button updateButton;
    Button cancelButton;
    EditText updateName;
    EditText updateAge;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_update);

        b = getIntent().getExtras();

//        final String objectID = b.getString("objectID");

        final int theIndex = b.getInt("theIndex");

        String theName = b.getString("theName");
        int theAge = b.getInt("theAge");

        updateButton = (Button) findViewById(R.id.updateButton);
        cancelButton = (Button) findViewById(R.id.cancelButton);
        updateName = (EditText) findViewById(R.id.updateNameText);
        updateAge = (EditText) findViewById(R.id.updateAgeText);

        updateName.setText(theName);
        updateAge.setText("" + theAge);

        if (isOnline(UpdateActivity.this)) {

            updateButton.setEnabled(true);

        } else {

            updateButton.setEnabled(false);

        }

        updateButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (updateName.length() > 0 || updateAge.length() > 0) {

                    String name = updateName.getText().toString();

                    String age = updateAge.getText().toString();

                   int theInt = Integer.parseInt(age);

                    Intent intent = new Intent();

                    Bundle bundle = new Bundle();

                    bundle.putParcelable("updated", new PersonClass(name, theInt));
                    intent.putExtras(bundle);
                    setResult(RESULT_OK,intent);

                    parseFunc.UpdateUserData(UpdateActivity.this, theIndex, name, theInt);


                    finish();

                } else {

                    new AlertDialog.Builder(UpdateActivity.this)
                            .setTitle("Opps...")
                            .setMessage("Need to Enter Name and/or Age to Proceed")
                            .setPositiveButton("OK", null)
                            .show();

                }

            }
        });


        cancelButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                finish();

            }
        });

    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_update, menu);
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

    protected boolean isOnline(Context c) {

        ConnectivityManager cm = (ConnectivityManager) c.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo netInfo = cm.getActiveNetworkInfo();

        return netInfo != null && netInfo.isConnectedOrConnecting();

    }

}
