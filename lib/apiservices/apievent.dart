abstract class ApiEvent {}

class LoginEvents extends ApiEvent {
  String? password;
  String? email;
  LoginEvents({this.email, this.password});
}
class SignupEvent extends ApiEvent {
  String? fullname, gender, address, repassword, email, password,image;
  int? phone;
  SignupEvent(
      {this.fullname,
      this.address,
      this.gender,
      this.repassword,
      this.phone,
      this.email,
      this.password,
      this.image});
}
class AddBookEvent extends ApiEvent {
  String? bookName, category, author, imageUrl;
  double? oldPrice,newPrice;
  AddBookEvent(
      {
        this.oldPrice,
        this.newPrice,
        this.category,
        this.bookName,
        this.author,
        this.imageUrl,
      });
}
class OrderEvent extends ApiEvent {
  String? fullName,address,email,image;
  int? phone,quantity,total;
  DateTime? fromDate,toDate;
  OrderEvent(
      {this.fullName,
      this.address,
      this.quantity,
      this.phone,
      this.email,
      this.image, 
      this.fromDate, 
      this.toDate,
      });
}
class BooksDataEvents extends ApiEvent {
 
}
class AdminProfileEvents extends ApiEvent {
  get image => null;
  
}
class UserProfileEvents extends ApiEvent {
  
}
class OrderDataEvent extends ApiEvent {
 
}