import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import '../../models/public_data.dart';

// Providers
import '../../provider/words.dart';

// Widgets
import './edit_add_form.dart';

class WordsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Word _word = Provider.of<Word>(context);
    return Card(
      elevation: 8,
      child: ListTile(
        trailing: !PublicData.isEditMode
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () =>
                          _showAddEditSheet(context, id: _word.id)),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.grey,
                  ),
                  IconButton(
                      icon: Icon(Icons.delete_outline),
                      onPressed: () =>
                          Provider.of<Words>(context, listen: false)
                              .deleteWord(_word.id)),
                ],
              ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _word.en!,
            ),
            Text(
              _word.ar!,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEditSheet(BuildContext ctx, {String? id}) {
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
