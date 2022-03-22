import 'package:flutter/material.dart';

class OptionsBar extends StatefulWidget {
  final Function setSortOrder;

  const OptionsBar(this.setSortOrder, {Key? key}) : super(key: key);

  @override
  State<OptionsBar> createState() => _OptionsBarState();
}

class _OptionsBarState extends State<OptionsBar> {
  String? _sortOrder = 'Recent';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Sort by: ',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white54),
              ),
              DropdownButton<String>(
                underline: Container(),
                value: _sortOrder,
                iconEnabledColor: Colors.white54,
                items: const [
                  DropdownMenuItem<String>(
                    child: Text('Recent'),
                    value: 'Recent',
                  ),
                  DropdownMenuItem<String>(
                    child: Text('Oldest'),
                    value: 'Oldest',
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    _sortOrder = value!;
                  });
                  widget.setSortOrder(_sortOrder);
                },
              ),
            ],
          ),
        ),
        const Divider(
          color: Color.fromRGBO(255, 255, 255, .5),
          height: 1,
        ),
      ],
    );
  }
}
