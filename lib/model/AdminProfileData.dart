class AdminProfileData {
  String? fullname;
  String? address;
  String? gender;
  int? phone;
  String? image;
  String?email;

  AdminProfileData(
      {this.fullname,
      this.address,
      this.gender,
      this.phone,
      this.image,
      this.email});

  AdminProfileData.fromJson(Map<String, dynamic> json) {
    fullname = json['fullname'];
    address = json['address'];
    gender = json['gender'];
    phone = json['phone'];
    image = json['image'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullname'] = this.fullname;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['email'] = this.email;
    return data;
  }
}
