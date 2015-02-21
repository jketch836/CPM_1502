package com.fullsail.jketch.parseproject;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Created by jketch on 2/19/15.
 */
public class PersonAdapter extends BaseAdapter {


    private static final long ID_CONSTANT = 0x00001;

    private Context theContext;
    PersonClass pc;


    private ArrayList<PersonClass> personList;

    public PersonAdapter(Context c, ArrayList al) {

        theContext = c;
        personList = al;

    }

    @Override
    public int getCount() {
        return personList.size();
    }

    @Override
    public Object getItem(int position) {
        return personList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return ID_CONSTANT + position;
    }

    @Override
    public View getView(int position, View v, ViewGroup parent) {

        if (v == null) {
            v = View.inflate(theContext, R.layout.people_list_layout, null);
        }

        pc = (PersonClass) getItem(position);

        TextView nameTV = (TextView) v.findViewById(R.id.theName);
        nameTV.setText(pc.enteredName());

        TextView ageTV = (TextView) v.findViewById(R.id.theAge);
        ageTV.setText("" + pc.enteredAge());

        return v;

    }

}
