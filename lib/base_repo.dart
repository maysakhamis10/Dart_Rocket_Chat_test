// import 'package:firebase_analytics/firebase_analytics.dart';

import 'Exceptions/network_error.dart';

abstract class Repo {
  void handleError(PopcornError error);
  // Future<void> sendAnalyticsEvent(FirebaseAnalytics analytics,String tagName, String parameter , String parameterValue);

}

class BaseRepo implements Repo {
  @override
  void handleError(PopcornError error) {
    // TODO: implement handleError
    print("plz handel this error>>>" + error.errorMessage);
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