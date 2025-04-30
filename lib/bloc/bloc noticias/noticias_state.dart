import 'package:equatable/equatable.dart';
import 'package:psiemens/domain/noticia.dart';


sealed class NoticiasState extends Equatable {
  const NoticiasState();
  
  @override
  List<Object> get props => [];
}

final class NoticiasInitial extends NoticiasState {
  @override
  List<Object> get props => [];
}

class NoticiasLoading extends NoticiasState {}

class NoticiasLoaded extends NoticiasState {
  final List<Noticia> noticiasList;
  final DateTime lastUpdated;

  const NoticiasLoaded(this.noticiasList, this.lastUpdated);

  @override
  List<Object> get props => [noticiasList, lastUpdated];
}

class NoticiasError extends NoticiasState {
  final String errorMessage;

  const NoticiasError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}