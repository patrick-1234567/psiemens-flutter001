import 'package:bloc/bloc.dart';
import 'package:psiemens/bloc/bloc noticias/noticias_event.dart';
import 'package:psiemens/bloc/bloc noticias/noticias_state.dart';


class NoticiasBloc extends Bloc<NoticiasEvent, NoticiasState> {
  NoticiasBloc() : super(NoticiasInitial()) {
    on<NoticiasEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
