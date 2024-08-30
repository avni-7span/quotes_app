part of 'create_quote_bloc.dart';

abstract class CreateQuoteEvent extends Equatable {
  const CreateQuoteEvent();
}

class AddQuoteToFireStoreEvent extends CreateQuoteEvent {
  const AddQuoteToFireStoreEvent({required this.author});
  final String author;

  @override
  List<Object?> get props => [];
}

class QuoteFieldChangeEvent extends CreateQuoteEvent {
  const QuoteFieldChangeEvent(this.quote);
  final String quote;

  @override
  List<Object?> get props => [quote];
}
