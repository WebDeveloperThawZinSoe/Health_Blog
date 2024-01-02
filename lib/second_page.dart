import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'third_page.dart';

class SecondPage extends StatefulWidget {
  final String title;
  final int id;
  const SecondPage({Key? key, required this.title, required this.id}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<Map<String, dynamic>> data = [];
  bool isLoading = true; // Added this line for tracking loading state
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Set loading state to true when fetching data
    });
    final response = await http.get(
      Uri.parse('https://zvz.com.mm/api/test/none/sence/category/${widget.id}'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final dataList = jsonData['data'];

      setState(() {
        data = List<Map<String, dynamic>>.from(dataList);
        isLoading = false; // Set loading state to false after data is fetched
      });
    } else {
      // Handle error
      print('Failed to load data');
      setState(() {
        isLoading = false; // Set loading state to false in case of an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Padding(
      //     padding: const EdgeInsets.fromLTRB(0, 17, 0, 0),
      //     child: Text(
      //       widget.title,
      //       style: TextStyle(color: Colors.white, fontSize: 13),
      //     ),
      //   ),
      //   backgroundColor: Colors.blue,
      //   iconTheme: IconThemeData(color: Colors.white),
      // ),
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text(
            widget.title,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          fetchData();
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: isLoading
            ? Center(
          // Display a loading indicator while data is being fetched
          child: CircularProgressIndicator(),
        )
            :  GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Adjust the number of columns as needed
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return InkWell(
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (BuildContext context) => ThirdPage(
                    name: item['name'],
                    id: item["id"],
                    image:item["image"],
                    description:item["description"]
                  ),
                ));
              },
              child: Card(
                elevation: 4,
                margin: EdgeInsets.all(8),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      item['image'],
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(item['name']),
                    ),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
