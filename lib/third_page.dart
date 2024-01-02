import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'third_page.dart';
import 'package:marquee/marquee.dart';


class ThirdPage extends StatefulWidget {
  final String name;
  final int  id;
  final String image;
  final String description;
  const ThirdPage({super.key,  required this.name, required this.id, required this.image, required this.description});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text(
            widget.name,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
              Image.network(widget.image),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,10,0,10),
                child: Text(widget.name,style: TextStyle(fontSize: 18),),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(widget.description),
              )
          ],
        ),
      ),
    );
  }
}

