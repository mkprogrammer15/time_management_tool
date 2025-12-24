import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double radius;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const CustomAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.radius = 20,
    this.backgroundColor,
    this.onTap,
  });

  String _initialsFromName(String? value) {
    if (value == null || value.trim().isEmpty) return '';
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final initials = _initialsFromName(name);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: CircleAvatar(
        radius: radius,
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
        backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
            ? NetworkImage(imageUrl!)
            : null,
        child: imageUrl == null || imageUrl!.isEmpty
            ? Text(
                initials,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: radius * 0.8,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              )
            : null,
      ),
    );
  }
}
