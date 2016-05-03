package my.fahmedeen.application.android;

import java.util.ArrayList;

import android.app.Service;
import android.content.ContentUris;
import android.content.Intent;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Binder;
import android.os.IBinder;
import android.os.PowerManager;
import android.util.Log;

/*
 * This is demo code to accompany the Mobiletuts+ series:
 * Android SDK: Creating a Music Player
 * 
 * Sue Smith - February 2014
 */

public class MusicService extends Service implements 
MediaPlayer.OnPreparedListener, MediaPlayer.OnErrorListener,
MediaPlayer.OnCompletionListener {

	//media player
	private MediaPlayer player;
	//song list
	//current position
	private int songPosn;
	String url;
	//binder
	private final IBinder musicBind = new MusicBinder();

	public void onCreate(){
		//create the service
		super.onCreate();
		//initialize position
		//create player
		player = new MediaPlayer();
		//initialize
		initMusicPlayer();
	}

	public void initMusicPlayer(){
		//set player properties
		player.setWakeMode(getApplicationContext(), 
				PowerManager.PARTIAL_WAKE_LOCK);
		player.setAudioStreamType(AudioManager.STREAM_MUSIC);
		//set listeners
		player.setOnPreparedListener(this);
		player.setOnCompletionListener(this);
		player.setOnErrorListener(this);
	}

	//pass song list
	public void setList(String theSongs){
		url=theSongs;
	}

	//binder
	public class MusicBinder extends Binder {
		MusicService getService() { 
			return MusicService.this;
		}
	}

	//activity will bind to service
	@Override
	public IBinder onBind(Intent intent) {
		return musicBind;
	}

	//release resources when unbind
	@Override
	public boolean onUnbind(Intent intent){
		player.stop();
		player.release();
		return false;
	}

	//play a song
	public void playSong(){
		//play
		player.reset();
		//set the data source
		try{ 
			player.setDataSource(url);
		}
		catch(Exception e){
			Log.e("MUSIC SERVICE", "Error setting data source", e);
		}
		player.prepareAsync(); 
	}



	@Override
	public void onCompletion(MediaPlayer mp) {
		// TODO Auto-generated method stub
	}

	@Override
	public boolean onError(MediaPlayer mp, int what, int extra) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public void onPrepared(MediaPlayer mp) {
		//start playback
		mp.start();
	}

}
