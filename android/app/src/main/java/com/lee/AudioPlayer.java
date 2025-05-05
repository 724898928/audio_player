package com.lee;

import android.content.Context;
import android.net.Uri;
import android.util.Log;

import androidx.annotation.OptIn;
import androidx.media3.common.MediaItem;
import androidx.media3.common.Player;
import androidx.media3.common.util.UnstableApi;
import androidx.media3.datasource.DefaultDataSource;
import androidx.media3.datasource.okhttp.OkHttpDataSource;
import androidx.media3.exoplayer.ExoPlayer;
import androidx.media3.exoplayer.source.DefaultMediaSourceFactory;
import androidx.media3.session.MediaSession;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

import okhttp3.Call;
import okhttp3.OkHttpClient;

public class AudioPlayer {
    private final String TAG = AudioPlayer.class.getSimpleName();
    private final Context context;
    private ExoPlayer player;
    private MediaSession mediaSession;
    // 播放列表及状态
    private final ArrayList<String> playlist = new ArrayList<>();
    private int currentIndex = -1;
    private PlayMode playMode = PlayMode.LOOP;
    private boolean isPlaying = false;
    private boolean isPressBut = false;
    private float playSpeed = 1.0f;
    private float volume = 1.0f;

    public AudioPlayer(Context context) {
        this.context = context;
        initializePlayer();
    }

    @OptIn(markerClass = UnstableApi.class)
    private void initializePlayer() {
        // 1. 创建 OkHttpClient（可添加拦截器、日志等）
        OkHttpClient okHttpClient = new OkHttpClient.Builder().build();
// 2. 用 OkHttpClient 构建 OkHttpDataSource.Factory
        OkHttpDataSource.Factory okFactory = new OkHttpDataSource.Factory((Call.Factory) okHttpClient);
// 3. 包装为 DefaultDataSource.Factory，以便内部混合缓存和其他协议
        DefaultDataSource.Factory dataSourceFactory =
                new DefaultDataSource.Factory(context, okFactory);
// 4. 构建 ExoPlayer 并使用自定义 Factory
        player = new ExoPlayer.Builder(context)
                .setMediaSourceFactory(new DefaultMediaSourceFactory(dataSourceFactory))
                .setHandleAudioBecomingNoisy(true) // 耳机断开自动暂停
                .build();

        // 初始化 MediaSession（用于通知控制）
        mediaSession = new MediaSession.Builder(context, player)
                .setCallback(new MediaSession.Callback() { /* 处理媒体按钮事件 */
                })
                .build();

        // 监听播放状态
        player.addListener(new Player.Listener() {
            @Override
            public void onPlaybackStateChanged(int state) {
                switch (state) {
                    case Player.STATE_READY:
                        Log.i(TAG, "onPlaybackStateChanged  Player.STATE_READY: currentIndex = " + currentIndex + " isPressBut = "+isPressBut);
                        updateNotification();
                        break;
                   case Player.STATE_ENDED:
                        Log.i(TAG, "onPlaybackStateChanged  Player.STATE_ENDED: currentIndex = " + currentIndex + " isPressBut = "+isPressBut);
                        if (!isPressBut){
                            nextStep();
                        }
                       isPressBut = false;
                        break;
                }
            }
        });
    }

// —— 私有方法 —— //

    // 真正执行播放的逻辑
    private void playTrack(String audioUrl) {
        Log.i(TAG, "playTrack: audioUrl=>" + audioUrl);
        if (null != player){
            try {
                MediaItem mediaItem = MediaItem.fromUri(Uri.parse(audioUrl));
                player.setMediaItem(mediaItem);
                player.prepare();
                player.seekTo(0); // 强制重置初始位置
                player.play();
                isPlaying = true;
            }catch (Exception e){
                Log.e(TAG, "playTrack: Exception e=>" + e);
            }
        }
    }

    // 根据模式前进或后退索引
    private void advanceIndex(boolean forward) {
        int size = playlist.size();
        if (size == 0) return;
        switch (playMode) {
            case NORMAL:
                break;
            case LOOP:
                if (forward) {
                    currentIndex = (currentIndex + 1) % size;
                } else {
                    currentIndex = (currentIndex - 1 + size) % size;
                }
                Log.i(TAG, "advanceIndex=> "+forward+" currentIndex: "+currentIndex + " playlist.size() =>"+size);
                break;
            case SINGLE:
                // 不变
                break;
            case RANDOM:
                currentIndex = new Random().nextInt(size);
                break;
        }
    }

    // 控制播放
    public void play(int index) {
        Log.i(TAG, "AudioPlayer play index: "+index+" playlist.size():"+playlist.size());
        if (player != null) {
            if (index < playlist.size()) {
                isPressBut = true;
                currentIndex = index < 0 ? 0 : index;
                playTrack(playlist.get(currentIndex));
            }
        }
    }

    public void pause() {
        if (player != null) {
            player.pause();
            isPressBut = true;
            //   abandonAudioFocus(); // 释放音频焦点
            //  updateNotification();
            isPlaying = false;
        }
    }

    public void stop() {
        if (player != null) {
            isPressBut = true;
            player.stop();
            //  abandonAudioFocus();
            //  updateNotification();
            isPlaying = false;
        }
    }

    // 释放资源
    public void releasePlayer() {
        Log.i(TAG, "AudioPlayer releasePlayer: ");
        if (player != null) {
            //isPressBut = true;
            player.release();
            player = null;
            mediaSession.release();
        }
    }

    // 音频焦点管理
    private void requestAudioFocus() {
        // 使用 AudioManager 请求焦点（需实现）
    }

    private void abandonAudioFocus() {
        // 释放音频焦点（需实现）
    }

    // 更新通知栏（需结合 NotificationManager 实现）
    private void updateNotification() {
        // 创建 MediaStyle 通知
    }

    public void addSongs(ArrayList<String> list){
        if(null != playlist){
            playlist.addAll(list);
        }
    }
    public void delSong(int idx){
        if(null != playlist){
            playlist.remove(idx);
        }
    }
    public void setPlaylist(ArrayList<String> list) {
        if (!list.isEmpty() && null != playlist){
            playlist.clear();
            playlist.addAll(list);
            Log.i(TAG, "setPlaylist: playlist => "+ Arrays.toString(playlist.toArray()));
            currentIndex = 0;
        }
    }
    public void clearPlaylist() {
        if (null != playlist){
            playlist.clear();
            currentIndex = -1;
        }
    }


    public void next() {
        Log.i(TAG, "next begin currentIndex" + currentIndex);
        nextStep();
        Log.i(TAG, "next end currentIndex" + currentIndex);
    }

    private void nextStep(){
        player.seekTo(0); // 强制重置初始位置
        advanceIndex(true);
        playTrack(playlist.get(currentIndex));
    }

    public void previous() {
        isPressBut = true;
        player.seekTo(0); // 强制重置初始位置
        advanceIndex(false);
        playTrack(playlist.get(currentIndex));
    }

    public void setPlayMode(PlayMode playMode) {
       this.playMode = playMode;
    }

    public void resume() {
        isPressBut = true;
        player.play();
    }

    public void seek(long pos) {
        player.seekTo(pos);
    }

    // 设置音量（左、右一致）
    public void setVolume(final float vol) {
        volume = vol;
        player.setVolume(volume);
    }

    // 设置播放速度
    public void setSpeed(float pos) {
        player.setPlaybackSpeed(pos);
    }
    public long totalLen() {
      return player.getDuration();
    }
    public String getCurrentInfo() {
        String info = null;
        if (null != player){
           // long pos = player.getCurrentPosition() + 1000;
            long pos = player.getCurrentPosition();
            long len = player.getDuration() ;
            if (-1 == currentIndex){
                pos = len = 0;
            } else if (pos > len && len > 0){
               // pos = len = 0;
                nextStep();
            }
            info = "{\"pos\":" + pos +
                    ",\"len\":" + len +
                    ",\"playing\":" + isPlaying +
                    ",\"speed\":" + playSpeed +
                    ",\"mode\":" + playMode.getId() +
                    ",\"idx\":" + currentIndex +
                    "}";
            Log.i(TAG, "getCurrentInfo pos => "+ player.getCurrentPosition()+" info =>  " + info);

        }
           return info;
    }


    public boolean isPlaying() {
        return isPlaying;
    }



}