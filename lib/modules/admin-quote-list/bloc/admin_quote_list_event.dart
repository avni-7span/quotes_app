part of 'admin_quote_list_bloc.dart';

class AdminQuoteListEvent extends Equatable {
  const AdminQuoteListEvent();

  @override
  List<Object?> get props => [];
}

class FetchingAdminQuoteListEvent extends AdminQuoteListEvent {
  const FetchingAdminQuoteListEvent();
}

class EditQuoteEvent extends AdminQuoteListEvent {
  const EditQuoteEvent();
}

class DeleteQuoteEvent extends AdminQuoteListEvent {
  const DeleteQuoteEvent();
}
