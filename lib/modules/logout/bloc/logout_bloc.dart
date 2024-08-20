import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/authentication-repository/authentication_repository.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  LogoutBloc() : super(const LogoutState()) {
    on<LogoutEvent>(logout);
  }

  Future<void> logout(LogoutEvent event, Emitter<LogoutState> emit) async {
    try{
      emit(state.copyWith(status: LogoutStateStatus.loading));
      await AuthenticationRepository().logOut();
      emit(state.copyWith(status: LogoutStateStatus.success));
    }catch(e){
      emit(state.copyWith(status: LogoutStateStatus.failure,errorMessage: e.toString()));
    }
  }
}
