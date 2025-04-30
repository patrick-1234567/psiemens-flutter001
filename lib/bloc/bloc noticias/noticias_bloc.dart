import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'noticias_event.dart';
part 'noticias_state.dart';

class NoticiasBloc extends Bloc<NoticiasEvent, NoticiasState> {
  NoticiasBloc() : super(NoticiasInitial()) {
    on<NoticiasEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
