package com.fullsail.jketch.parseproject;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.util.Log;
import android.widget.ListView;
import android.widget.Toast;

import com.parse.FindCallback;
import com.parse.GetCallback;
import com.parse.ParseACL;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseUser;
import com.parse.SaveCallback;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by jketch on 2/3/15.
 */
public class ParseFunc {


    public void saveDataToParse(Context c, String userName, String string, int theInt, ArrayList<PersonClass> pc, PersonAdapter pa) {

        if (ParseUser.getCurrentUser() != null) {

            pc.add(new PersonClass(string, theInt));

            final ParseObject personObject = new ParseObject("PersonData");

            personObject.put("user", userName);
            personObject.put("Name_String", string);
            personObject.put("Age_Number", theInt);

            if (isOnline(c)) {

                personObject.saveInBackground();

                personObject.setACL(new ParseACL(ParseUser.getCurrentUser()));

                Toast.makeText(c, string + " is added to Contacts", Toast.LENGTH_SHORT).show();

            } else {

                Toast.makeText(c, "Go Online so " + string + " will be saved to contacts", Toast.LENGTH_SHORT).show();

                personObject.saveInBackground();

            }

            pa.notifyDataSetChanged();

        }

    }


    public void DeleteUserDataInParse(final Context c, final int index, ArrayList<PersonClass> personList, PersonAdapter pa) {

        if (ParseUser.getCurrentUser() != null) {

            personList.remove(index);

            pa.notifyDataSetChanged();

            ParseQuery<ParseObject> query = new ParseQuery<ParseObject>("PersonData");
            query.whereEqualTo("user", ParseUser.getCurrentUser().getUsername());
            query.findInBackground(new FindCallback<ParseObject>() {
                public void done(List<ParseObject> object, ParseException e) {
                    if (e == null) {

                        ParseObject indexObject = object.get(index);
                        Log.d("", indexObject.getObjectId());

                        if (isOnline(c)) {

                            indexObject.deleteInBackground();

                            Toast.makeText(c, object.get(index).getString("Name_String") + " is Deleted", Toast.LENGTH_SHORT).show();


                        } else {

                            Toast.makeText(c, object.get(index).getString("Name_String") + " will Deleted Eventually", Toast.LENGTH_SHORT).show();

                            indexObject.deleteInBackground();

                        }


                    } else {

                        Log.d("Error", "Error: " + e.getMessage());

                    }

                }

            });

        }

    }


    public void DeleteUserInParse(Context c) {

        if (ParseUser.getCurrentUser() != null) {

            ParseUser pu = ParseUser.getCurrentUser();

            Toast.makeText(c, ParseUser.getCurrentUser().getUsername() + " has been Deleted from Parse", Toast.LENGTH_SHORT).show();

            ParseUser.logOut();

            pu.deleteInBackground();

        }

    }


    public void ParseQuery(Context context, final ArrayList<PersonClass> pc, PersonAdapter pa, ListView lv) {

        if (isOnline(context)) {

            ParseQuery<ParseObject> query = ParseQuery.getQuery("PersonData");
//            ParseQuery<ParseObject> query = new ParseQuery<ParseObject>("PersonData");
            query.whereEqualTo("user", ParseUser.getCurrentUser().getUsername());
            query.findInBackground(new FindCallback<ParseObject>() {
                public void done(final List<ParseObject> objects, ParseException e) {
                    if (e == null) {

                        pc.clear();

                        for (ParseObject object : objects) {

                            pc.add(new PersonClass(object.getString("Name_String"), object.getInt("Age_Number")));

                        }

                    } else {
                        Log.d("Error", "Error: " + e.getMessage());
                    }
                }

            });

            pa.notifyDataSetChanged();

            lv.setAdapter(pa);

        } else {

            Toast.makeText(context, "You are Offline, Please Go Online to Update Contacts", Toast.LENGTH_SHORT).show();

        }

    }


    public void getObjectID(final Context c, final int theIndex) {

        if (isOnline(c)) {

            ParseQuery query = new ParseQuery("PersonData");
            query.whereEqualTo("user", ParseUser.getCurrentUser().getUsername());
            query.findInBackground(new FindCallback<ParseObject>() {
                public void done(final List<ParseObject> object, ParseException e) {
                    if (e == null) {

                        final ParseObject indexObject = object.get(theIndex);

                        indexObject.saveInBackground(new SaveCallback() {
                            @Override
                            public void done(ParseException e) {

                                if (e == null) {

                                    String oid = indexObject.getObjectId();

                                    Log.d("OBJECT", oid);

//                                    intent.putExtra("objectID", oid);
//                                    c.startActivity(intent);

                                } else {
                                    // The save failed.
                                    Log.d("TAG", "Error updating user data: " + e);
                                }

                            }
                        });

                    } else {
                        Log.d("Error", "Error: " + e.getMessage());
                    }
                }

            });

        }

    }


    public void UpdateUserData(final Context c, final int theIndex, final String string, final int theInt) {

        if (ParseUser.getCurrentUser() != null) {

            if (isOnline(c)) {

                final ParseQuery<ParseObject> query = ParseQuery.getQuery("PersonData");
                query.whereEqualTo("user", ParseUser.getCurrentUser().getUsername());
                query.findInBackground(new FindCallback<ParseObject>() {
                    public void done(final List<ParseObject> object, ParseException e) {
                        if (e == null) {

                            final ParseObject indexObject = object.get(theIndex);

                            indexObject.saveInBackground(new SaveCallback() {
                                @Override
                                public void done(ParseException e) {

                                    if (e == null) {

                                        String oid = indexObject.getObjectId();

                                        Log.d("OBJECT", oid);

                                        query.getInBackground(oid, new GetCallback<ParseObject>() {
                                            public void done(ParseObject person, ParseException e) {
                                                if (e == null) {

                                                    person.put("Name_String", string);
                                                    person.put("Age_Number", theInt);

                                                    if (isOnline(c)) {

                                                        person.saveInBackground();

                                                        Toast.makeText(c, string + " has been Updated", Toast.LENGTH_SHORT).show();

                                                    } else {

                                                        person.saveInBackground();

                                                        Toast.makeText(c, string + "will be updated once Internet Connection is Established", Toast.LENGTH_SHORT).show();

                                                    }

                                                }
                                            }

                                        });

                                    } else {

                                        Log.d("TAG", "Error updating user data: " + e);
                                    }

                                }

                            });

                        } else {

                            Log.d("Error", "Error: " + e.getMessage());

                        }

                    }

                });

            }

        }

    }


    //            query.getInBackground(oid, new GetCallback<ParseObject>() {
//                public void done(ParseObject person, ParseException e) {
//                    if (e == null) {
//
//                        person.put("Name_String", string);
//                        person.put("Age_Number", theInt);
//
//                        if (isOnline(c)) {
//
//                            person.saveInBackground();
//
//                            Toast.makeText(c, string + " has been Updated", Toast.LENGTH_SHORT).show();
//
//                        } else {
//
//                            person.saveEventually();
//
//                            Toast.makeText(c, "Person will be updated once Internet Connection is Established", Toast.LENGTH_SHORT).show();
//
//                        }
//
//
//                    }
//                }
//
//            });


    protected boolean isOnline(Context c) {

        ConnectivityManager cm = (ConnectivityManager) c.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo netInfo = cm.getActiveNetworkInfo();

        return netInfo != null && netInfo.isConnectedOrConnecting();

    }


//    protected boolean wifiStatus(Context c) {
//
//        WifiManager wifiManager = (WifiManager) c.getSystemService(Context.WIFI_SERVICE);
//
//        return wifiManager.setWifiEnabled(true);
//
//
//    }

}
