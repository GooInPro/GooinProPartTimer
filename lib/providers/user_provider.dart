import 'package:flutter/material.dart';


class UserProvider extends ChangeNotifier {

  int? pno;
  String? pemail;
  String? pname;
  String? accessToken;
  String? refreshToken;

  void updateUserData(int? pno, String? pemail, String? pname, String? accessToken, String? refreshToken){
    this.pno = pno;
    this.pemail = pemail;
    this.pname = pname;
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
    notifyListeners();
  }

  void registerUserData(String? pemail, String? pname) {
    this.pemail = pemail;
    this.pname = pname;
    notifyListeners();
  }

}