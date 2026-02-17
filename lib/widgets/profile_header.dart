import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? avatarUrl;

  const ProfileHeader({super.key, required this.name, required this.email, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: (avatarUrl ?? '').isNotEmpty
          ? CircleAvatar(backgroundImage: NetworkImage(avatarUrl!))
          : CircleAvatar(child: Text(name.isNotEmpty ? name[0] : 'U')),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(email),
    );
  }
}
