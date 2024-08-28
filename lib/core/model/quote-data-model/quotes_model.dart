import 'package:equatable/equatable.dart';

class QuoteModel extends Equatable {
  const QuoteModel({
    required this.quote,
    required this.docID,
    required this.createdBy,
    this.author,
  });

  final String quote;
  final String? author;
  final String docID;
  final String createdBy;

  factory QuoteModel.fromFireStore(Map<String, dynamic> data) {
    return QuoteModel(
        quote: data['quote'],
        author: data['author'],
        docID: data['doc_id'],
        createdBy: data['created_by']);
  }

  static Map<String, dynamic> toFireStore(QuoteModel quote) {
    return {
      'quote': quote.quote,
      'author': quote.author,
      'doc_id': quote.docID,
      'created_by': quote.createdBy
    };
  }

  @override
  List<Object?> get props => [quote, author, createdBy, docID];
}
