import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:open_file/open_file.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyInputValidations extends StatefulWidget {
  const MyInputValidations({super.key});

  @override
  State<MyInputValidations> createState() => _MyInputValidationsState();
}

class _MyInputValidationsState extends State<MyInputValidations> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerNama = TextEditingController();
  final TextEditingController _controllerTelepon = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();

  final List<Map<String, dynamic>> _myDataList = [];

  Map<String, dynamic>? editedData;
  bool isEditing = false;

  DateTime _dueDate = DateTime.now();
  final currentDate = DateTime.now();

  Color _currentColor = Colors.black;

  Color _calculateTextColor(Color color) {
    return (color.computeLuminance() > 0.5) ? Colors.black : Colors.white;
  }

  Color _calculateBorderColor(Color color) {
    if (color == Colors.black) {
      return Colors.amber;
    }
    return (color.computeLuminance() > 0.5) ? Colors.black : Colors.white;
  }

  String? _datefile;

  @override
  void dispose() {
    _controllerNama.dispose();
    _controllerTelepon.dispose();
    _controllerDate.dispose();
    super.dispose();
  }

  void _addData() {
    final data = {
      'nama': _controllerNama.text,
      'telepon': _controllerTelepon.text,
      'tanggal': _controllerDate.text,
      'color': _currentColor.value,
      'file': _datefile,
    };
    setState(() {
      if (editedData != null) {
        editedData!['nama'] = data['nama'];
        editedData!['telepon'] = data['telepon'];
        editedData!['tanggal'] = data['tanggal'];
        editedData!['color'] = data['color'];
        _datefile = null;
        isEditing = false;
        editedData = null;
      } else {
        _myDataList.add(data);
      }
      _controllerNama.clear();
      _controllerTelepon.clear();
      _controllerDate.clear();
      _currentColor = Colors.black;
      _datefile = null;
    });
  }

  void _editData(Map<String, dynamic> data) {
    setState(() {
      _controllerNama.text = data['nama'];
      _controllerTelepon.text = data['telepon'];
      _controllerDate.text = data['tanggal'];
      _currentColor = Color(data['color'] ?? Colors.black.value);
      _datefile = data['file'];
      editedData = data;
      isEditing = true;
    });
  }

  void _cancelEdit() {
    setState(() {
      _controllerNama.clear();
      _controllerTelepon.clear();
      _controllerDate.clear();
      _currentColor = Colors.black;
      _datefile = null;
      editedData = null;
      isEditing = false;
    });
  }

  void _deleteData(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Data'),
          content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _myDataList.remove(data);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  String? _validateNama(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }

    if (!RegExp(r'^[A-Z]').hasMatch(value)) {
      return 'Nama harus diawali dengan huruf kapital';
    }

    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
      return 'Nama hanya boleh mengandung huruf';
    }

    List<String> words = value.split(' ');
    if (words.length < 2 || words.any((word) => word.isEmpty)) {
      return 'Nama harus terdiri dari minimal dua kata';
    }

    if (_myDataList.any((data) => data['nama'] == value)) {
      return 'Nama tidak boleh sama';
    }

    return null;
  }

  String? _validateTelepon(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Nomor telepon hanya boleh mengandung karakter angka';
    }

    String cleanedValue = value.replaceAll(RegExp(r'\D'), '');

    if (!cleanedValue.startsWith('0')) {
      return 'Nomor telepon harus diawali dengan 0';
    }

    if (cleanedValue.length < 8) {
      return 'Nomor telepon minimal 8 karakter';
    }

    if (cleanedValue.length > 13) {
      return 'Nomor telepon maksimal 13 karakter';
    }

    if (_myDataList.any((data) => data['telepon'] == value)) {
      return 'Nomor telepon tidak boleh sama';
    }

    return null;
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal tidak boleh kosong';
    }

    return null;
  }

  void _cancelColor() {
    setState(() {
      if (editedData != null) {
        _currentColor = Color(editedData!['color'] ?? Colors.black.value);
      } else {
        _currentColor = Colors.black;
      }
    });
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _datefile = pickedFile.path;
      });
    }
  }

  // void _pickFile() async {
  //   final result = await FilePicker.platform.pickFiles();
  //   if (result == null) return;

  //   final file = result.files.single;
  //   _openFile(file);

  //   setState(() {
  //     _datefile = file.name;
  //   });
  // }

  // void _openFile(PlatformFile file) async {
  //   final filePath = file.path;
  //   await OpenFile.open(filePath);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Form Contact List'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const SizedBox(height: 5),
              buildNama(context),
              const SizedBox(height: 20),
              buildTelepon(context),
              const SizedBox(height: 20),
              buildDatePicker(context),
              const SizedBox(height: 20),
              buildColorPicker(context),
              const SizedBox(height: 20),
              buildFilePicker(context),
              const SizedBox(height: 20),
              buildSubmitButton(context),
              const SizedBox(height: 50),
              const Center(
                child: Text(
                  'List Contact',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              buildListData(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNama(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controllerNama,
          validator: _validateNama,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
          ],
          decoration: const InputDecoration(
            hintText: 'Input Nama Lengkap',
            labelText: 'Nama Lengkap',
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amber),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amber),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            fillColor: Colors.black,
            filled: true,
          ),
        ),
      ],
    );
  }

  Widget buildTelepon(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controllerTelepon,
          validator: _validateTelepon,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            hintText: 'Input Nomor Telepon',
            labelText: 'Nomor Telepon',
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amber),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amber),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            fillColor: Colors.black,
            filled: true,
          ),
        ),
      ],
    );
  }

  Widget buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controllerDate,
          validator: _validateDate,
          keyboardType: TextInputType.number,
          // readOnly: true,
          decoration: InputDecoration(
            hintText: 'Input Tanggal Lahir',
            labelText: 'Tanggal Lahir',
            labelStyle: const TextStyle(color: Colors.white),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amber),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amber),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            fillColor: Colors.black,
            filled: true,
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: currentDate,
                  firstDate: DateTime(1990),
                  lastDate: DateTime(currentDate.year + 5),
                );
                setState(() {
                  if (selectedDate != null) {
                    _dueDate = selectedDate;
                    _controllerDate.text =
                        DateFormat('dd-MM-yyyy').format(_dueDate);
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(_currentColor),
              side: MaterialStateProperty.all(
                BorderSide(
                  color: _calculateBorderColor(_currentColor),
                  width: 2.0,
                ),
              ),
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('Processing Data'),
                //   ),
                // );
                Future.delayed(const Duration(seconds: 2), () {
                  _addData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data berhasil ditambahkan'),
                    ),
                  );
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Isi Form dengan benar'),
                  ),
                );
              }
            },
            child: Text(
              isEditing ? 'Update' : 'Submit',
              style: TextStyle(
                color: _calculateTextColor(_currentColor),
              ),
            ),
          ),
        ),
        SizedBox(width: isEditing ? 16 : 0),
        if (isEditing)
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
              side: MaterialStateProperty.all(
                const BorderSide(
                  color: Colors.red,
                  width: 2.0,
                ),
              ),
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            onPressed: () {
              setState(() {
                _cancelEdit();
              });
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  Widget buildListData(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _myDataList.isNotEmpty ? Colors.black : Colors.transparent,
        border: Border.all(
          color: _myDataList.isNotEmpty ? Colors.amber : Colors.transparent,
          width: 1.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _myDataList.length,
        itemBuilder: (context, index) {
          final data = _myDataList[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.transparent,
                  ),
                  child: data['file'] != null &&
                          (data['file']!.toLowerCase().endsWith('.jpg') ||
                              data['file']!.toLowerCase().endsWith('.jpeg') ||
                              data['file']!.toLowerCase().endsWith('.png'))
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.file(
                            File(data['file']!),
                            fit: BoxFit.cover,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['nama'] ?? ''),
                      Text(data['telepon'] ?? ''),
                      Text(data['tanggal'] ?? ''),
                      Container(
                        width: 100,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Color(data['color'] ?? Colors.black.value),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _editData(data);
                    });
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _deleteData(data);
                    });
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildColorPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color'),
        const SizedBox(height: 10),
        // Container(
        //   height: 100,
        //   width: double.infinity,
        //   color: _currentColor,
        // ),
        // const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(_currentColor),
              side: MaterialStateProperty.all(
                BorderSide(
                  color: _calculateBorderColor(_currentColor),
                  width: 2.0,
                ),
              ),
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            child: Text(
              'Pick Color',
              style: TextStyle(
                color: _calculateTextColor(_currentColor),
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Pick your color'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: _currentColor,
                        onColorChanged: (color) {
                          setState(() {
                            _currentColor = color;
                          });
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Save'),
                      ),
                      TextButton(
                        onPressed: () {
                          _cancelColor();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildFilePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pick Files'),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(_currentColor),
              side: MaterialStateProperty.all(
                BorderSide(
                  color: _calculateBorderColor(_currentColor),
                  width: 2.0,
                ),
              ),
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            child: Text(
              'Pick and Open File',
              style: TextStyle(
                color: _calculateTextColor(_currentColor),
              ),
            ),
            onPressed: () {
              _pickImage();
            },
          ),
        ),
        if (_datefile != null) Text('File Name: $_datefile'),
      ],
    );
  }
}
