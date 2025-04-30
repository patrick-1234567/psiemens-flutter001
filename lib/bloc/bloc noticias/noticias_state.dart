part of 'noticias_bloc.dart';

sealed class NoticiasState extends Equatable {
  const NoticiasState();
  
  @override
  List<Object> get props => [];
}

final class NoticiasInitial extends NoticiasState {}
