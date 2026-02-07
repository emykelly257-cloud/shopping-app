class Item {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime date;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
  });

  factory Item.mock(int i) => Item(
    id: 'item_$i',
    title: 'Item title #$i',
    description: 'This is a short description for item #$i.',
    category: i % 3 == 0 ? 'New' : (i % 3 == 1 ? 'In Progress' : 'Completed'),
    date: DateTime.now().subtract(Duration(days: i * 2)),
  );

  Null get imageUrl => null;
}
