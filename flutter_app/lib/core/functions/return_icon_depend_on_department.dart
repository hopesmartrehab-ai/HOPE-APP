import 'package:flutter/material.dart';

IconData getDepartmentIcon(String name) {
  final text = name.toLowerCase();

  if (text.contains('hr') || text.contains('human')) {
    return Icons.people;
  }

  if (text.contains('finance') || text.contains('account')) {
    return Icons.attach_money;
  }

  if (text.contains('marketing')) {
    return Icons.campaign;
  }

  if (text.contains('sales')) {
    return Icons.shopping_cart;
  }

  if (text.contains('it') ||
      text.contains('tech') ||
      text.contains('information')) {
    return Icons.computer;
  }

  if (text.contains('support')) {
    return Icons.headset_mic;
  }

  if (text.contains('design')) {
    return Icons.design_services;
  }

  if (text.contains('logistics')) {
    return Icons.local_shipping;
  }

  if (text.contains('operations')) {
    return Icons.settings;
  }

  return Icons.groups; // default icon
}
