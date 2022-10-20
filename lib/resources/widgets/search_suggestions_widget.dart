import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuggestionsWidget extends StatelessWidget{
  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  const SuggestionsWidget({Key key, this.suggestions, this.query, this.onSelected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: suggestions.length,
        itemBuilder: (BuildContext context, int index){
        return ListTile(
          leading: (query.isEmpty) ? const Icon(Icons.history) : const Icon(null),
          title: Text(suggestions[index]),
          onTap: () => onSelected(suggestions[index]),
        );
        }
    );
  }

}