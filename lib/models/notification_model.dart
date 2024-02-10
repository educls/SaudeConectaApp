class NotificationModel {
  String receiverToken;
  String titleNotification;
  String bodyNotification;

  NotificationModel(
      {required this.receiverToken,
      required this.titleNotification,
      required this.bodyNotification});

  Map<String, dynamic> toJson() {
    return {
      "ReceiverToken": receiverToken,
      "TitleNotification": titleNotification,
      "BodyNotification": bodyNotification
    };
  }
}
