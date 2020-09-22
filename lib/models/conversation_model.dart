import 'package:firebase_chat_app/Constants/constants.dart';

class ConversationModel {
  final String sendBy;
  final String message;
  final String timeDate;
  bool get isSendByMe {
    // String _myId = await HelperFunctions.getUserEmailSharedPrefernece();
    var y = sendBy.replaceAll('(', '').replaceAll(')', '')?.trim();
    return y != Constants.myId;
  }

  ConversationModel(this.sendBy, this.message, this.timeDate);
}
