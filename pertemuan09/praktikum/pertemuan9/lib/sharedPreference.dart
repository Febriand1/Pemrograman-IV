import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyShared extends StatefulWidget {
  const MyShared({super.key});

  @override
  State<MyShared> createState() => _MySharedState();
}

class _MySharedState extends State<MyShared> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _displayValueController = TextEditingController();

  String _storedValue = '';

  @override
  void initState() {
    super.initState();
    _getValue();
    _displayValueController.text = _storedValue;
  }

  void _saveValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String valueToSave = _textEditingController.text;
    prefs.setString('myKey', valueToSave);
    _textEditingController.clear();
    setState(() {});
  }

  void _getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedValue = prefs.getString('myKey') ?? 'null';
    });
    _displayValueController.text = _storedValue;
  }

  void _deleteValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('myKey');
    _getValue();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Preferences'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    _saveValue();
                  },
                  child: const SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text('Save'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _displayValueController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    _getValue();
                  },
                  child: const SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text('Get Value'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    _deleteValue();
                  },
                  child: const SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text('Delete Value'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
