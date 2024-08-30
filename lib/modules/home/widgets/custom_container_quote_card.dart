import 'package:flutter/material.dart';

class CustomContainerQuoteCard extends StatefulWidget {
  const CustomContainerQuoteCard({
    super.key,
    required this.quote,
    required this.author,
    required this.onBookmarkTap,
    required this.isFavourite,
  });

  final String quote;
  final String author;
  final VoidCallback onBookmarkTap;
  final bool isFavourite;

  @override
  State<CustomContainerQuoteCard> createState() =>
      _CustomContainerQuoteCardState();
}

class _CustomContainerQuoteCardState extends State<CustomContainerQuoteCard> {
  late bool isBookmarked;

  @override
  void initState() {
    super.initState();
    isBookmarked = widget.isFavourite;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 100),
      alignment: Alignment.center,
      height: size.height - 200,
      width: size.width - 40,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/quote.png',
                height: 70,
                color: Colors.white,
              ),
              const SizedBox(height: 50),
              Text(
                widget.quote,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 50),
              Text(
                widget.author,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 50),
              IconButton(
                onPressed: () {
                  widget.onBookmarkTap();
                  setState(() {
                    isBookmarked = !isBookmarked;
                  });
                },
                icon: isBookmarked
                    ? const Icon(
                        Icons.bookmark,
                        color: Colors.white,
                        size: 40,
                      )
                    : const Icon(
                        Icons.bookmark_outline,
                        color: Colors.white,
                        size: 40,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
