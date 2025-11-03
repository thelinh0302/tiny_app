import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';

/// Widget to display list of users
/// Following Single Responsibility Principle
class UserListWidget extends StatelessWidget {
  final List<User> users;

  const UserListWidget({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                user.name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('${'users.email'.tr()}: ${user.email}'),
                Text('${'users.username'.tr()}: @${user.username}'),
              ],
            ),
            trailing: Text(
              '${'users.id'.tr()}: ${user.id}',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
