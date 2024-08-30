part of 'admin_quote_bloc.dart';

abstract class AdminQuoteEvent extends Equatable {
  const AdminQuoteEvent();
}

class FetchAdminQuoteListEvent extends AdminQuoteEvent {
  const FetchAdminQuoteListEvent();

  @override
  List<Object?> get props => [];
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

  @override
  List<Object?> get props => [docID, quote, author];
}

class DeleteQuoteEvent extends AdminQuoteEvent {
  const DeleteQuoteEvent({required this.quoteDocId});

  final String quoteDocId;
  @override
  List<Object?> get props => [quoteDocId];
}
