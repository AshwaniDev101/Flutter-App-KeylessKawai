import 'package:flutter/material.dart';

class DeviceGridTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String onCmd;
  final String offCmd;
  final Color surfaceColor;
  final Function(String) onCommandExecuted;

  const DeviceGridTile({
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
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueGrey.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: Text(
                subtitle,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(child: _buildTileButton(label: "OFF", onTap: () => onCommandExecuted(offCmd))),
                const SizedBox(width: 6),
                Expanded(child: _buildTileButton(label: "ON", onTap: () => onCommandExecuted(onCmd))),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTileButton({required String label, required VoidCallback onTap}) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.black87, letterSpacing: 0.5)),
          ),
        ),
      ),
    );
  }
}

class SystemActionGridTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String btnLabel;
  final Color surfaceColor;
  final VoidCallback onTap;

  const SystemActionGridTile({
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
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueGrey.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
              ),
            ),
            const Spacer(),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Center(
                    child: Text(btnLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.black87, letterSpacing: 0.5)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}