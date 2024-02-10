class SetTokenFirebaseModel {
  String tokenFirebase;

  SetTokenFirebaseModel({
    required this.tokenFirebase,
  });

  Map<String, dynamic> toJson() {
    return {"TokenFirebase": tokenFirebase};
  }
}
