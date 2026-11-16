import 'package:flutter/material.dart';
import '../models/book.dart';
import 'star_rating.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onTap;

  const BookTile({
    super.key,
    required this.book,
    required this.onChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: book.isRead,
        onChanged: onChanged,
      ),
      title: Text(
        book.title,
        style: TextStyle(
          decoration:
              book.isRead ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${book.author} • ${book.genre.label}'),
          if (book.rating > 0)
            StarRating(
              rating: book.rating,
              size: 17,
            ),
        ],
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
