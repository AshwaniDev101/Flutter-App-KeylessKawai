import 'package:flutter/material.dart';

class DeviceActionRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String onCmd;
  final String offCmd;
  final Color surfaceColor;
  final Function(String) onCommandExecuted;

  const DeviceActionRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onCmd,
    required this.offCmd,
    required this.surfaceColor,
    required this.onCommandExecuted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              _buildNativeButton(label: "OFF", width: 56, onTap: () => onCommandExecuted(offCmd)),
              const SizedBox(width: 6),
              _buildNativeButton(label: "ON", width: 56, onTap: () => onCommandExecuted(onCmd)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNativeButton({required String label, required double width, required VoidCallback onTap}) {
    return Container(
      height: 32,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          hoverColor: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(4),
          child: Center(
            child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87)),
          ),
        ),
      ),
    );
  }
}

class SystemActionRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String btnLabel;
  final Color surfaceColor;
  final VoidCallback onTap;

  const SystemActionRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.btnLabel,
    required this.surfaceColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                const SizedBox(height: 2),
                Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 32,
            width: 118,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                hoverColor: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
                child: Center(
                  child: Text(btnLabel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}