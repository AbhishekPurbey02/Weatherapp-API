import 'package:flutter/material.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/services/weather_api_client.dart';
import 'package:weather_app/views/additional_information.dart';
import 'package:weather_app/views/current_weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Now lets test if everything work
  //we will call the api in the init state function
  WeatherApiClient client = WeatherApiClient();
  Weather? data;

  Future<void> getData() async {
    //lets try changing the city name
    data = await client.getCurrentWeather("california");
  }

  @override
  Widget build(BuildContext context) {
    // the frist thing that we are going to do is to create the UI of the App
    return Scaffold(
        backgroundColor: Color(0xFFf9f9f9),
        appBar: AppBar(
          backgroundColor: Color(0xFFf9f9f9),
          elevation: 0.0,
          title: const Text(
            "Weather App",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
            color: Colors.black,
          ),
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              //here we will display if we get data from the API
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //lets create custom widget for the App
                  currentWeather(Icons.wb_sunny_rounded, "${data!.temp}", "${data!.cityName}"),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Color(0xdd212121),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 20.0,
                  ),
                  //Now lets create the additional information widget
                  additionalInformation("${data!.wind}", "${data!.humidity}", "${data!.pressure}", "${data!.feels_like}"),
                  //Now that we have the UI ready
                  //Lets start integrating the API
                  //first lets start creating the model to store the data
                ],
              );
            }else if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container();
          },
        ));
  }
}
