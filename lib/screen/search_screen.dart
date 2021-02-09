import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import '../provider/words.dart';

// Widgets
import '../widget/home_screen/words_list.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search_screen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Word> _selectedProducts = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Word'),
              onChanged: (value) {
                setState(() {
                  _selectedProducts = Provider.of<Words>(context, listen: false)
                      .filterWords(value);
                });
              },
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: _selectedProducts.length,
                itemBuilder: (context, index) => ChangeNotifierProvider.value(
                  value: _selectedProducts[index],
                  child: WordsList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
