import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'property_state.dart';

class PropertyCubit extends Cubit<PropertyState> {
  PropertyCubit() : super(PropertyState());

  Future<void> submitRequest(String ownerID) async {
    emit(state.copyWith(status: SubmissionStatus.loading));
    await FirebaseFirestore.instance.collection('requests').add({
      'owner_id': ownerID,
      'message': 'Has requested a reservation of your property',
      'submitor_id': FirebaseAuth.instance.currentUser!.uid.toString(),
      'time': DateTime.now()
    });
    emit(state.copyWith(
        status: SubmissionStatus.success, message: "Submission Successful"));
    print(state.message);
  }
}
