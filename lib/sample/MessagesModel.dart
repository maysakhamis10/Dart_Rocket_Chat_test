import 'package:flutter/material.dart';
import 'package:jitsi/models/models.dart';

class MessagesModel extends ChangeNotifier {
  List<Message> messagesList = [];

  void add(Message item) {
    messagesList.add(item);
    notifyListeners();
  }

  void addAll(List<Message> item) {
    messagesList.addAll(item);
    notifyListeners();
  }

  void removeAll() {
    messagesList.clear();
    notifyListeners();
  }
}
