import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../events/order_event.dart';
import '../states/order_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersState.initial()) {
    on<FetchOrders>(_onFetchOrders);
  }

  Future<void> _onFetchOrders(FetchOrders event, Emitter<OrdersState> emit) async {
    emit(state.copyWith(isLoading: true, orders: [], error: null));

    try {
      final String userId = FirebaseAuth.instance.currentUser?.uid ?? "Anonymous";
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      final orders = snapshot.docs.map((doc) => doc.data()).toList();
      emit(state.copyWith(isLoading: false, orders: orders));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
