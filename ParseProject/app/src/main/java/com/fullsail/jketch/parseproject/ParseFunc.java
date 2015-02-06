package com.fullsail.jketch.parseproject;

import android.content.Context;
import android.util.Log;
import android.widget.Toast;

import com.parse.FindCallback;
import com.parse.ParseACL;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseUser;

import java.util.List;

/**
 * Created by jketch on 2/3/15.
 */
public class ParseFunc {

    public void saveDataToParse(Context c, String userName, String string, int theInt) {

        if (ParseUser.getCurrentUser() != null) {

            ParseObject personObject = new ParseObject("PersonData");
            personObject.put("user", userName);
            personObject.put("Name_String", string);
            personObject.put("Age_Number", theInt);
            personObject.saveInBackground();
            personObject.setACL(new ParseACL(ParseUser.getCurrentUser()));

            Toast.makeText(c, ParseUser.getCurrentUser().getUsername() + "'s Data is Saved to Parse", Toast.LENGTH_SHORT).show();

        }

    }

    public void DeleteUserDataInParse(Context c, final int index) {

        if (ParseUser.getCurrentUser() != null) {

            ParseQuery query = new ParseQuery("PersonData");
            query.whereEqualTo("user", ParseUser.getCurrentUser().getUsername());
            query.findInBackground(new FindCallback<ParseObject>() {
                public void done(List<ParseObject> object, ParseException e) {
                    if (e == null) {

                        ParseObject indexObject = object.get(index);
                        indexObject.deleteInBackground();

                    } else {
                        Log.d("Error", "Error: " + e.getMessage());
                    }
                }

            });

            Toast.makeText(c, ParseUser.getCurrentUser().getUsername() + "'s Data is Deleted from Parse", Toast.LENGTH_SHORT).show();

        }

    }


    public void DeleteUserInParse(Context c) {

        if (ParseUser.getCurrentUser() != null) {

            ParseUser pu = ParseUser.getCurrentUser();

            Toast.makeText(c, ParseUser.getCurrentUser().getUsername() + " has been Deleted from Parse", Toast.LENGTH_SHORT).show();

            pu.deleteInBackground();
        }

    }

}
