package com.fullsail.jketch.parseproject;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Fragment;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import com.parse.ParseUser;
import com.parse.ui.ParseLoginBuilder;


public class PersonFragment extends Fragment {

    public static final String PersonString = "PersonFrag";

    ListView lv;

    EditText nameText;
    EditText ageText;

    Button button;
    Button logOut;
    Button refresh;

    ParseFunc pf = new ParseFunc();

    String name;
    int theInt;
    String age;


    ParseQueryClass pqc;
//    static ParseObject selectedPerson;

    private PersonInterface mListener;


    public static PersonFragment newInstance() {

        PersonFragment pf = new PersonFragment();

        return pf;

    }

    public PersonFragment() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View v = inflater.inflate(R.layout.fragment_person, container, false);

        lv = (ListView) v.findViewById(R.id.theListView);

        nameText = (EditText) v.findViewById(R.id.nameText);
        ageText = (EditText) v.findViewById(R.id.ageText);

        button = (Button) v.findViewById(R.id.button);
        refresh = (Button) v.findViewById(R.id.refresh);
        logOut = (Button) v.findViewById(R.id.logout);

        UserStatus(v);

        return v;
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        try {
            mListener = (PersonInterface) activity;
        } catch (ClassCastException e) {
            throw new ClassCastException(activity.toString()
                    + " must implement OnFragmentInteractionListener");
        }
    }


    protected void UserStatus(View v) {

        if (ParseUser.getCurrentUser() == null) {

            ParseLoginBuilder builder = new ParseLoginBuilder(getActivity());
            startActivityForResult(builder.build(), 0);

//            lv.setAdapter(null);

        } else {

            pqc = new ParseQueryClass(getActivity());


            button.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    EntryCheck();

                }
            });

            refresh.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    pqc.loadObjects();

                    lv.setAdapter(pqc);

                }
            });

            logOut.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    Toast.makeText(getActivity(), ParseUser.getCurrentUser().getUsername() + " has Logged Out", Toast.LENGTH_SHORT).show();

                    ParseUser.logOut();

                    if (ParseUser.getCurrentUser() == null) {

                        lv.setAdapter(null);

                    }


                    UserStatus(v);

                }
            });

            lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                   final int index = position;

                    new AlertDialog.Builder(getActivity())
                            .setTitle("Are You Sure")
                            .setMessage("You want to Delete This Entry?")
                            .setPositiveButton("YES", new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {

                                    pf.DeleteUserDataInParse(getActivity(), index);

                                    pqc.loadObjects();

                                }
                            })
                            .setNegativeButton("NO", null)
                            .show();



                }
            });


            lv.setAdapter(pqc);

        }

    }


    protected void EntryCheck() {

        if (nameText.length() > 0 || ageText.length() > 0) {

            name = nameText.getText().toString();

            age = ageText.getText().toString();

            theInt = Integer.parseInt(age);

            pf.saveDataToParse(getActivity(), ParseUser.getCurrentUser().getUsername(), name, theInt);

            nameText.setText("");
            ageText.setText("");

            pqc.loadObjects();

            lv.setAdapter(pqc);

        } else {

            new AlertDialog.Builder(getActivity())
                    .setTitle("Opps...")
                    .setMessage("Need to Enter Name and/or Age to Proceed")
                    .setPositiveButton("OK", null)
                    .show();

        }
    }
}
