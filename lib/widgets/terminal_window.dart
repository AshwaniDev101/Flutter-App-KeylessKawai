import 'package:flutter/material.dart';
import '../models/log_entry.dart';

class TerminalWindow extends StatelessWidget {
  final List<LogEntry> logs;
  final ScrollController scrollController;
  final bool snapToLatest;
  final ValueChanged<bool> onSnapToggle;
  final bool isDesktop;

  const TerminalWindow({
    super.key,
    required this.logs,
    required this.scrollController,
    required this.snapToLatest,
    required this.onSnapToggle,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(isDesktop ? 6 : 12)
      ),
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          logs.isEmpty
              ? const Text(
            "Terminal ready...",
            style: TextStyle(color: Colors.grey, fontFamily: 'monospace', fontSize: 12),
          )
              : ListView.builder(
            controller: scrollController,
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return Align(
                alignment: log.isTx ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    log.text,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: isDesktop ? 11 : 8,
                      color: log.isTx ? Colors.lightBlueAccent : Colors.lightGreenAccent,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              width: 28,
              height: 28,
              child: FloatingActionButton(
                onPressed: () => onSnapToggle(!snapToLatest),
                elevation: 0,
                backgroundColor: snapToLatest ? Colors.lightGreenAccent.withOpacity(0.8) : Colors.grey.shade800,
                mini: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                child: Icon(
                  Icons.mouse_outlined,
                  size: 16,
                  color: snapToLatest ? Colors.black87 : Colors.white70,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}