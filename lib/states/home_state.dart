class HomeState {
  final int selectedTanks;
  final String currentLocationName;
  final double? latitude;
  final double? longitude;
  final bool isPlacingOrder;
  final bool orderSuccess;
  final String? orderFailure;

  const HomeState({
    required this.selectedTanks,
    required this.currentLocationName,
    this.latitude,
    this.longitude,
    this.isPlacingOrder = false,
    this.orderSuccess = false,
    this.orderFailure,
  });

  HomeState copyWith({
    int? selectedTanks,
    String? currentLocationName,
    double? latitude,
    double? longitude,
    bool? isPlacingOrder,
    bool? orderSuccess,
    String? orderFailure,
  }) {
    return HomeState(
      selectedTanks: selectedTanks ?? this.selectedTanks,
      currentLocationName: currentLocationName ?? this.currentLocationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
      orderSuccess: orderSuccess ?? this.orderSuccess,
      orderFailure: orderFailure ?? this.orderFailure,
    );
  }
}
