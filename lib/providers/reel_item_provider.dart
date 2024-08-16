import 'package:flutter/cupertino.dart';
import 'package:tik_tok_clon/models/user_model.dart';

import '../sheared/network/remote/firebase/firebase_manager.dart';

class ReelItemProvider extends ChangeNotifier{
  UserModel ? author ;
 void  getAuthor(String id)async{
    author = await FirebaseManager.getUserById(id);
    notifyListeners();
  }
}