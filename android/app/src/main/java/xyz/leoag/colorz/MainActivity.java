package xyz.leoag.colorz;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import xyz.leoag.colorz.channel.ServiceDiscoveryHelper;

public class MainActivity extends FlutterActivity {
  private ServiceDiscoveryHelper helper;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    helper = new ServiceDiscoveryHelper(getApplicationContext());
    helper.initMethodChannel(getFlutterView());
  }
}
