import 'package:flutter/material.dart';
import 'package:jitsi/models/models.dart';

class MessagesModel extends ChangeNotifier {
  List<Message> messagesList = [];

  void add(Message item) {
    messagesList.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void addAll(List<Message> item) {
    messagesList.addAll(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  // Removes all items from the cart.
  void removeAll() {
    messagesList.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
