package my.fahmedeen.application.android;

import android.content.ComponentName;
import android.content.Intent;
import android.content.ServiceConnection;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.DataAsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.concurrent.TimeUnit;


//import com.google.android.gms.maps.GoogleMap;
//import com.google.android.gms.maps.MapFragment;

public class SundayBayanaat extends Fragment {

    View rootView;
    ListView listview;
    final String TAG = "SundayBayanaat";
    ProgressBar progressBar;
    ProgressBar progressBarPlayer;
    ArrayList<ItemModel> item;
    String[] link;
    String param;
    MediaPlayer mediaPlayer;
    // TODO: Rename and change types of parameters
    //private String mParam1;
    //private String mParam2;
    public TextView songName, duration;
    private double timeElapsed = 0, finalTime = 0;
    private int forwardTime = 2000, backwardTime = 2000;
    private Handler durationHandler = new Handler();
    private SeekBar seekbar;
    ImageButton buttonPlay;
    ImageButton buttonPause;
    ImageButton buttonff;
    ImageButton buttonrw;
    private MusicService musicSrv;
    private Intent playIntent;
    private boolean musicBound = false;

    public SundayBayanaat() {

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        final Bundle bundle = this.getArguments();
        param = bundle.getString("param");
        getActivity().setTitle(bundle.getString("title"));
        rootView = inflater.inflate(R.layout.fragment_item_list, container, false);
        listview = (ListView) rootView.findViewById(R.id.listviewItem);

        progressBar = (ProgressBar) rootView.findViewById(R.id.progressBar);
        progressBarPlayer = (ProgressBar) rootView.findViewById(R.id.progressBar2);

        buttonff = (ImageButton) rootView.findViewById(R.id.media_ff);
        buttonPause = (ImageButton) rootView.findViewById(R.id.media_pause);
        buttonrw = (ImageButton) rootView.findViewById(R.id.media_rew);
        buttonPlay = (ImageButton) rootView.findViewById(R.id.media_play);

        buttonff.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                forward();
            }
        });
        buttonPause.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pause();
            }
        });
        buttonrw.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                rewind();
            }
        });
        buttonPlay.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                play();
            }
        });

        songName = (TextView) rootView.findViewById(R.id.songName);
        //mediaPlayer = MediaPlayer.create(this, R.raw.sample_song);
        duration = (TextView) rootView.findViewById(R.id.songDuration);
        seekbar = (SeekBar) rootView.findViewById(R.id.seekBar);

        mediaPlayer = new MediaPlayer();
        gonePlayer();
        listview.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {


                //try {
                    /*Bundle bundle1 = new Bundle();
                    bundle1.putString("link",link[position]);
                    bundle1.putString("item",item[position]);
                    Fragment fragment = null;
                    //Bundle bundleParams = new Bundle();
                    fragment = new MediaPlayerPlay();
                    fragment.setArguments(bundle1);
                    FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
                    ft.replace(R.id.frame_container, fragment);
                    ft.commit();*/

                try {


                    MySingletonClass mySingletonClass = MySingletonClass.getInstance();
                    //Toast.makeText(getContext(), link[position], Toast.LENGTH_LONG).show();
                    String url = mySingletonClass.getBaseURL() + link[position]; // your URL here
                    mediaPlayer.reset();
                   // progressBarPlayer.setVisibility(View.VISIBLE);
                    gonePlayer();
                    mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
                    mediaPlayer.setDataSource(url);

                    mediaPlayer.prepareAsync();
                    mediaPlayer.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
                        @Override
                        public void onPrepared(MediaPlayer mp) {
                            finalTime = mediaPlayer.getDuration();
                            seekbar.setMax((int) finalTime);
                            seekbar.setClickable(false);
                            visiblePlayer();
                           // progressBarPlayer.setVisibility(View.GONE);

                            play();
                        }
                    });


                    songName.setText(item.get(position).getItem());

                    //mediaPlayer.start();


                    if (myAdapter.selectedNo != -1) {
                        item.get(myAdapter.selectedNo).setSelected(false);
                    }
                    myAdapter.selectedNo = position;
                    listview.invalidate();

                } catch (IOException e) {
                    e.printStackTrace();
                }

                    /*MySingletonClass mySingletonClass = MySingletonClass.getInstance();
                    Toast.makeText(getContext(), link[position], Toast.LENGTH_LONG).show();
                    String url = mySingletonClass.getBaseURL() + link[position]; // your URL here
                    mediaPlayer = new MediaPlayer();
                    mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
                    mediaPlayer.setDataSource(url);

                    mediaPlayer.prepareAsync(); // might take long! (for buffering, etc)
                    mediaPlayer.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
                        @Override
                        public void onPrepared(MediaPlayer mp) {
                            mp.start();
                        }
                    });
                    //mediaPlayer.start();

                } catch (IOException e) {
                    e.printStackTrace();
                }*/
            }
        });
        progressBar.setVisibility(View.VISIBLE);
        responseHandle();

        return rootView;
    }

    private ServiceConnection musicConnection = new ServiceConnection() {

        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            MusicService.MusicBinder binder = (MusicService.MusicBinder) service;
            //get service
            musicSrv = binder.getService();
            //pass list
            // musicSrv.setList(item);
            musicBound = true;
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            musicBound = false;
        }
    };

    public void responseHandle() {

        final MySingletonClass mySingletonClass = MySingletonClass.getInstance();
        //RequestHandler requestHandler = new RequestHandler(MySingletonClass.getLoginURL());
        RequestParams params = new RequestParams();
        params.add("type", param);

        AsyncHttpClient client = new AsyncHttpClient();
        //Log.e("BookingHistoryURL", mySingletonClass.getBaseURL() + mySingletonClass.getCustomerBookingHistoryURL());
        //Log.e("BookingHistoryParams",params.toString());
        client.get(mySingletonClass.getBaseURL() + mySingletonClass.getBaseWebserviceURL(), params, new DataAsyncHttpResponseHandler() {
            @Override
            public void onSuccess(int i, org.apache.http.Header[] headers, byte[] bytes) {
                try {
                    String decoded = new String(bytes, "UTF-8");
                    JSONArray jsonArray = new JSONArray(decoded);
                    JSONObject jsonObject = new JSONObject();
                    item = new ArrayList<ItemModel>(jsonArray.length());
                    link = new String[jsonArray.length()];
                    for (int j = 0; j < jsonArray.length(); j++) {
                        jsonObject = jsonArray.getJSONObject(j);
                        item.add(new ItemModel(jsonObject.getString("name")));
                        link[j] = jsonObject.getString("link");
                    }
                    listview.setAdapter(new myAdapter(getActivity(), item));

                    Log.d(TAG, jsonArray.toString());
                    progressBar.setVisibility(View.INVISIBLE);

                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                    Toast.makeText(getContext(), "Data couldn't be Fetched", Toast.LENGTH_LONG).show();
                    progressBar.setVisibility(View.INVISIBLE);

                } catch (JSONException e) {
                    e.printStackTrace();
                    Toast.makeText(getContext(), "Data couldn't be Fetched", Toast.LENGTH_LONG).show();
                    progressBar.setVisibility(View.INVISIBLE);

                } catch (NullPointerException e) {
                    e.printStackTrace();
                    Toast.makeText(getContext(), "No Data Received", Toast.LENGTH_LONG).show();
                    progressBar.setVisibility(View.INVISIBLE);

                }

            }

            @Override
            public void onFailure(int i, org.apache.http.Header[] headers, byte[] bytes, Throwable throwable) {
                try {
                    //Log.d(TAG, bytes.toString());
                    if (bytes != null) {
                        String decoded = new String(bytes, "UTF-8");
                        Toast.makeText(getContext(), decoded, Toast.LENGTH_LONG).show();
                    }
                    progressBar.setVisibility(View.INVISIBLE);

                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                    Toast.makeText(getContext(), "Data couldn't be Fetched", Toast.LENGTH_LONG).show();
                    progressBar.setVisibility(View.INVISIBLE);

                } catch (NullPointerException e) {
                    e.printStackTrace();
                    Toast.makeText(getContext(), "No Internet Connection", Toast.LENGTH_LONG).show();
                    progressBar.setVisibility(View.INVISIBLE);

                }
            }
        });

    }


    // play mp3 song
    public void play() {
        buttonPause.setVisibility(View.VISIBLE);
        buttonPlay.setVisibility(View.GONE);
        mediaPlayer.start();
        timeElapsed = mediaPlayer.getCurrentPosition();
        seekbar.setProgress((int) timeElapsed);
        durationHandler.postDelayed(updateSeekBarTime, 100);
    }

    //handler to change seekBarTime
    private Runnable updateSeekBarTime = new Runnable() {
        public void run() {
            //get current position
            timeElapsed = mediaPlayer.getCurrentPosition();
            //set seekbar progress
            seekbar.setProgress((int) timeElapsed);
            //set time remaing
            double timeRemaining = finalTime - timeElapsed;
            duration.setText(String.format("%d:%d:%d", TimeUnit.MILLISECONDS.toHours((long) timeRemaining), TimeUnit.MILLISECONDS.toMinutes((long) timeRemaining), TimeUnit.MILLISECONDS.toSeconds((long) timeRemaining) - TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes((long) timeRemaining))));

            //repeat yourself that again in 100 miliseconds
            durationHandler.postDelayed(this, 100);
        }
    };

    // pause mp3 song
    public void pause() {
        buttonPause.setVisibility(View.GONE);
        buttonPlay.setVisibility(View.VISIBLE);
        mediaPlayer.pause();
    }

    public void visiblePlayer() {
        buttonff.setEnabled(true);
        buttonrw.setEnabled(true);
        buttonPause.setEnabled(true);
        buttonPlay.setEnabled(true);
        duration.setEnabled(true);
        seekbar.setEnabled(true);
    }

    public void invisiblePlayer() {
        buttonff.setVisibility(View.INVISIBLE);
        buttonrw.setVisibility(View.INVISIBLE);
        buttonPause.setVisibility(View.INVISIBLE);
        buttonPlay.setVisibility(View.INVISIBLE);
        duration.setVisibility(View.INVISIBLE);
        seekbar.setVisibility(View.INVISIBLE);
    }

    public void gonePlayer() {
        buttonff.setEnabled(false);
        buttonrw.setEnabled(false);
        buttonPause.setEnabled(false);
        buttonPlay.setEnabled(false);
        duration.setEnabled(false);
        seekbar.setEnabled(false);
    }

    // go forward at forwardTime seconds
    public void forward() {
        //check if we can go forward at forwardTime seconds before song endes
        if ((timeElapsed + forwardTime) <= finalTime) {
            timeElapsed = timeElapsed + forwardTime;

            //seek to the exact second of the track
            mediaPlayer.seekTo((int) timeElapsed);
        }
    }

    // go backwards at backwardTime seconds
    public void rewind() {
        //check if we can go back at backwardTime seconds after song starts
        if ((timeElapsed - backwardTime) > 0) {
            timeElapsed = timeElapsed - backwardTime;

            //seek to the exact second of the track
            mediaPlayer.seekTo((int) timeElapsed);
        }
    }


    @Override
    public void onDetach() {
        mediaPlayer.release();
        durationHandler.removeCallbacks(updateSeekBarTime);
        super.onDetach();
        //mListener = null;
    }


}
