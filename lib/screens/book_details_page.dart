
import 'package:flutter/material.dart';
import '../models/book.dart';

class BookDetailsPage extends StatefulWidget {
  final Book book;

  const BookDetailsPage({
    super.key,
    required this.book,
  });

  @override
  State<BookDetailsPage> createState() =>
      _BookDetailsPageState();
}

class _BookDetailsPageState
    extends State<BookDetailsPage> {

  int rating = 0;

  @override
  void initState() {
    super.initState();
    rating = widget.book.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Գրքի տվյալներ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            Text(
              widget.book.title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            Text('Հեղինակ՝ ${widget.book.author}'),

            const SizedBox(height: 10),

            Text('Ժանր՝ ${widget.book.genre.title}'),

            const SizedBox(height: 40),

            const Text(
              'Գնահատեք գիրքը',
              style: TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      rating = index + 1;
                    });
                  },
                  icon: Icon(
                    index < rating
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 35,
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, rating);
              },
              child: const Text('Պահպանել'),
            ),
          ],
        ),
      ),
    );
  }
}
