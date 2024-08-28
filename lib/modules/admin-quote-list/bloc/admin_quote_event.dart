part of 'admin_quote_bloc.dart';

class AdminQuoteEvent extends Equatable {
  const AdminQuoteEvent();

  @override
  List<Object?> get props => [];
}

class FetchAdminQuoteListEvent extends AdminQuoteEvent {
  const FetchAdminQuoteListEvent();
}

class EditQuoteEvent extends AdminQuoteEvent {
  const EditQuoteEvent({
    required this.docID,
    required this.quote,
    required this.author,
  });

  final String docID;
  final String quote;
  final String? author;
}

class DeleteQuoteEvent extends AdminQuoteEvent {
  const DeleteQuoteEvent({required this.quoteDocId});

  final String quoteDocId;
}
