class CustomUser {
  final String uid;
  final bool isDriver;
  final String fName;
  final String lName;
  final String photoUrl;

  CustomUser({this.uid, this.isDriver, this.fName, this.lName, this.photoUrl});

  CustomUser.fromMap(Map map)
      : this.uid = map['uid'],
        this.isDriver = map['isDriver'],
        this.fName = map['fName'],
        this.lName = map['lName'],
        this.photoUrl = map['photoUrl'];

  Map toMap() {
    return {
      'uid': this.uid,
      'isDriver': this.isDriver,
      'fName': this.fName,
      'lName': this.lName,
      'photoUrl': this.photoUrl,
    };
  }
}
