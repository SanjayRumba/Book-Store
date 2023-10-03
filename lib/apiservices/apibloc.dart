import 'package:book_shop/model/AdminProfileData.dart';
import 'package:book_shop/model/BooksData.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/orderdata.dart';
import 'apievent.dart';
import 'apiservice.dart';
import 'apiserviceimpl.dart';
import 'apistate.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  ApiService api = ApiServiceImpl();
  List<BooksData>? booksDataList;
  List<AdminProfileData>? adminProfileList;
  List<OrderData>? orderList;

  ApiBloc() : super(InitialState()) {
    on<BooksDataEvents>( //get data
      (event, emit) async {
        try {
          booksDataList = await api.getBooksDetails();
          emit(LoadedState(booksDataList: booksDataList));
        } catch (e) {
          emit(ErrorState());
        }
      },
    );

    on<LoginEvents>(
      (event, emit) async {
        var response = await api.checkCredientialforLogin(
          email: event.email,
          password: event.password,
        );
        emit(LoadedState(response: response));
      },
    );

    on<SignupEvent>(
      (event, emit) async {
        emit(LoadingState());
        var response = await api.signupDataToFirebase(
          fullname: event.fullname,
          phone: event.phone,
          address: event.address,
          gender: event.gender,
          email: event.email,
          password: event.password,
          repassword: event.repassword,
          image: event.image
        );
        emit(LoadedState(response: response));
      },
    );
    on<AdminProfileEvents>(
          (event, emit) async {
            try {
              adminProfileList = await api.getAdminProfileDetails();
              emit(LoadedState(adminProfileList: adminProfileList));
            } catch (e) {
              emit(ErrorState());
            }
          },
        );
  
  on<AddBookEvent>(
      (event, emit) async {
        emit(LoadingState());
        var response = await api.saveBookDataToFirestore(
          category:event.category,
          bookName:event.bookName,
          author:event.author,
          oldPrice:event.oldPrice,
          newPrice:event.newPrice,
          imageUrl:event.imageUrl,
        );
        emit(LoadedState(response: response));
      },
    );
    on<OrderEvent>(
      (event, emit) async {
        emit(LoadingState());
        var response = await api.saveOrderDataToFirebase(
          fullName:event.fullName,
          address:event.address,
          quantity:event.quantity,
          phone:event.phone,
          email:event.email,
          image:event.image, 
          fromDate:event.fromDate, 
          toDate:event.toDate,
        );
        emit(LoadedState(response: response));
      },
    );
    on<OrderDataEvent>( //get data
      (event, emit) async {
        try {
          orderList = await api.getOrderDetails();
          emit(LoadedState(orderList: orderList));
        } catch (e) {
          emit(ErrorState());
        }
      },
    );
    



}
}
