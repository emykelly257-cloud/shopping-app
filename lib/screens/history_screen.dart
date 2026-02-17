import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  final bool showBackArrow;
  
  const HistoryScreen({
    super.key,
    this.showBackArrow = false, 
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'ORD-001',
      'date': '2024-01-15',
      'total': 59.97,
      'items': 3,
      'status': 'Delivered',
    },
    {
      'id': 'ORD-002',
      'date': '2024-01-10',
      'total': 129.99,
      'items': 5,
      'status': 'Processing',
    },
    {
      'id': 'ORD-003',
      'date': '2024-01-05',
      'total': 29.99,
      'items': 1,
      'status': 'Delivered',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.showBackArrow
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        title: const Text('Order History'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _orders.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_outlined,
                      size: 100,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No order history',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order['id'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Chip(
                                label: Text(
                                  order['status'] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: order['status'] == 'Delivered'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Date: ${order['date']}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${order['items']} items',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Text(
                                '\$${order['total']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  _viewOrderDetails(order);
                                },
                                child: const Text('View Details'),
                              ),
                              if (order['status'] == 'Delivered')
                                ElevatedButton(
                                  onPressed: () {
                                    _reorder(order);
                                  },
                                  child: const Text('Reorder'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _viewOrderDetails(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Order ${order['id']}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Order Date'),
                trailing: Text(order['date'] as String),
              ),
              ListTile(
                title: const Text('Status'),
                trailing: Chip(
                  label: Text(
                    order['status'] as String,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: order['status'] == 'Delivered'
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
              ListTile(
                title: const Text('Items'),
                trailing: Text('${order['items']}'),
              ),
              ListTile(
                title: const Text('Total Amount'),
                trailing: Text(
                  '\$${order['total']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _reorder(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reorder initiated for ${order['id']}'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
