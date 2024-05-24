import 'package:flutter/material.dart';
import 'package:heatstroke_app/models/models.dart';
import 'package:heatstroke_app/providers/db_provider.dart';
import 'package:heatstroke_app/providers/providers.dart';
import 'package:heatstroke_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ScrollDesignScreen extends StatelessWidget {
  const ScrollDesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    weatherProvider.getJsonData;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [.5, .5],
            colors: [
              Color(0xfffcedcc),
              Color(0xfffcedcc),
            ],
          ),
        ),
        child: PageView(
          scrollDirection: Axis.vertical,
          children: [
            _Screen1(
              weather: weatherProvider.actualClima,
              uvi: weatherProvider.uviActual,
            ),
            Screen2(),
          ],
        ),
      ),
    );
  }
}

class _Screen1 extends StatelessWidget {
  final Clima weather;
  final Uvi uvi;

  const _Screen1({super.key, required this.weather, required this.uvi});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //background image
        Background(),
        MainContent(
          weather: weather,
          uvi: uvi,
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}

class MainContent extends StatelessWidget {
  final Uvi uvi;
  final Clima weather;
  const MainContent({
    super.key,
    required this.weather,
    required this.uvi,
  });

  @override
  Widget build(BuildContext context) {
    DBProvider.db.database;

    const textStyle = TextStyle(
      fontSize: 50,
      fontWeight: FontWeight.bold,
      color: Color(0xffb58308),
    );
    const subtitleStyle = TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.bold,
      color: Color(0xffb58308),
    );
    final dayProvider = Provider.of<DayProvider>(context);
    final now = DateTime.now();
    final isLate = now.hour >= 18;

    return SafeArea(
      bottom: false,
      minimum: EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () async {
                  await DBProvider.db.deleteRentaById(1);
                  Navigator.pushReplacementNamed(context, 'Welcome');
                },
                icon: Icon(
                  Icons.delete_forever_outlined,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 00,
          ),
          Text('Temperatura: ', style: subtitleStyle),
          Text('${weather.temp.toStringAsFixed(1)}°', style: textStyle),
          Text(dayProvider.formattedDay.capitalize(), style: textStyle),
          Text('Húmedad: ${weather.humidity}%', style: subtitleStyle),
          if (!isLate)
            Text('Rayos UV: ${uvi.value.toStringAsFixed(0)}',
                style: subtitleStyle),
          Text('Presión atmosférica: ${weather.pressure} hPa',
              style: subtitleStyle),
          Expanded(child: Container()),
          SizedBox(
            height: 20,
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 200,
            color: Color(0xffb48307),
          ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff50c2dd),
      height: double.infinity,
      alignment: Alignment.topCenter,
      child: const Image(
        height: double.infinity,
        image: AssetImage('assets/scroll-1.png'),
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfff4af0c),
      child: Stack(
        children: [
          BackgroundPage2(),
          _HomeBody(),
        ],
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weather = weatherProvider.actualClima;
    final uvi = weatherProvider.uviActual;

    final recommendations = buildRecommendations(weather, uvi);
    final Future<PacienteModel?> pacienteFuture =
        DBProvider.db.getPacienteById(1);

    return FutureBuilder<PacienteModel?>(
      future: pacienteFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No se encontró el paciente'));
        } else {
          final paciente = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                PageTitle(
                  paciente: paciente,
                ),
                Table(
                  children: recommendations.map((recommendation) {
                    return TableRow(
                      children: [
                        recommendation,
                      ],
                    );
                  }).toList(),
                ),
                // Card Table
                // CardTable(),
              ],
            ),
          );
        }
      },
    );
  }
}
