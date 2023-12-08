import 'package:flutter/material.dart';
import 'home_second.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Home'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Colors.amber,
                  width: 2.0,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        'images/ulbi.png',
                        width: 200,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Selamat Datang',
                    style: TextStyle(fontSize: 23),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Ini adalah tugas Assignment Tengah Semester saya dari mata kuliah Mobile Programming. Tugas ini dibuat menggunakan Flutter dan Dart. \nTekan tombol dibawah untuk melihat profile saya.',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NextPage()),
                );
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Selamat Datang'),
                    content: const Text('Ini adalah halaman Profile'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Baiklah'),
                      ),
                    ],
                  ),
                );
              },
              style: ButtonStyle(
                side: MaterialStateProperty.all(
                  const BorderSide(
                    color: Colors.amber,
                    width: 2.0,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(Colors.black),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              child: const Text(
                'Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
