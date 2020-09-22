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
      {File file, String roomId, String id, String token}) async {
    var request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "https://rocketdev.itgsolutions.com/api/v1/rooms.upload/$roomId"));

    Map<String, String> header = {
      'Content-type': 'multipart/form-data',
    };

    header['X-Auth-Token'] = token;
    header['X-User-Id'] = id;

    request.headers.addAll(header);
    request.fields["file"] = file.path;
    request.fields["msg"] = "hello hello hello";
    var pic = await http.MultipartFile.fromBytes(
        "file", await File.fromUri(file.uri).readAsBytes(),
        contentType: MediaType('image', 'png'));

    request.files.add(pic);
    var response = await request.send();
    print('ress .. ${response.stream.listen((value) {
      print('valuess ==>> $value');
    })}');

    response.stream.transform(utf8.decoder).listen((value) {
      print("upload response====>>$value");
    });
  }

  Future<String> getAvatar(String id) async {
    String result = "";
    var request = http.MultipartRequest(
        "GET",
        Uri.parse(
            "https://rocketdev.itgsolutions.com/api/v1/users.getAvatar?userId=$id"));
    var response = await request.send();
    print('ress .. ${response.stream.listen((value) {
      print('valuess ==>> $value');
//      result = value!=null?value.length;
    })}');
  }

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
