import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketManager {
  // Hardcoded local IP for the ESP8266/NodeMCU.
  // Important Note: Make sure you bind this IP to the ESP's MAC address in your router settings (Static IP).
  // Otherwise, your router's DHCP will eventually assign it a new IP and break the app.
  static const String _espUrl = "ws://192.168.1.200:81";

  // We use a "connect-fire-receive-close" pattern here instead of keeping a persistent connection open.
  // Why? Microcontrollers like the ESP8266 have very limited RAM. Keeping sockets alive indefinitely
  // can cause memory leaks on the hardware side. This stateless approach is much more stable for simple toggles.
  static Future<String?> sendOnce(String command) async {
    if (kDebugMode) print("WebSocketManager: Fast-firing '$command'...");

    try {
      final uri = Uri.parse(_espUrl);
      final channel = WebSocketChannel.connect(uri);
      final WebSocketSink sink = channel.sink;

      // Fire the payload
      sink.add(command);

      // Wait for the incoming mirror response message packet from the socket stream.
      // Notice the super aggressive 500ms timeout. Since this is a local LAN connection,
      // it should be nearly instant. If it takes longer than half a second, the packet
      // is probably lost anyway, so we bail out early so the UI doesn't hang.
      final String response = await channel.stream.first.timeout(
        const Duration(milliseconds: 500),
        onTimeout: () => "",
      );

      // The Hardware Hack:
      // ESP network stacks can sometimes panic or drop packets if we slam the TCP connection
      // shut the exact millisecond we receive the data. Giving it a tiny 50ms breather
      // lets the hardware flush its buffers cleanly before we hang up.
      await Future.delayed(const Duration(milliseconds: 50));

      // Polite teardown
      sink.close(status.normalClosure);

      return response.isNotEmpty ? response : null;

    } catch (e) {
      // Silent failure on the UI side. If the ESP is offline, we just log it
      // in debug mode rather than throwing red error screens at the user.
      if (kDebugMode) print("WebSocketManager Fire Exception caught: $e");
      return null;
    }
  }
}