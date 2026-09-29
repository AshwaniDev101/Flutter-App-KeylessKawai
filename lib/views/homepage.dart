import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import '../constants.dart';
import '../models/log_entry.dart';
import '../websocket_manager.dart';
import '../widgets/terminal_window.dart';
import '../widgets/mobile_action_tiles.dart';
import '../widgets/desktop_action_rows.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool _ledOn = false;
  bool _indoorOn = false;
  bool _outdoorOn = false;
  bool _buzzerOn = false;
  bool _snapToLatest = true;

  final List<LogEntry> _logs = [];
  final ScrollController _scrollController = ScrollController();

  void _executeSecureCommand(String command) async {
    setState(() {
      _logs.add(LogEntry(text: "$command <- [TX]", isTx: true));

      if (command == AppStrings.cmdLedOn) _ledOn = true;
      if (command == AppStrings.cmdLedOff) _ledOn = false;
      if (command == AppStrings.cmdIndoorOn) _indoorOn = true;
      if (command == AppStrings.cmdIndoorOff) _indoorOn = false;
      if (command == AppStrings.cmdOutdoorOn) _outdoorOn = true;
      if (command == AppStrings.cmdOutdoorOff) _outdoorOn = false;
      if (command == AppStrings.cmdBuzzerOn) _buzzerOn = true;
      if (command == AppStrings.cmdBuzzerOff) _buzzerOn = false;
    });

    _triggerScrollToBottom();

    final String? rxData = await WebSocketManager.sendOnce(command);

    if (rxData != null && mounted) {
      setState(() {
        _logs.add(LogEntry(text: "[RX] <- $rxData", isTx: false));
      });
      _triggerScrollToBottom();
    }
  }

  void _executeAllOff() async {
    final commands = [
      AppStrings.cmdLedOff,
      AppStrings.cmdIndoorOff,
      AppStrings.cmdOutdoorOff,
      AppStrings.cmdBuzzerOff,
    ];

    setState(() {
      _logs.add(LogEntry(text: "ALL_DEVICES_OFF <- [TX]", isTx: true));
      _ledOn = false;
      _indoorOn = false;
      _outdoorOn = false;
      _buzzerOn = false;
    });
    _triggerScrollToBottom();

    for (var cmd in commands) {
      final String? rxData = await WebSocketManager.sendOnce(cmd);
      if (rxData != null && mounted) {
        setState(() {
          _logs.add(LogEntry(text: "[RX] <- $rxData", isTx: false));
        });
        _triggerScrollToBottom();
      }
    }
  }

  void _triggerScrollToBottom() {
    if (_snapToLatest) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobileMode = false;

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      isMobileMode = true;
    }

    if (isMobileMode) {
      return _buildMobileLayout();
    } else {
      return _buildDesktopLayout();
    }
  }

  Widget _buildMobileLayout() {
    final backgroundColor = Colors.grey.shade50;
    final surfaceColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'KEYLESS KAWAII',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 2.0, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 220,
                child: TerminalWindow(
                  logs: _logs,
                  scrollController: _scrollController,
                  snapToLatest: _snapToLatest,
                  onSnapToggle: (val) => setState(() => _snapToLatest = val),
                  isDesktop: false,
                ),
              ),
              const SizedBox(height: 36),
              const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Text(
                  "DEVICE DASHBOARD",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: Colors.black45),
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  SystemActionGridTile(
                    title: "Door Unlock",
                    subtitle: "Unlocks main door",
                    icon: Icons.lock_open_rounded,
                    btnLabel: "UNLOCK",
                    surfaceColor: surfaceColor,
                    onTap: () => _executeSecureCommand(AppStrings.cmdLockTrigger),
                  ),
                  SystemActionGridTile(
                    title: "All OFF",
                    subtitle: "Kill all channels",
                    icon: Icons.power_settings_new_rounded,
                    btnLabel: "OFF",
                    surfaceColor: surfaceColor,
                    onTap: _executeAllOff,
                  ),
                  DeviceGridTile(
                    title: "Built-in LED",
                    subtitle: "NodeMCU D4",
                    icon: Icons.developer_board_rounded,
                    onCmd: AppStrings.cmdLedOn,
                    offCmd: AppStrings.cmdLedOff,
                    surfaceColor: surfaceColor,
                    onCommandExecuted: _executeSecureCommand,
                  ),
                  DeviceGridTile(
                    title: "Indoor Light",
                    subtitle: "Living Room D1",
                    icon: Icons.light_rounded,
                    onCmd: AppStrings.cmdIndoorOn,
                    offCmd: AppStrings.cmdIndoorOff,
                    surfaceColor: surfaceColor,
                    onCommandExecuted: _executeSecureCommand,
                  ),
                  DeviceGridTile(
                    title: "Outdoor Light",
                    subtitle: "Backyard D2",
                    icon: Icons.wb_sunny_rounded,
                    onCmd: AppStrings.cmdOutdoorOn,
                    offCmd: AppStrings.cmdOutdoorOff,
                    surfaceColor: surfaceColor,
                    onCommandExecuted: _executeSecureCommand,
                  ),
                  DeviceGridTile(
                    title: "System Buzzer",
                    subtitle: "Alarm Output D7",
                    icon: Icons.volume_up_rounded,
                    onCmd: AppStrings.cmdBuzzerOn,
                    offCmd: AppStrings.cmdBuzzerOff,
                    surfaceColor: surfaceColor,
                    onCommandExecuted: _executeSecureCommand,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    final backgroundColor = Colors.grey.shade50;
    final surfaceColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Container(
            height: 48,
            width: double.infinity,
            color: Colors.white,
            alignment: Alignment.center,
            child: const Text(
              'KEYLESS KAWAII DASHBOARD',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: Colors.black87),
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.black87,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TerminalWindow(
                        logs: _logs,
                        scrollController: _scrollController,
                        snapToLatest: _snapToLatest,
                        onSnapToggle: (val) => setState(() => _snapToLatest = val),
                        isDesktop: true,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    color: backgroundColor,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                      children: [
                        const Text(
                          "SYSTEM ACTIONS",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.0, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        SystemActionRow(
                          title: "Door Unlock",
                          subtitle: "Unlocks main door",
                          icon: Icons.lock_open_rounded,
                          btnLabel: "UNLOCK",
                          surfaceColor: surfaceColor,
                          onTap: () => _executeSecureCommand(AppStrings.cmdLockTrigger),
                        ),
                        const SizedBox(height: 8),
                        SystemActionRow(
                          title: "All OFF",
                          subtitle: "Kill all channels",
                          icon: Icons.power_settings_new_rounded,
                          btnLabel: "OFF",
                          surfaceColor: surfaceColor,
                          onTap: _executeAllOff,
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          "DEVICE CHANNELS",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.0, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        DeviceActionRow(
                          title: "Built-in LED",
                          subtitle: "NodeMCU D4",
                          icon: Icons.developer_board_rounded,
                          onCmd: AppStrings.cmdLedOn,
                          offCmd: AppStrings.cmdLedOff,
                          surfaceColor: surfaceColor,
                          onCommandExecuted: _executeSecureCommand,
                        ),
                        const SizedBox(height: 8),
                        DeviceActionRow(
                          title: "Indoor Light",
                          subtitle: "Living Room D1",
                          icon: Icons.light_rounded,
                          onCmd: AppStrings.cmdIndoorOn,
                          offCmd: AppStrings.cmdIndoorOff,
                          surfaceColor: surfaceColor,
                          onCommandExecuted: _executeSecureCommand,
                        ),
                        const SizedBox(height: 8),
                        DeviceActionRow(
                          title: "Outdoor Light",
                          subtitle: "Backyard D2",
                          icon: Icons.wb_sunny_rounded,
                          onCmd: AppStrings.cmdOutdoorOn,
                          offCmd: AppStrings.cmdOutdoorOff,
                          surfaceColor: surfaceColor,
                          onCommandExecuted: _executeSecureCommand,
                        ),
                        const SizedBox(height: 8),
                        DeviceActionRow(
                          title: "System Buzzer",
                          subtitle: "Alarm Output D7",
                          icon: Icons.volume_up_rounded,
                          onCmd: AppStrings.cmdBuzzerOn,
                          offCmd: AppStrings.cmdBuzzerOff,
                          surfaceColor: surfaceColor,
                          onCommandExecuted: _executeSecureCommand,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}