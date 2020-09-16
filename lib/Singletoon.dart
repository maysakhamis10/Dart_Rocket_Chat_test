import 'dart:async';

import 'package:jitsi/services/http_service.dart';

import 'models/models.dart';

class Singleton {
  static final Singleton _singleton = Singleton._internal();

  var inprogressCountProvider;
  var getGreadyCounterProvider;
  var headerProvider;
  var checkboxProvider;
  Timer countDownTimer;
  // LoginBloc loginBloc;
  String currentLocationAddress;
  Timer inprogressTimer;
  String accessToken;
  User user;
  HttpService httpService;
  int noDirect = 0;
  int noGroups = 0;
  int noFriends = 0;

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();

  void cancelTimers() {
    if (inprogressTimer != null) {
      inprogressTimer.cancel();
      inprogressTimer = null;
    }
    if (countDownTimer != null) {
      countDownTimer.cancel();
      countDownTimer = null;
    }
  }

// Future<void> sendAnalyticsEvent(FirebaseAnalytics analytics,String tagName, String parameter , String parameterValue) async {
//   if(parameter!= null){
//     await analytics.logEvent(
//       name: tagName,
//       parameters: <String, dynamic>{
//         parameter: parameterValue,
//       },
//     );
//   }
//   else {
//     await analytics.logEvent(
//       name: tagName,
//     );
//   }
//   print('logEvent succeeded');
// }

}
