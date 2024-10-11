import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'results_screen.dart';
import 'api_service.dart'; // Importez votre ApiService ici
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(
      fileName:
          "C:/Users/thoma/travel_planner_app/.env"); // Assurez-vous que le fichier est bien chargé
  runApp(const TravelPlannerApp());
}

class TravelPlannerApp extends StatelessWidget {
  const TravelPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Planner',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/results': (context) =>
            const ResultsScreenWrapper(), // Modifié pour utiliser ResultsScreenWrapper
      },
    );
  }
}

// Classe pour gérer la logique de récupération des vols
class ResultsScreenWrapper extends StatelessWidget {
  const ResultsScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupérer les arguments passés depuis HomeScreen
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Utiliser ApiService pour récupérer les vols
    final apiService = ApiService();

    return FutureBuilder<List<dynamic>>(
      future: apiService.fetchFlights(
        args['airports'].first, // Premier aéroport de départ
        'CDG', // Remplacez par votre code d'aéroport de destination
        args['startDate'] ?? DateTime.now(),
        args['endDate'] ?? DateTime.now().add(const Duration(days: 5)),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else {
          // Si les vols sont récupérés avec succès
          final flights = snapshot.data ?? [];

          // Passer les résultats des vols à ResultsScreen
          return ResultsScreen(
            flights: flights, // Passer les données de vol ici
            // Vous pouvez également passer d'autres arguments si nécessaire
            countries: args['countries'], // Ajoutez cette ligne si nécessaire
            dateType: args['dateType'],
            startDate: args['startDate'],
            endDate: args['endDate'],
            selectedMonth: args['selectedMonth'],
            numDays: args['numDays'],
            numPeople: args['numPeople'],
            accommodationType: args['accommodationType'],
          );
        }
      },
    );
  }
}
