import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import '../models/item.dart';
import 'item_details_screen.dart';
import 'item_edit_screen.dart';
import '../widgets/profile_header.dart';
import '../widgets/item_card.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return ChangeNotifierProvider<DashboardProvider>(
      create: (_) => DashboardProvider(token: auth.token)..load(),
      child: const _HomeScaffold(),
    );
  }
}

class _HomeScaffold extends StatelessWidget {
  const _HomeScaffold();

  Widget _buildProfile(Map<String, String> profile) {
    return ProfileHeader(name: profile['name'] ?? 'User', email: profile['email'] ?? '', avatarUrl: profile['avatarUrl']);
  }

  Widget _buildItemTile(BuildContext context, Item item) {
    return ItemCard(
      item: item,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ItemDetailsScreen(itemId: item.id)));
      },
      onLongPress: () async {
        final edited = await Navigator.of(context).push<bool>(
          MaterialPageRoute(builder: (_) => ItemEditScreen(item: item)),
        );
        if (!context.mounted) return;
        if (edited == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated')));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Consumer<DashboardProvider>(builder: (context, dash, _) {
      // Show error view when provider has an error
      if (dash.error != null && !dash.isLoading) {
        return Scaffold(
          appBar: AppBar(title: const Text('Dashboard')),
          body: Center(child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Error: ${dash.error}', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () => dash.load(), child: const Text('Retry'))
            ]),
          )),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            // Theme toggle
            Consumer<ThemeProvider>(builder: (context, theme, _) {
              return IconButton(
                icon: Icon(theme.isDark ? Icons.dark_mode : Icons.light_mode),
                onPressed: () => theme.toggle(),
                tooltip: 'Toggle theme',
              );
            }),
            IconButton(
              onPressed: auth.isLoading ? null : () => auth.logout(),
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final created = await Navigator.of(context).push<bool>(
              MaterialPageRoute(builder: (_) => const ItemEditScreen()),
            );
            if (!context.mounted) return;
            if (created == true) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Created')));
            }
          },
          child: const Icon(Icons.add),
        ),
        body: dash.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => dash.load(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: dash.profile != null ? _buildProfile(dash.profile!) : const SizedBox.shrink(),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = dash.items[index];
                          return _buildItemTile(context, item);
                        },
                        childCount: dash.items.length,
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
