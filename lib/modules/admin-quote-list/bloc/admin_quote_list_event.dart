part of 'admin_quote_list_bloc.dart';

class AdminQuoteListEvent extends Equatable {
  const AdminQuoteListEvent();

  @override
  List<Object?> get props => [];
}

class FetchAdminQuoteListEvent extends AdminQuoteListEvent {
  const FetchAdminQuoteListEvent();
}

class EditQuoteEvent extends AdminQuoteListEvent {
  const EditQuoteEvent({
    required this.docID,
    required this.quote,
    required this.author,
  });

  final String docID;
  final String quote;
  final String? author;
}

class DeleteQuoteEvent extends AdminQuoteListEvent {
  const DeleteQuoteEvent({required this.quoteDocId});

  final String quoteDocId;
}
