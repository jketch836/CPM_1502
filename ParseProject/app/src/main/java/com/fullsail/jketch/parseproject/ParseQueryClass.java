package com.fullsail.jketch.parseproject;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseQueryAdapter;
import com.parse.ParseUser;

/**
 * Created by jketch on 2/5/15.
 */
public class ParseQueryClass extends ParseQueryAdapter<ParseObject> {

    TextView nameTV;
    TextView ageTV;


    public ParseQueryClass(Context context) {

        super(context, new ParseQueryAdapter.QueryFactory<ParseObject>() {
            public ParseQuery create() {
                ParseQuery theQuery = new ParseQuery("PersonData");
                theQuery.whereEqualTo("user", ParseUser.getCurrentUser().getUsername());
                return theQuery;
            }
        });
    }



    @Override
    public View getItemView(ParseObject o, View v, ViewGroup parent) {
        if (v == null) {
            v = View.inflate(getContext(), R.layout.people_list_layout, null);
        }
        super.getItemView(o, v, parent);

        nameTV = (TextView) v.findViewById(R.id.theName);
        nameTV.setText(o.getString("Name_String"));
        ageTV = (TextView) v.findViewById(R.id.theAge);
        ageTV.setText("" + o.getInt("Age_Number"));

        return v;
    }

}
