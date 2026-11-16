import 'package:flutter/material.dart';
import 'package:tnayinner/models/book.dart';
import 'package:tnayinner/widgets/star_rating.dart';

class BookDetailsPage extends StatefulWidget {
  final Book book;

  const BookDetailsPage({
    super.key,
    required this.book,
  });

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late int rating;

  @override
  void initState() {
    super.initState();
    rating = widget.book.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Գրքի տվյալներ'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(76),
        child: Column(
          children: [
            Text(
              widget.book.title,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            Text(
              'Հեղինակ՝ ${widget.book.author}',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Ժանր՝ ${widget.book.genre.label}',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Text(
              'Գնահատեք գիրքը',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 15),
            StarRating(
              rating: rating,
              size: 40,
              onChanged: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: rating == 0
                  ? null
                  : () {
                      Navigator.pop(context, rating);
                    },
              child: Text('Պահպանել'),
            ),
          ],
        ),
      ),
    );
  }
}
