import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import '../../provider/words.dart';

class EditAddForm extends StatefulWidget {
  final String? id;
  EditAddForm({this.id});

  @override
  _EditAddFormState createState() => _EditAddFormState();
}

class _EditAddFormState extends State<EditAddForm> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isEdit = false;
  bool _isLoading = false;
  late Word _word;

  @override
  void initState() {
    if (widget.id != null) {
      _isEdit = true;
      _word = Provider.of<Words>(context, listen: false).findById(widget.id);
    } else {
      _word = Word(id: null, en: '', ar: '');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Card(
          elevation: 5,
          margin: EdgeInsets.all(8),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    initialValue: _word.en,
                    decoration: InputDecoration(labelText: 'English Word'),
                    onSaved: (val) => _word.en = val,
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      if (val!.isEmpty) return 'Please Enter a Word';
                      return null;
                    },
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      initialValue: _word.ar,
                      decoration: InputDecoration(labelText: 'Arabic Word'),
                      onSaved: (val) => _word.ar = val,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val!.isEmpty) return 'Please Enter a Word';
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            child: _isEdit ? Text('Edit') : Text('Add'),
                            onPressed: () => _saveForm(),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveForm() async {
    setState(() {
      _isLoading = true;
    });
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    _formKey.currentState!.save();
    try {
      _isEdit
          ? await Provider.of<Words>(context, listen: false)
              .updateWord(_word, widget.id)
          : await Provider.of<Words>(context, listen: false).addWord(_word);
      Navigator.of(context).pop();
    } catch (e) {
      // _scaffoldKey.currentState.showSnackBar
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(SnackBar(
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
}
