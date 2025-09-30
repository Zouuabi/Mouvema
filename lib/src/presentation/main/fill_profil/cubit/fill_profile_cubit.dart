import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart' show TextEditingController;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/failure.dart';
import '../../../../core/helpers/image_picker.dart';
import '../../../../data/repository/repository_impl.dart';

part 'fill_profil_state.dart';

class FillProfilCubit extends Cubit<FillProfilState> {
  FillProfilCubit(this.repositoryImpl)
      : super(const FillProfilState(status: Status.initial));

  final RepositoryImpl repositoryImpl;

  TextEditingController usernameController = TextEditingController();
  TextEditingController telController = TextEditingController();

  String birth = 'YYYY-MM-DD';
  Uint8List? photo;
  String? tel;

  void dateAdded(String date) {
    birth = date.substring(0, 9);
    emit(FillProfilState(status: Status.dateAdded, data: birth));
  }

  void addPhoto() async {
    photo = await takepicture();
    if (photo != null) {
      emit(FillProfilState(status: Status.photoAdded, data: photo));
    }
  }

  void fillProfile() async {
    if (usernameController.text.isEmpty) {
      emit(const FillProfilState(
          status: Status.failed, errorMessage: 'username empty'));
    } else if (birth == 'null') {
      emit(const FillProfilState(
          status: Status.failed, errorMessage: 'User Name Emptyy !'));
    } else {
      emit(const FillProfilState(status: Status.loading));
      var result = await repositoryImpl.fillProfil(
          username: usernameController.text,
          birthdate: birth,
          tel: telController.text,
          userType: 'shipper', // Default value - this should be updated to get from user selection
          image: photo);
      result.fold(
        (failure) {
          emit(FillProfilState(
              status: Status.failed, errorMessage: failure.errrorMessage));
        },
        (vd) {
          emit(const FillProfilState(status: Status.success));
        },
      );
    }
  }

  void logout() async {
    Either<Failure, void> result = await repositoryImpl.logOut();
    result.fold((l) {
      emit(FillProfilState(
          status: Status.failed, errorMessage: l.errrorMessage));
    }, (r) {
      return;
    });
  }
}
