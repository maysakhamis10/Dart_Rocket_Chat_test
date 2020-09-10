part of realtime;

class UpdateEvent {
  String collection;
  String operation;
  String id;
  Map<String, dynamic> doc;
}

abstract class _ClientSubscriptionsMixin implements _DdpClientWrapper {
  Future<String> subRoomMessages(String name) {
    Completer<String> completer = Completer();
    this
        ._getDdpClient()
        .sub('stream-room-messages', [name, true])
        .then((call) => completer.complete(call.id))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> unSubRoomMessages(String subId) {
    Completer<void> completer = Completer();
    this._getDdpClient()
      .unSub(subId)
      .then((call) => completer.complete(call))
      .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> subRoomsChanged(String userId) {
    Completer<void> completer = Completer();
    this
        ._getDdpClient()
        .sub('stream-notify-user', ['$userId/rooms-changed', true])
        .then((call) => completer.complete(null))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Stream<UpdateEvent> roomMessages() {
    StreamController<UpdateEvent> controller = StreamController();
    this
        ._getDdpClient()
        .collectionByName('stream-room-messages')
        .addUpdateListener((String collection, String operation, String id,
            Map<String, dynamic> doc) {
          print(collection + " "+operation+"     "+id+" ");
      controller.add(UpdateEvent()
        ..collection = collection
        ..operation = operation
    /*    ..id = id
        ..doc = doc*/);
    });
    return controller.stream;
  }

  Stream<Channel> roomsChanged() {
    StreamController<Channel> controller = StreamController();
    this
        ._getDdpClient()
        .collectionByName('stream-notify-user')
        .addUpdateListener((collection, operation, id, doc) {
      print(collection + " "+operation+"     "+id+" ");
      if (doc['eventName'].endsWith('rooms-changed')) {
        print(doc['args']);
        controller.add(Channel.fromJson(doc['args'][1]));
      }
    });
    return controller.stream;
  }
}
