class AlertItem {
  final DateTime time;
  final String message;
  final bool critical;
  AlertItem({required this.time, required this.message, this.critical = false});
}
