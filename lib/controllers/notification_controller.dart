import '../models/notification_model.dart';
import '../services/notification_service.dart';

FetchApiSendNotification fetchApiSendNotification = FetchApiSendNotification();

Future<void> sendNotification(String receiverToken, String titleNotification,
    String bodyNotification) async {
  NotificationModel newNotification = NotificationModel(
      receiverToken: receiverToken,
      titleNotification: titleNotification,
      bodyNotification: bodyNotification);

  fetchApiSendNotification.fetchSendNotification(newNotification);
}
