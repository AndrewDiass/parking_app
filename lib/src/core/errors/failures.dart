import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable implements Exception {
  const Failure();

  String? get message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({this.message});

  @override
  final String? message;

  @override
  List<Object?> get props => [message];
}

//Messages Failure
const serverFailureMessage = 'Desculpe, mas tivemos um erro no servidor';
