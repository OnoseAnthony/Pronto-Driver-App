class CustomUser {
  final String uid;
  final String fName;
  final String lName;
  final String earnings;
  final String photoUrl;
  final String accountNumber;
  final String bankName;
  final String bvn;

  CustomUser(
      {this.uid,
      this.fName,
      this.lName,
      this.earnings,
      this.photoUrl,
      this.bankName,
      this.accountNumber,
      this.bvn});

  CustomUser.fromMap(Map map)
      : this.uid = map['uid'],
        this.fName = map['fName'],
        this.lName = map['lName'],
        this.earnings = map['earnings'],
        this.photoUrl = map['photoUrl'],
        this.accountNumber = map['accountNumber'],
        this.bankName = map['bankName'],
        this.bvn = map['bvn'];
}
