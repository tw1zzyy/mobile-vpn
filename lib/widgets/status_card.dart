// lib/widgets/status_card.dart
import 'package:flutter/material.dart';
import '../models/connection_stats.dart';
import '../utils/theme.dart';

class StatusCard extends StatelessWidget {
  final ConnectionStats stats;
  final bool isConnected;

  const StatusCard({super.key, required this.stats, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _Row(
              icon: Icons.language,
              label: 'IP',
              value: stats.currentIp,
              color: isConnected ? AppTheme.connectedGreen : Colors.grey,
            ),
            const Divider(height: 20),
            _Row(
              icon: Icons.timer_outlined,
              label: 'Duration',
              value: stats.formattedElapsed,
              color: AppTheme.primaryColor,
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatItem(
                  icon: Icons.arrow_upward,
                  label: '↑ Sent',
                  value: stats.formattedTx,
                  color: Colors.orange,
                ),
                _StatItem(
                  icon: Icons.arrow_downward,
                  label: '↓ Received',
                  value: stats.formattedRx,
                  color: Colors.lightBlue,
                ),
              ],
            ),
            if (isConnected) ...[
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatItem(
                    icon: Icons.upload,
                    label: '↑ Speed',
                    value: stats.formattedUpSpeed,
                    color: Colors.orange,
                  ),
                  _StatItem(
                    icon: Icons.download,
                    label: '↓ Speed',
                    value: stats.formattedDownSpeed,
                    color: Colors.lightBlue,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _Row({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
