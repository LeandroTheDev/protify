class DebugTime {
  /// Returns a "[00:00:00]" for logs
  static String logDate() {
    return "[${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}]";
  }
}
