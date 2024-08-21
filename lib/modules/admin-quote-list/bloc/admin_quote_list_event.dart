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
  const EditQuoteEvent(
      {required this.docID, required this.quote, required this.author});
  final String docID;
  final String quote;
  final String? author;
}

class DeleteQuoteEvent extends AdminQuoteListEvent {
  const DeleteQuoteEvent({required this.docID});
  final String docID;
}
