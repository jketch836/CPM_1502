package com.fullsail.jketch.parseproject;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import com.parse.Parse;
import com.parse.ParseUser;
import com.parse.ui.ParseLoginBuilder;

import java.util.ArrayList;


public class MainActivity extends ActionBarActivity {


    ListView lv;

    EditText nameText;
    EditText ageText;

    Button button;
    ParseFunc pf = new ParseFunc();

    String name;
    int theInt;
    String age;

    int index;

    public ArrayList<PersonClass> pcal = new ArrayList<PersonClass>();
    PersonAdapter pa;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Parse.initialize(this, getString(R.string.PARSE_APPLICATION_ID), getString(R.string.PARSE_CLIENT_KEY));

//        getFragmentManager().beginTransaction()
//                .replace(R.id.PersonFrame, PersonFragment.newInstance(), PersonFragment.PersonString)
//                .commit();

        lv = (ListView) findViewById(R.id.theListView);

        nameText = (EditText) findViewById(R.id.nameText);
        ageText = (EditText) findViewById(R.id.ageText);

        button = (Button) findViewById(R.id.button);

        pa = new PersonAdapter(MainActivity.this, pcal);

        UserStatus();

    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (resultCode == RESULT_OK) {

            //read the bundle and get the country object
            Bundle bundle = data.getExtras();
            PersonClass person = bundle.getParcelable("updated");

            pcal.set(index, person);

            setRefresh();

        }

    }


    @Override
    protected void onResume() {
        super.onResume();

//        PersonFragment personFragment = (PersonFragment) getFragmentManager().findFragmentByTag(PersonFragment.PersonString);
//
//        personFragment.setRefresh();



//        Timer timer = new Timer();
//
//        timer.scheduleAtFixedRate(new TimerTask() {
//            @Override
//            public void run() {
//
//
//            }
//
//        }, 0, 15000);


    }

    protected void UserStatus() {

        if (ParseUser.getCurrentUser() == null) {

            ParseLoginBuilder builder = new ParseLoginBuilder(MainActivity.this);
            startActivityForResult(builder.build(), 0);

//            lv.setAdapter(null);

        } else {

            setRefresh();

            button.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    EntryCheck();

                }
            });


            lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                    index = position;

                    final String name = pcal.get(position).name;

                    final int integer = pcal.get(position).anInt;

                    new AlertDialog.Builder(MainActivity.this)
                            .setTitle("What Action?")
                            .setMessage("What Do You Want to Do?")
                            .setPositiveButton("Delete", new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {

                                    new AlertDialog.Builder(MainActivity.this)
                                            .setTitle("Are You Sure")
                                            .setMessage("You want to Delete " + name + "?")
                                            .setPositiveButton("YES", new DialogInterface.OnClickListener() {
                                                @Override
                                                public void onClick(DialogInterface dialog, int which) {

                                                    pf.DeleteUserDataInParse(MainActivity.this, index, pcal, pa);

                                                }
                                            })
                                            .setNegativeButton("NO", null)
                                            .show();

                                }
                            })
                            .setNegativeButton("Update", new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {

                                    Intent updateIntent = new Intent(MainActivity.this, UpdateActivity.class);

                                    updateIntent.putExtra("theName", name);
                                    updateIntent.putExtra("theAge", integer);
                                    updateIntent.putExtra("theIndex", index);
                                    startActivity(updateIntent);

                                }
                            })
                            .setNeutralButton("Cancel", null)
                            .show();

                }
            });

        }

    }


    protected void EntryCheck() {

        if (nameText.length() > 0 || ageText.length() > 0) {

            name = nameText.getText().toString();

            age = ageText.getText().toString();

            theInt = Integer.parseInt(age);

            pf.saveDataToParse(MainActivity.this, ParseUser.getCurrentUser().getUsername(), name, theInt, pcal, pa);

            nameText.setText("");
            ageText.setText("");

        } else {

            new AlertDialog.Builder(MainActivity.this)
                    .setTitle("Opps...")
                    .setMessage("Need to Enter Name and/or Age to Proceed")
                    .setPositiveButton("OK", null)
                    .show();

        }
    }


    public void setRefresh() {

        pf.ParseQuery(MainActivity.this, pcal, pa, lv);


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
        if (id == R.id.action_refresh) {

            setRefresh();

        } else if (id == R.id.action_logOut) {

            Toast.makeText(MainActivity.this, ParseUser.getCurrentUser().getUsername() + " has Logged Out", Toast.LENGTH_SHORT).show();

            ParseUser.logOut();

            if (ParseUser.getCurrentUser() == null) {

                lv.setAdapter(null);

            }


            UserStatus();

        }

        return super.onOptionsItemSelected(item);
    }

}
