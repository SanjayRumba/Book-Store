
import 'package:book_shop/model/AdminProfileData.dart';
import 'package:book_shop/model/BooksData.dart';
import 'package:book_shop/model/orderdata.dart';

abstract class ApiService {
  Future<bool> checkCredientialforLogin({String? email, String? password});

  Future<bool> signupDataToFirebase({
    String? fullname,
    String? address,
    String? gender,
    int? phone,
    String? email,
    String? password,
    String? repassword,
    String? image,
  });
  Future<bool> saveBookDataToFirestore({
        String? category,
        String? bookName,
        String? author,
        double? oldPrice,
        double? newPrice,      
        String? imageUrl,
  });
  Future<bool> saveOrderDataToFirebase({
   String? fullName,
      String? address,
      int? quantity,
      int? phone,
      String? email,
      String? image, 
      DateTime? fromDate, 
      DateTime? toDate,
  });
  Future<bool>changeOtpPw({
    String? newPassword,
    String? confirmPassword,
  });


  Future<bool>changePassword({
    String? newPassword,
    String? currentPassword,
    String? confirmPassword,
  });

  Future<List<BooksData>?> getBooksDetails();
  Future<List<AdminProfileData>?> getAdminProfileDetails();
  Future<List<OrderData>?> getOrderDetails();

}

