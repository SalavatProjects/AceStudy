import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../config/config.dart';

part 'page_event.dart';
part 'page_state.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  PageBloc() : super(PageInitial()) {
    on<PageEvent>((event, emit) {
      

    });

    on<PageChangeEvent>((event, emit) {

      Config.setPageName = event.page_name;
      emit(PageChanged());
    },);
  }
}
