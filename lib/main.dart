import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'second_page.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      title: 'Flutter Demo',
      home:  MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> data = [];
  String selectedTitle = '';
  bool isLoading = true; // Added this line for tracking loading state

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) => {
      FlutterNativeSplash.remove()
    });
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Set loading state to true when fetching data
    });

    final response = await http.get(
      Uri.parse(
          'https://zvz.com.mm/api/test/none/sence/category'), // Replace with your API endpoint
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
      appBar: AppBar(
        title: Text(
          "Health Blog",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
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
            : ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return InkWell(
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (BuildContext context) => SecondPage(
                      title: item['title'], id: item["id"]),
                ));
              },
              child: Card(
                elevation: 4,
                margin: EdgeInsets.fromLTRB(10, 7, 10, 5),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(item['title']),
                    leading: Image.network(item['image']),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


