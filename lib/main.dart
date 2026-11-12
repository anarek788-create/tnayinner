
import 'package:flutter/material.dart';

import 'models/book.dart';
import 'widgets/book_tile.dart';
import 'screens/book_details_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Library',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController searchController =
      TextEditingController();

  Genre? selectedGenre;

  final List<Book> books = [
    Book(id: 1, title: 'Փոքրիկ իշխանը',
        author: 'Անտուան դը Սենտ-Էքզյուպերի',
        genre: Genre.novel),

    Book(id: 2, title: 'Հարի Փոթեր',
        author: 'Ջ. Ք. Ռոուլինգ',
        genre: Genre.fantasy),

    Book(id: 3, title: 'Անուշ',
        author: 'Հովհաննես Թումանյան',
        genre: Genre.poetry),

    Book(id: 4, title: 'Սամվել',
        author: 'Րաֆֆի',
        genre: Genre.novel),

    Book(id: 5, title: 'Հայոց պատմություն',
        author: 'Մովսես Խորենացի',
        genre: Genre.history),

    Book(id: 6, title: 'Մատյան ողբերգության',
        author: 'Գրիգոր Նարեկացի',
        genre: Genre.poetry),

    Book(id: 7, title: 'Մատանիների տիրակալը',
        author: 'Ջոն Ռոնալդ Ռուել Թոլքին',
        genre: Genre.fantasy),

    Book(id: 8, title: 'Դավիթ Բեկ',
        author: 'Րաֆֆի',
        genre: Genre.novel),

    Book(id: 9, title: 'Պատերազմ և խաղաղություն',
        author: 'Լև Տոլստոյ',
        genre: Genre.history),

    Book(id: 10, title: 'Գիքորը',
        author: 'Հովհաննես Թումանյան',
        genre: Genre.novel),
  ];

  List<Book> get filteredBooks {
    final query = searchController.text.toLowerCase();

    return books.where((book) {
      final matchesSearch =
          book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query);

      final matchesGenre =
          selectedGenre == null ||
          book.genre == selectedGenre;

      return matchesSearch && matchesGenre;
    }).toList();
  }

  int get readCount {
    return books.where((book) => book.isRead).length;
  }

  void deleteBook(Book book) {
    final index = books.indexOf(book);

    setState(() {
      books.remove(book);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${book.title} ջնջվեց'),
        action: SnackBarAction(
          label: 'Վերականգնել',
          onPressed: () {
            setState(() {
              books.insert(index, book);
            });
          },
        ),
      ),
    );
  }

  Future<void> openDetails(Book book) async {
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BookDetailsPage(book: book),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        book.rating = result;

        if (result > 0) {
          book.isRead = true;
        }
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayedBooks = filteredBooks;

    return Scaffold(
      appBar: AppBar(
        title: Text('Իմ գրադարանը ($readCount կարդացված)'),
        centerTitle: true,
      ),

      body: Column(
        children: [

          // Search field
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Որոնել գիրք կամ հեղինակ...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() {});
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          // Genre filters
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: ChoiceChip(
                    label: const Text('Բոլորը'),
                    selected: selectedGenre == null,
                    onSelected: (selected) {
                      setState(() {
                        selectedGenre = null;
                      });
                    },
                  ),
                ),

                ...Genre.values.map((genre) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: ChoiceChip(
                      label: Text(genre.title),
                      selected: selectedGenre == genre,
                      onSelected: (selected) {
                        setState(() {
                          selectedGenre =
                              selected ? genre : null;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Books list
          Expanded(
            child: displayedBooks.isEmpty
                ? const Center(
                    child: Text(
                      'Գիրք չի գտնվել։',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.separated(
                    itemCount: displayedBooks.length,
                    separatorBuilder: (context, index) {
                      return const Divider(height: 1);
                    },
                    itemBuilder: (context, index) {
                      final book = displayedBooks[index];

                      return Dismissible(
                        key: ValueKey(book.id),
                        direction: DismissDirection.horizontal,

                        onDismissed: (direction) {
                          deleteBook(book);
                        },

                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            left: 20,
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),

                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(
                            right: 20,
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),

                        child: BookTile(
                          book: book,

                          onChanged: (value) {
                            setState(() {
                              book.isRead = value ?? false;
                            });
                          },

                          onTap: () {
                            openDetails(book);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
