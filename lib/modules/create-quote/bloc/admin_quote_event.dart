part of 'admin_quote_bloc.dart';

class AdminQuoteEvent extends Equatable {
  const AdminQuoteEvent();

  @override
  List<Object?> get props => [];
}

class AddQuoteToFireStoreEvent extends AdminQuoteEvent {
  const AddQuoteToFireStoreEvent();
}

class AuthorFieldChangeEvent extends AdminQuoteEvent {
  const AuthorFieldChangeEvent(this.authorName);
  final String authorName;
}

class QuoteFieldChangeEvent extends AdminQuoteEvent {
  const QuoteFieldChangeEvent(this.quote);
  final String quote;
}
