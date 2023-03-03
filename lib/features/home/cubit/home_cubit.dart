import 'package:absar/features/home/cubit/home_staets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);
   FirebaseFirestore firestore = FirebaseFirestore.instance;
List<DocumentSnapshot>? books;

Future<void> getBooksFromFirestore() async {
    emit(HomeLoadingState());
    try {
      final QuerySnapshot booksSnapshot = await firestore
          .collection('books')
          .get();
      books = booksSnapshot.docs;
      emit(HomeSuccessState());
    } on Exception catch (e) {
      emit(HomeErrorState(e.toString()));
      print(e);
    }
  }
 }