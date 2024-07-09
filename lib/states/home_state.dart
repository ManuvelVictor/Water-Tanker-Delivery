class HomeState {
  final int selectedTanks;
  final String currentLocationName;
  final double? latitude;
  final double? longitude;

  const HomeState({
    required this.selectedTanks,
    required this.currentLocationName,
    this.latitude,
    this.longitude,
  });

  HomeState copyWith({
    int? selectedTanks,
    String? currentLocationName,
    double? latitude,
    double? longitude,
  }) {
    return HomeState(
      selectedTanks: selectedTanks ?? this.selectedTanks,
      currentLocationName: currentLocationName ?? this.currentLocationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
