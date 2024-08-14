part of 'admin_quote_bloc.dart';

class AdminQuoteEvent extends Equatable {
  const AdminQuoteEvent();

  @override
  List<Object?> get props => [];
}

class AddQuoteToFireStoreEvent extends AdminQuoteEvent {
  const AddQuoteToFireStoreEvent();
}
