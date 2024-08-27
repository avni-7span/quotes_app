import 'package:equatable/equatable.dart';

class Quotes extends Equatable {
  const Quotes({this.quote, this.author, this.docID, this.createdBy});

  final String? quote;
  final String? author;
  final String? docID;
  final String? createdBy;

  static const emptyQuoteData = Quotes(author: '', quote: '');

  static Quotes fromFireStore(Map<String, dynamic> data) {
    return Quotes(
        quote: data['quote'],
        author: data['author'],
        docID: data['doc_id'],
        createdBy: data['created_by']);
  }

  static Map<String, dynamic> toFireStore(Quotes quote) {
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
