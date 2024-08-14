import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admin_quote_event.dart';
part 'admin_quote_state.dart';

class AdminQuoteBloc extends Bloc<AdminQuoteEvent, AdminQuoteState> {
  AdminQuoteBloc() : super(const AdminQuoteState()) {
    on<AdminQuoteEvent>((event, emit) {});
  }
}
