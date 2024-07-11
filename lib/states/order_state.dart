import 'package:equatable/equatable.dart';

class OrdersState extends Equatable {
  final bool isLoading;
  final List<Map<String, dynamic>> orders;
  final String? error;

  const OrdersState({
    required this.isLoading,
    required this.orders,
    this.error,
  });

  factory OrdersState.initial() {
    return const OrdersState(
      isLoading: false,
      orders: [],
      error: null,
    );
  }

  OrdersState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? orders,
    String? error,
  }) {
    return OrdersState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [isLoading, orders, error ?? ''];
}
