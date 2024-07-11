import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/order_bloc.dart';
import '../events/order_event.dart';
import '../states/order_state.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  OrdersScreenState createState() => OrdersScreenState();
}

class OrdersScreenState extends State<OrdersScreen> {
  late OrdersBloc _ordersBloc;

  @override
  void initState() {
    super.initState();
    _ordersBloc = OrdersBloc();
    _ordersBloc.add(FetchOrders());
  }

  Future<void> _refreshOrders() async {
    _ordersBloc.add(FetchOrders());
  }

  void _trackOrder() {}

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _ordersBloc,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Orders',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error != null) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state.orders.isEmpty) {
              return const Center(child: Text('No orders found.'));
            } else {
              final orders = state.orders;
              return defaultTargetPlatform == TargetPlatform.iOS
                  ? CustomScrollView(
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: _refreshOrders,
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final order = orders[index];
                              final date =
                                  (order['orderTime'] as Timestamp).toDate();
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 8.0,
                                                horizontal: 16.0),
                                        title: Text(
                                          'Order by: ${order['userName']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Tanks: ${order['numberOfTanks']}'),
                                            Text(
                                                'Location: ${order['locationName']}'),
                                            if (order['status'] == 'assigned')
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: ElevatedButton(
                                                    onPressed: () =>
                                                        _trackOrder(),
                                                    child: const Text(
                                                        'Track My Order', style: TextStyle(color: Colors.white),),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        isThreeLine: true,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: orders.length,
                          ),
                        ),
                      ],
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshOrders,
                      child: ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          final date =
                              (order['orderTime'] as Timestamp).toDate();
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    title: Text(
                                      'Order by: ${order['userName']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Tanks: ${order['numberOfTanks']}'),
                                        Text(
                                            'Location: ${order['locationName']}'),
                                        if (order['status'] == 'assigned')
                                          Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: ElevatedButton(
                                                onPressed: () => _trackOrder(),
                                                child: const Text(
                                                    'Track My Order', style: TextStyle(color: Colors.white),),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    isThreeLine: true,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
            }
          },
        ),
      ),
    );
  }
}
