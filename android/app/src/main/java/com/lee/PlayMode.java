package com.lee;

// 播放模式
public enum PlayMode {
    NORMAL(0), LOOP(1), SINGLE(2), RANDOM(3);

    private final int id;
    PlayMode(int id) { this.id = id; }
    public int getId() { return id; }
    public static PlayMode fromId(int id) {
        switch (id) {
            case 1: return LOOP;
            case 2: return SINGLE;
            case 3: return RANDOM;
            default: return NORMAL;
        }
    }
}