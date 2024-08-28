part of 'create_quote_bloc.dart';

class CreateQuoteEvent extends Equatable {
  const CreateQuoteEvent();

  @override
  List<Object?> get props => [];
}

class AddQuoteToFireStoreEvent extends CreateQuoteEvent {
  const AddQuoteToFireStoreEvent({required this.author});
  final String author;
}

class QuoteFieldChangeEvent extends CreateQuoteEvent {
  const QuoteFieldChangeEvent(this.quote);
  final String quote;
}
