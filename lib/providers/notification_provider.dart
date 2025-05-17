import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/notification.dart';

class NotificationProvider extends ChangeNotifier {
  List<BudgetNotification> _notifications = [];
  bool _isEnabled = true;

  List<BudgetNotification> get notifications => _notifications;
  bool get isEnabled => _isEnabled;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationProvider() {
    _loadNotifications();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isEnabled = prefs.getBool('notifications_enabled') ?? true;
    notifyListeners();
  }

  Future<void> setEnabled(bool value) async {
    _isEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    notifyListeners();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getStringList('notifications') ?? [];
    _notifications = notificationsJson
        .map((json) => BudgetNotification.fromJson(jsonDecode(json)))
        .toList();
    notifyListeners();
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = _notifications
        .map((notification) => jsonEncode(notification.toJson()))
        .toList();
    await prefs.setStringList('notifications', notificationsJson);
  }

  Future<void> addNotification(BudgetNotification notification) async {
    if (!_isEnabled) return;

    _notifications.insert(0, notification);
    await _saveNotifications();
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      await _saveNotifications();
      notifyListeners();
    }
  }

  Future<void> clearNotifications() async {
    _notifications.clear();
    await _saveNotifications();
    notifyListeners();
  }
}
