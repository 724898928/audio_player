package com.lee;

import android.media.MediaPlayer;
import android.media.PlaybackParams;
import android.os.Build;
import android.os.Handler;
import android.os.HandlerThread;
import android.util.Log;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class Player {
    private final String TAG = Player.class.getSimpleName();

    // 单例
    private static final Player INSTANCE = new Player();

    public static Player getInstance() {
        return INSTANCE;
    }

    // 后台线程 & Handler，用于串行执行所有命令
    private final HandlerThread thread;
    private final Handler handler;

    // 媒体播放器
    private final MediaPlayer mediaPlayer;

    // 播放列表及状态
    private final List<String> playlist = new ArrayList<>();
    private int currentIndex = 0;
    private PlayMode playMode = PlayMode.NORMAL;
    private boolean isPlaying = false;
    private float playSpeed = 1.0f;
    private float volume = 1.0f;

    private Player() {
        thread = new HandlerThread("PlayerThread");
        thread.start();
        handler = new Handler(thread.getLooper());

        mediaPlayer = new MediaPlayer();
        // 播放完毕自动切换逻辑
        mediaPlayer.setOnCompletionListener(mp -> handler.post(this::onTrackComplete));
    }

    // 设置播放列表
    public void setPlaylist(List<String> list) {
        Log.i(TAG, "setPlaylist: ");
        handler.post(() -> {
            playlist.clear();
            playlist.addAll(list);
            currentIndex = 0;
        });
    }

    // 播放指定下标
    public void play(int index) {
        handler.post(() -> {
            if (index >= 0 && index < playlist.size()) {
                currentIndex = index;
                playTrack(playlist.get(currentIndex));
            }
        });
    }

    // 暂停
    public void pause() {
        handler.post(() -> {
            if (mediaPlayer.isPlaying()) {
                mediaPlayer.pause();
                isPlaying = false;
            }
        });
    }

    // 恢复
    public void resume() {
        handler.post(() -> {
            if (!mediaPlayer.isPlaying()) {
                mediaPlayer.start();
                isPlaying = true;
            }
        });
    }

    // 停止并释放
    public void stop() {
        handler.post(() -> {
            mediaPlayer.stop();
            mediaPlayer.reset();
            isPlaying = false;
        });
    }

    // 下一曲
    public void next() {
        handler.post(() -> {
            advanceIndex(true);
            playTrack(playlist.get(currentIndex));
        });
    }

    // 上一曲
    public void previous() {
        handler.post(() -> {
            advanceIndex(false);
            playTrack(playlist.get(currentIndex));
        });
    }

    // 跳转（秒）
    public void seek(final int seconds) {
        handler.post(() -> {
            if (mediaPlayer.isPlaying() || isPlaying) {
                mediaPlayer.seekTo(seconds * 1000);
            }
        });
    }

    // 设置播放速度（API ≥ 23）
    public void setSpeed(final float speed) {
        handler.post(() -> {
            playSpeed = speed;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && mediaPlayer.isPlaying()) {
                PlaybackParams params = mediaPlayer.getPlaybackParams();
                params.setSpeed(playSpeed);
                mediaPlayer.setPlaybackParams(params);
            }
        });
    }

    // 设置音量（左、右一致）
    public void setVolume(final float vol) {
        handler.post(() -> {
            volume = vol;
            mediaPlayer.setVolume(volume, volume);
        });
    }

    // 设置播放模式
    public void setPlayMode(PlayMode mode) {
        handler.post(() -> playMode = mode);
    }

    // 是否正在播放
    public boolean isPlaying() {
        return isPlaying;
    }

    // —— 私有方法 —— //

    // 真正执行播放的逻辑
    private void playTrack(String path) {
        try {
            mediaPlayer.reset();
            Log.i(TAG, "playTrack: path => "+path);
            mediaPlayer.setDataSource(path);
            mediaPlayer.prepare();  // 同步准备，必要时可用 prepareAsync
            mediaPlayer.start();
            isPlaying = true;
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // 播放完成回调，处理自动播放下一首/循环等
    private void onTrackComplete() {
        switch (playMode) {
            case NORMAL:
                if (currentIndex < playlist.size() - 1) {
                    currentIndex++;
                    playTrack(playlist.get(currentIndex));
                }
                break;
            case LOOP:
                currentIndex = (currentIndex + 1) % playlist.size();
                playTrack(playlist.get(currentIndex));
                break;
            case SINGLE:
                playTrack(playlist.get(currentIndex));
                break;
            case RANDOM:
                currentIndex = new Random().nextInt(playlist.size());
                playTrack(playlist.get(currentIndex));
                break;
        }
    }

    // 根据模式前进或后退索引
    private void advanceIndex(boolean forward) {
        int size = playlist.size();
        if (size == 0) return;
        switch (playMode) {
            case NORMAL:
            case LOOP:
                if (forward) {
                    currentIndex = (currentIndex + 1) % size;
                } else {
                    currentIndex = (currentIndex - 1 + size) % size;
                }
                break;
            case SINGLE:
                // 不变
                break;
            case RANDOM:
                currentIndex = new Random().nextInt(size);
                break;
        }
    }
}
