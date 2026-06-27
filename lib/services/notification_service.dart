import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService instance = NotificationService._internal();

  factory NotificationService() => instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/app_icon_transparant');

    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
    );

    // Request permissions for Android 13+
    _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  NotificationDetails _getNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'ainterview_channel_id',
        'AInterview Notifications',
        channelDescription: 'Notifications for interview practice and reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future<void> showLoginNotification() async {
    await _notificationsPlugin.show(
      id: 0,
      title: 'Welcome Back! \u{1F44B}',
      body: 'Ready to crush your next interview?',
      notificationDetails: _getNotificationDetails(),
    );
  }

  Future<void> schedulePracticeReminder() async {
    // Cancel any existing practice reminder first so we don't spam
    await _notificationsPlugin.cancel(id: 1);

    // Schedule for 24 hours from now
    final scheduledDate = tz.TZDateTime.now(tz.local).add(const Duration(hours: 24));

    await _notificationsPlugin.zonedSchedule(
      id: 1,
      title: 'Time to Practice! \u{23F0}',
      body: 'Take 5 minutes to sharpen your interview skills today!',
      scheduledDate: scheduledDate,
      notificationDetails: _getNotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
