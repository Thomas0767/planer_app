import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String clientId;
  final String clientSecret;
  String? accessToken;

  // Constructeur avec vérification des variables d'environnement
  ApiService()
      : clientId = dotenv.env['AMADEUS_CLIENT_ID'] ?? '',
        clientSecret = dotenv.env['AMADEUS_CLIENT_SECRET'] ?? '' {
    // Vérifie si les variables d'environnement sont bien initialisées
    if (clientId.isEmpty || clientSecret.isEmpty) {
      throw Exception(
          'Les variables d\'environnement AMADEUS_CLIENT_ID et AMADEUS_CLIENT_SECRET ne sont pas définies.');
    }
  }

  // Méthode pour obtenir un token d'accès
  Future<void> authenticate() async {
    final response = await http.post(
      Uri.parse('https://test.api.amadeus.com/v1/security/oauth2/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'client_credentials',
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      accessToken = data['access_token'];
    } else {
      throw Exception('Échec de l\'authentification: ${response.statusCode}');
    }
  }

  // Méthode pour rechercher des vols
  Future<List<dynamic>> fetchFlights(
      String departureAirport,
      String destinationAirport,
      DateTime departureDate,
      DateTime returnDate) async {
    // Authentifier si le token d'accès est manquant ou expiré
    if (accessToken == null) {
      await authenticate();
    }

    final url =
        Uri.parse('https://test.api.amadeus.com/v2/shopping/flight-offers'
            '?originLocationCode=$departureAirport'
            '&destinationLocationCode=$destinationAirport'
            '&departureDate=${departureDate.toIso8601String().split('T')[0]}'
            '&returnDate=${returnDate.toIso8601String().split('T')[0]}'
            '&adults=1');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Échec du chargement des vols: ${response.statusCode}');
    }
  }
}
