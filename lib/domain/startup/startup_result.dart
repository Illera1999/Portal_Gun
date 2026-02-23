class StartupResult {
  const StartupResult({
    required this.destination,
    this.requiresProfileSync = false,
  });

  final String destination;
  final bool requiresProfileSync;
}
