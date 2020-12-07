part of realtime;

abstract class _ClientMessagesMixin implements _DdpClientWrapper {
  //https://rocket.chat/docs/developer-guides/realtime-api/method-calls/load-history/
  // timestamp: The NEWEST message timestamp date (or null) to only retrieve messages before this time. - this is used to do pagination
  // quantity: message quantity
  // dateobject: the date of the last time the client got data for the room (?)
  Future<RoomMessageHistory> loadHistory(
    String roomId, {
    DateTime timestamp,
    int quantity = 50,
  }) {
    Completer<RoomMessageHistory> completer = Completer();
    this
        ._getDdpClient()
        .call('loadHistory', [
          roomId,
          timestamp != null ? DateTimeToMap(timestamp) : null,
          quantity,
        ])
        .then((call) =>
            completer.complete(RoomMessageHistory.fromJson(call.reply)))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<Message> sendMessage(String roomId, String text) {
    Completer<Message> completer = Completer();
    final message = Message()
      ..roomId = roomId
      ..msg = text;
    this
        ._getDdpClient()
        .call('sendMessage', [message])
        .then((call) => completer.complete(Message.fromJson(call.reply)))
        .catchError((error) => completer.completeError(error));

    return completer.future;
  }

  Future<void> Upload(
      {File file,
      String roomId,
      String id,
      String token,
      AttachmentType type}) async {
    print("fileeeee ${file.path}");
    var contentType;

    if (type == AttachmentType.image)
      contentType = MediaType('image', '*/*');
    else if (type == AttachmentType.audio)
      contentType = MediaType('audio', '*/*');
    else if (type == AttachmentType.video)
      contentType = MediaType('video', '*/*');
    else
      contentType = MediaType('file', '*/*');
    var request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "https://rocketdev.itgsolutions.com/api/v1/rooms.upload/$roomId"));
    Map<String, String> header = {
      'Content-type': 'multipart/form-data',
      'X-Auth-Token': token,
      'X-User-Id': id
    };

    request.fields["description"] = 'FROM OUR APP HELLOOOO';

    request.fields["msg"] = "from my device";

    final test = await http.MultipartFile.fromPath('file', file.path,
        contentType: contentType);

    request.files.add(test);

    request.headers.addAll(header);

    try {
      final streamedResponse = await request.send();
      streamedResponse.stream.transform(utf8.decoder).listen((value) {
        print(value);
        return Future.value(value);
      });
    } catch (e) {
      print(e);
    }
  }

//  Future<void> UploadAudio(
//      {File file, String roomId, String id, String token}) async {
//    var request = http.MultipartRequest(
//        "POST",
//        Uri.parse(
//            "https://rocketdev.itgsolutions.com/api/v1/rooms.upload/$roomId"));
//    Map<String, String> header = {
//      'Content-type': 'multipart/form-data',
//      'X-Auth-Token': token,
//      'X-User-Id': id
//    };
//
//    request.fields["description"] = 'FROM OUR APP HELLOOOO';
//
//    request.fields["msg"] = "from my device";
//
//    final audio = await http.MultipartFile.fromPath('file', file.path,
//        contentType: MediaType('audio', '*/*'));
//    request.files.add(audio);
//
//    request.headers.addAll(header);
//
//    try {
//      final streamedResponse = await request.send();
//      streamedResponse.stream.transform(utf8.decoder).listen((value) {
//        print(value);
//        return Future.value(value);
//      });
//    } catch (e) {
//      print(e);
//    }
//  }

  Future<void> editMessage(Message message) {
    Completer<void> completer = Completer();
    this
        ._getDdpClient()
        .call('updateMessage', [message])
        .then((call) => completer.complete(call))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> deleteMessage(Message message) {
    Completer<void> completer = Completer();
    this
        ._getDdpClient()
        .call('deleteMessage', [
          <String, String>{'_id': message.id},
        ])
        .then((call) => completer.complete(call))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> starMessage(Message message) {
    Completer<void> completer = Completer();
    this
        ._getDdpClient()
        .call('starMessage', [
          <String, dynamic>{
            '_id': message.id,
            'rid': message.roomId,
            'starred': true,
          },
        ])
        .then((call) => completer.complete(call))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> unStarMessage(Message message) {
    Completer<void> completer = Completer();
    this
        ._getDdpClient()
        .call('starMessage', [
          <String, dynamic>{
            '_id': message.id,
            'rid': message.roomId,
            'starred': false,
          },
        ])
        .then((call) => completer.complete(call))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> pinMessage(Message message) {
    Completer<void> completer = Completer();
    this
        ._getDdpClient()
        .call('pinMessage', [message])
        .then((call) => completer.complete(call))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> unPinMessage(Message message) {
    Completer<void> completer = Completer();
    this
        ._getDdpClient()
        .call('unpinMessage', [message])
        .then((call) => completer.complete(call))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> setReaction(Message message, String emoji, bool shouldReact) {
    Completer<void> completer = Completer();
    this
        ._getDdpClient()
        .call('setReaction', [emoji, message.id, shouldReact])
        .then((call) => completer.complete(call))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }
}
