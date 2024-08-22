import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/modules/admin-quote-list/bloc/admin_quote_list_bloc.dart';

class UpdateBottomSheetWidget extends StatefulWidget {
  const UpdateBottomSheetWidget({
    super.key,
    required this.docID,
    required this.author,
    required this.quote,
    required this.onClosedTap,
  });

  final String docID;
  final String author;
  final String quote;
  final VoidCallback onClosedTap;

  @override
  State<UpdateBottomSheetWidget> createState() =>
      _UpdateBottomSheetWidgetState();
}

class _UpdateBottomSheetWidgetState extends State<UpdateBottomSheetWidget> {
  final TextEditingController _quoteController = TextEditingController();

  final TextEditingController _authorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _quoteController.text = widget.quote;
    _authorController.text = widget.author;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 40),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          TextFormField(
            controller: _quoteController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _authorController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                context.read<AdminQuoteListBloc>().add(
                      EditQuoteEvent(
                          docID: widget.docID,
                          quote: _quoteController.text,
                          author: _authorController.text),
                    );
                context
                    .read<AdminQuoteListBloc>()
                    .add(const FetchingAdminQuoteListEvent());
                widget.onClosedTap();
              },
              child: const Text('Update'))
        ],
      ),
    );
  }
}
