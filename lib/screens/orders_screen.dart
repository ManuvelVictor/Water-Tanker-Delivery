import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  OrdersScreenState createState() => OrdersScreenState();
}

class OrdersScreenState extends State<OrdersScreen> {
  late Future<List<Map<String, dynamic>>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _fetchOrders();
  }

  Future<List<Map<String, dynamic>>> _fetchOrders() async {
    final snapshot = await FirebaseFirestore.instance.collection('orders').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _ordersFuture = _fetchOrders();
    });
    await _ordersFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Orders',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          } else {
            final orders = snapshot.data!;
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
                      final date = (order['timestamp'] as Timestamp).toDate();
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        title: Text(
                          'Order by: ${order['userName']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tanks: ${order['numberOfTanks']}'),
                            Text('Location: ${order['location']}'),
                            Text(
                              'Order Time: ${date.toLocal()}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        isThreeLine: true,
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
                  final date = (order['timestamp'] as Timestamp).toDate();
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    title: Text(
                      'Order by: ${order['userName']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanks: ${order['numberOfTanks']}'),
                        Text('Location: ${order['location']}'),
                        Text(
                          'Order Time: ${date.toLocal()}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}