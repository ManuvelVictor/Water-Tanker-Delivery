import 'package:flutter_bloc/flutter_bloc.dart';

import '../events/navigation_event.dart';
import '../states/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(HomeState()) {
    on<NavigateToHome>((event, emit) => emit(HomeState()));
    on<NavigateToOrders>((event, emit) => emit(OrdersState()));
    on<NavigateToProfile>((event, emit) => emit(ProfileState()));
    on<NavigateToRegister>((event, emit) => emit(RegisterState()));
  }
}
