import 'package:book_shop/model/AdminProfileData.dart';
import 'package:book_shop/model/BooksData.dart';
import '../model/orderdata.dart';


abstract class ApiState {}

class InitialState extends ApiState {}

class LoadingState extends ApiState {}

class LoadedState extends ApiState {
  var response;
  var isSuccessful;
  List<BooksData>? booksDataList;
  
  var userList; // If userList is supposed to hold other types of data, you can use dynamic
  List<AdminProfileData>? adminProfileList; 
  List<OrderData>? orderList;
  LoadedState({this.response, this.booksDataList, this.adminProfileList, this.userList,this.orderList,this.isSuccessful});
}

// class ProfileLoadedState extends ApiState {
//   var userList; // If userList is supposed to hold other types of data, you can use dynamic
//   ProfileLoadedState({this.userList});
// }

class ErrorState extends ApiState {}
