import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../providers/dashboard_provider.dart';

class ItemEditScreen extends StatefulWidget {
  final Item? item; 

  const ItemEditScreen({super.key, this.item});

  @override
  State<ItemEditScreen> createState() => _ItemEditScreenState();
}

class _ItemEditScreenState extends State<ItemEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late DateTime _selectedDate;

  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final it = widget.item;
    _titleController = TextEditingController(text: it?.title ?? '');
    _descriptionController = TextEditingController(text: it?.description ?? '');
    _categoryController = TextEditingController(text: it?.category ?? 'New');
    _selectedDate = it?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _selectedDate = d);
  }

  Future<void> _submit() async {
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    setState(() => _submitting = true);
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    try {
      if (widget.item == null) {
        await provider.createItem(
          item: widget.item!,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _categoryController.text.trim(),
          date: _selectedDate,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item created')));
          Navigator.of(context).pop(true);
        }
      } else {
        final updated = Item(
          id: widget.item!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _categoryController.text.trim(),
          date: _selectedDate,
        );
        await provider.updateItem(updated);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item updated')));
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.item != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Item' : 'Create Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 4,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Description is required';
                    if (v.trim().length < 10) return 'Description should be at least 10 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category / Status'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Category is required' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: Text('Date: ${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}')),
                    TextButton(onPressed: _pickDate, child: const Text('Pick Date')),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(isEditing ? 'Save changes' : 'Create item'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
