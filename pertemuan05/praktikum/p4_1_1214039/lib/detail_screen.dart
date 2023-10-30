// import 'dart:math';

import 'package:flutter/material.dart ';
import 'package:p4_1_1214039/model/tourism_place.dart';

var iniFontCustom = const TextStyle(fontFamily: 'Staatliches');

class DetailScreen extends StatelessWidget {
  final TourismPlace place;

  const DetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Image.asset(place.imageAsset),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 16.0),
            child: Text(
              place.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30.0,
                fontFamily: 'Staatliches',
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const Icon(Icons.calendar_today),
                    const SizedBox(height: 8.0),
                    Text('Open Everyday', style: iniFontCustom),
                  ],
                ),
                const Column(
                  children: <Widget>[
                    Icon(Icons.access_time),
                    SizedBox(height: 8.0),
                    Text('09:00 - 20:00'),
                  ],
                ),
                const Column(
                  children: <Widget>[
                    Icon(Icons.monetization_on),
                    SizedBox(height: 8.0),
                    Text('Rp 20.000'),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Ranca Upas Ciwidey adalah kawasan bumi perkemahan di bawah pengelolaan perhutani. Tempat ini berada di kawasan wisata Bandung Selatan, satu lokasi dengan kawah putih, kolam Cimanggu dan situ Patenggang. Banyak hal yang bisa dilakukan di kawasan wisata ini, seperti berkemah, berinteraksi dengan rusa, sampai bermain di water park dan mandi air panas.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: place.imageUrls.map((url) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(url),
                  ),
                );
              }).toList(),
            ),
          ),
          // SizedBox(
          //   height: 150,
          //   child: ListView(
          //     scrollDirection: Axis.horizontal,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.all(4.0),
          //         child: ClipRRect(
          //           borderRadius: BorderRadius.circular(10),
          //           child: Image.network(
          //               'https://cdn.idntimes.com/content-images/post/20201106/19437160-453398458365585-5644109604204838912-n-c585ba7c280d219489189654315931ac.jpg'),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(4.0),
          //         child: ClipRRect(
          //           borderRadius: BorderRadius.circular(10),
          //           child: Image.network(
          //               'https://cdn.idntimes.com/content-images/post/20201106/34091980-2204188269801480-248274445720879104-n-84408b484e10adec7c35816abaacec28.jpg'),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(4.0),
          //         child: ClipRRect(
          //           borderRadius: BorderRadius.circular(10),
          //           child: Image.network(
          //               'https://cdn.idntimes.com/content-images/post/20201106/39408216-228473327819821-1612494975352700928-n-befa144ceeb67ba9049e6c21964f3034.jpg'),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    ));
  }
}
