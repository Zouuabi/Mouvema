import 'package:doft/src/core/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/internet_checker.dart';
import '../../domain/repositories/repositories.dart';
import '../data_source/remote_data_source/firebase_auth.dart';
import 'package:dartz/dartz.dart';



class RepositoryImpl extends Repository {
  RepositoryImpl({required this.auth});


  final FirebaseAuthentication auth;
  final InternetCheckerImpl internetChecker = InternetCheckerImpl() ; 



  @override
  Future<Either<Failure, void>> signIn(String email, String password) async {
    if (await internetChecker.isConnected()) {
      try {
        await auth.signIn(email, password);
        return const Right(null);
      } on FirebaseAuthException catch (error) {
        return Left(Failure(errrorMessage: error.code));
      }
    } else {
      return Left(Failure(errrorMessage: 'There is no ineternet'));
    }
  }

  @override
  Future<Either<Failure, void>> register(String email, String password) async {
    try {
      await auth.register(email, password);
      // register user ... 
      // upload pohtot 
      return const Right(null);
    } on FirebaseAuthException catch (error) {
      return Left(Failure(errrorMessage: error.code));
    }
  }
}