package com.fullsail.jketch.parseproject;

import android.app.Activity;
import android.os.Bundle;

import com.parse.Parse;


public class MainActivity extends Activity implements PersonInterface{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Parse.initialize(this, getString(R.string.PARSE_APPLICATION_ID), getString(R.string.PARSE_CLIENT_KEY));

        getFragmentManager().beginTransaction()
                .replace(R.id.PersonFrame, PersonFragment.newInstance(), PersonFragment.PersonString)
                .commit();

    }


    @Override
    public void personInfo() {

    }
}

