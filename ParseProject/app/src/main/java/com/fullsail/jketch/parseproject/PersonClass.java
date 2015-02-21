package com.fullsail.jketch.parseproject;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by jketch on 2/19/15.
 */
public class PersonClass implements Parcelable {

    String name;
    int anInt;
    int theIndex;

    public  PersonClass (String theName, int theInt) {

        name = theName;
        anInt = theInt;

    }

    public String enteredName() {

        return name;

    }

    public int enteredAge() {

        return anInt;

    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {

        dest.writeString(name);
        dest.writeInt(anInt);
        dest.writeInt(theIndex);

    }
}
