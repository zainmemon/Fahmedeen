package my.fahmedeen.application.android;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
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


public class SundayBayanaat extends Fragment {

    View rootView;
    public static String url;
    ListView listview;
    final String TAG = "SundayBayanaat";
    ProgressBar progressBar;
    ProgressBar progressBarPlayer;
    ArrayList<ItemModel> item;
    String param;
    public TextView songName, duration;
    private double timeElapsed = 0, finalTime = 0;
    private int forwardTime = 2000, backwardTime = 2000;
    private Handler durationHandler = new Handler();
    private SeekBar seekbar;
    ImageButton buttonPlay;
    ImageButton buttonPause;
    ImageButton buttonff;
    ImageButton buttonrw;
    myAdapter ma;

    private Intent playIntent;


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




        gonePlayer();
        listview.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, final View view, final int position, long id) {

                if (myAdapter.selectedNo == position && ((Fahmedeen)getActivity()).musicSrv.player.isPlaying()) {

                    if (((Fahmedeen)getActivity()).musicSrv.player.isPlaying()) {
                        ((Fahmedeen)getActivity()).musicSrv.player.pause();
                    }
                    ma.setSelectedNo(position);
                    ma.notifyDataSetChanged();
                } else {




                        gonePlayer();
                        ((Fahmedeen)getActivity()).musicSrv.setSong(position);
                        ((Fahmedeen)getActivity()).musicSrv.playSong();
                        ((Fahmedeen)getActivity()).musicSrv.player.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
                            @Override
                            public void onPrepared(MediaPlayer mp) {
                                mp.start();
                                finalTime = mp.getDuration();
                                seekbar.setMax((int) finalTime);
                                seekbar.setClickable(false);
                                visiblePlayer();
                                play();
                                Intent notIntent = new Intent(SundayBayanaat.this.getActivity(), Fahmedeen.class);
                                notIntent.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
                                PendingIntent pendInt = PendingIntent.getActivity(SundayBayanaat.this.getActivity(), 0,
                                        notIntent, PendingIntent.FLAG_UPDATE_CURRENT);

                                Notification.Builder builder = new Notification.Builder(SundayBayanaat.this.getActivity());

                                builder.setContentIntent(pendInt)
                                        .setSmallIcon(R.drawable.play)
                                        .setAutoCancel(true)
                                        .setTicker(item.get(position).getItem())
                                        .setOngoing(true)
                                        .setContentTitle("Fahmedeen - Playing")
                                        .setContentText(item.get(position).getItem());
                                Notification not = builder.build();
                                not.flags = Notification.FLAG_AUTO_CANCEL;

                                NotificationManager notificationManager =
                                        (NotificationManager) getActivity().getSystemService(getActivity().NOTIFICATION_SERVICE);

                                notificationManager.notify(101, not);

                            }
                        });
                        songName.setText(item.get(position).getItem());
                        //mediaPlayer.start();
                        ma.setSelectedNo(position);
                        ma.notifyDataSetChanged();

                }
            }
        });
        progressBar.setVisibility(View.VISIBLE);
        responseHandle();

        return rootView;
    }


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

                    for (int j = 0; j < jsonArray.length(); j++) {
                        jsonObject = jsonArray.getJSONObject(j);
                        item.add(new ItemModel(jsonObject.getString("name"), jsonObject.getString("link")));

                    }
                    ma = new myAdapter(getActivity(), item);
                    listview.setAdapter(ma);
                    ((Fahmedeen)getActivity()).musicSrv.setList(item);
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
        timeElapsed = ((Fahmedeen)getActivity()).musicSrv.player.getCurrentPosition();
        seekbar.setProgress((int) timeElapsed);
        durationHandler.postDelayed(updateSeekBarTime, 100);
    }

    //handler to change seekBarTime
    private Runnable updateSeekBarTime = new Runnable() {
        public void run() {
            //get current position
            timeElapsed = ((Fahmedeen)getActivity()).musicSrv.player.getCurrentPosition();
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
      //  ((Fahmedeen)getActivity()).musicSrv.player.pause();
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
            ((Fahmedeen)getActivity()).musicSrv.player.seekTo((int) timeElapsed);
        }
    }

    // go backwards at backwardTime seconds
    public void rewind() {
        //check if we can go back at backwardTime seconds after song starts
        if ((timeElapsed - backwardTime) > 0) {
            timeElapsed = timeElapsed - backwardTime;
            //seek to the exact second of the track
            ((Fahmedeen)getActivity()).musicSrv.player.seekTo((int) timeElapsed);
        }
    }


    @Override
    public void onDetach() {
     //   ((Fahmedeen)getActivity()).musicSrv.player.release();
        durationHandler.removeCallbacks(updateSeekBarTime);
        super.onDetach();
        //mListener = null;
    }




}
