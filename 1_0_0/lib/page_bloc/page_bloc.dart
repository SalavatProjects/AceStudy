import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../config.dart';

part 'page_event.dart';
part 'page_state.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  PageBloc() : super(PageInitial()) {
    on<PageEvent>((event, emit) {
      // TODO: implement event handler

    });

    on<PageChangeEvent>((event, emit) {
      // emit(PageInitial());
      app_page = event.page_name;
      emit(PageChanged());
    },);
  }
}
