import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import '../models/public_data.dart';

// Providers
import '../provider/words.dart';

// Screens
import './search_screen.dart';

// Widgets
import '../widget/home_screen/words_list.dart';
import '../widget/home_screen/edit_add_form.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Word> _words = Provider.of<Words>(context).words;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () =>
                  Navigator.of(context).pushNamed(SearchScreen.routeName)),
          IconButton(
              icon: Icon(PublicData.isEditMode ? Icons.edit_off : Icons.edit),
              onPressed: () {
                setState(() {
                  PublicData.isEditMode = !PublicData.isEditMode;
                });
              }),
        ],
        title: Text('Words'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async => fetchData(),
                  child: ListView.builder(
                    itemCount: _words.length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: _words[index],
                        child: WordsList(),
                      );
                    },
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditSheet(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void fetchData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Words>(context, listen: false).fetchWords();
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Theme.of(context).errorColor,
        behavior: SnackBarBehavior.floating,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddEditSheet(BuildContext ctx, {String id}) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          child: EditAddForm(
            id: id,
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }
}
