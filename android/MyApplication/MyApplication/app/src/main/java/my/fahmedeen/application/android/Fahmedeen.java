package my.fahmedeen.application.android;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.IBinder;
import android.support.design.widget.NavigationView;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;

public class Fahmedeen extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    public MusicService musicSrv;
    public Intent playIntent;
    public boolean musicBound = false;
    //activity and playback pause flags



    //connect to the service
    private ServiceConnection musicConnection = new ServiceConnection() {

        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            MusicService.MusicBinder binder = (MusicService.MusicBinder) service;
            //get service
            musicSrv = binder.getService();
            //pass list
           // musicSrv.setList(null);
            musicBound = true;
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            musicBound = false;
        }
    };



    @Override
    protected void onStart() {
        super.onStart();
        if (playIntent == null) {
            playIntent = new Intent(this, MusicService.class);
            bindService(playIntent, musicConnection, Context.BIND_AUTO_CREATE);
            startService(playIntent);
        }
    }


    @Override
    protected void onDestroy() {
        if (playIntent != null) {
            stopService(playIntent);
        }
        musicSrv = null;
        super.onDestroy();
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_fahmedeen);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);




        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();

        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);
        //navigationView.performClick();

        //drawer.openDrawer(GravityCompat.START);

        Fragment fragment = null;
        Bundle bundleParams = new Bundle();
        fragment = new SundayBayanaat();
        fragment.setArguments(bundleParams);
        bundleParams.putString("param", "sunday");
        bundleParams.putString("title", "Sunday Bayanaat");
        FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
        ft.replace(R.id.frame_container, fragment);
        ft.commit();


    }

    @Override
    public void onBackPressed() {
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }



    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.fahmedeen, menu);
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
            Intent intent = new Intent(Intent.ACTION_MAIN);
            intent.addCategory(Intent.CATEGORY_HOME);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        // Handle navigation view item clicks here.
        int id = item.getItemId();
        Fragment fragment = null;
        Bundle bundleParams = new Bundle();
        fragment = new SundayBayanaat();
        fragment.setArguments(bundleParams);

        if (id == R.id.sunday_bayanaat) {
            // Handle the camera action

            bundleParams.putString("param", "sunday");
            bundleParams.putString("title", "Sunday Bayanaat");

        } else if (id == R.id.bayanaat) {

            bundleParams.putString("param", "bayans");
            bundleParams.putString("title", "Bayanaat");

        } else if (id == R.id.morning_dars) {
            bundleParams.putString("param", "morning");
            bundleParams.putString("title", "Morning Dars");


        } else if (id == R.id.mufti_taqi) {
            bundleParams.putString("param", "tusmani");
            bundleParams.putString("title", "Mufti Taqi Usmani");

        }  else if (id == R.id.ramzan_bayanaat) {
            bundleParams.putString("param", "ramdhan");
            bundleParams.putString("title", "Ramzan Bayanaat");

        } else if (id == R.id.tafseer) {
            bundleParams.putString("param", "tafseer");
            bundleParams.putString("title", "Tafseer");

        }else if (id == R.id.others) {
            bundleParams.putString("param", "others");
            bundleParams.putString("title", "Others");

        }
        FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
        ft.replace(R.id.frame_container, fragment);
        ft.commit();
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

}
