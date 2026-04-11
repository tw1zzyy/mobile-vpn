// lib/models/connection_stats.dart
class ConnectionStats {
  final int bytesTransmitted;
  final int bytesReceived;
  final Duration elapsed;
  final String currentIp;
  final double uploadSpeed; // байт/сек
  final double downloadSpeed; // байт/сек

  const ConnectionStats({
    this.bytesTransmitted = 0,
    this.bytesReceived = 0,
    this.elapsed = Duration.zero,
    this.currentIp = '—',
    this.uploadSpeed = 0,
    this.downloadSpeed = 0,
  });

  ConnectionStats copyWith({
    int? bytesTransmitted,
    int? bytesReceived,
    Duration? elapsed,
    String? currentIp,
    double? uploadSpeed,
    double? downloadSpeed,
  }) =>
      ConnectionStats(
        bytesTransmitted: bytesTransmitted ?? this.bytesTransmitted,
        bytesReceived: bytesReceived ?? this.bytesReceived,
        elapsed: elapsed ?? this.elapsed,
        currentIp: currentIp ?? this.currentIp,
        uploadSpeed: uploadSpeed ?? this.uploadSpeed,
        downloadSpeed: downloadSpeed ?? this.downloadSpeed,
      );

  String get formattedElapsed {
    final h = elapsed.inHours.toString().padLeft(2, '0');
    final m = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final s = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String get formattedTx => _formatBytes(bytesTransmitted);
  String get formattedRx => _formatBytes(bytesReceived);
  String get formattedUpSpeed => '${_formatBytes(uploadSpeed.toInt())}/s';
  String get formattedDownSpeed => '${_formatBytes(downloadSpeed.toInt())}/s';

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
