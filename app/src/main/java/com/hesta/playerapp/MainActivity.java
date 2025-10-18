package com.hesta.playerapp;

import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.WindowManager;
import android.widget.MediaController;
import android.widget.VideoView;

import androidx.appcompat.app.AppCompatActivity;

import com.hesta.playerapp.databinding.ActivityMainBinding;

public class MainActivity extends AppCompatActivity {

    private static final String TAG = "MainActivity";
    private ActivityMainBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // 화면이 꺼지지 않도록 설정
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

        binding = ActivityMainBinding.inflate(getLayoutInflater());
        if (binding == null) {
            Log.e(TAG, "Binding is null!");
        }
        setContentView(binding.getRoot());

        VideoView videoView = binding.videoView1;
        if (videoView == null) {
            Log.e(TAG, "VideoView is null!");
        }

        // 비디오 파일 URI 설정
        Uri videoUri = Uri.parse("android.resource://" + getPackageName() + "/" + R.raw.video);
        if (videoUri == null) {
            Log.e(TAG, "Video URI is null!");
        }
        Log.d(TAG, "Video URI: " + videoUri.toString());
        videoView.setVideoURI(videoUri);

        // 미디어 컨트롤러 설정 (재생, 일시정지 버튼 등)
        MediaController mediaController = new MediaController(this);
        mediaController.setAnchorView(videoView);
        videoView.setMediaController(mediaController);

        // 비디오 재생 완료 리스너 설정
        videoView.setOnCompletionListener(mp -> {
            // 비디오 재생 완료 시 다시 재생 시작
            videoView.start();
        });

        // 비디오 시작
        videoView.start();
    }
}