import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final List<dynamic> flights; // Déclaration du paramètre flights
  final List<String> countries; // Ajout des pays
  final String dateType;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? selectedMonth;
  final int numDays;
  final int numPeople;
  final String accommodationType;

  const ResultsScreen({
    super.key,
    required this.flights,
    required this.countries,
    required this.dateType,
    required this.startDate,
    required this.endDate,
    required this.selectedMonth,
    required this.numDays,
    required this.numPeople,
    required this.accommodationType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultats de recherche'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pays sélectionnés: ${countries.join(', ')}'),
            Text('Type de date: $dateType'),
            Text(
                'Dates: ${startDate?.toLocal().toString().split(' ')[0] ?? 'Non sélectionnées'} à ${endDate?.toLocal().toString().split(' ')[0] ?? 'Non sélectionnées'}'),
            Text(
                'Mois sélectionné: ${selectedMonth != null ? selectedMonth!.toLocal().toString().split(' ')[0] : 'Non sélectionné'}'),
            Text('Nombre de jours: $numDays'),
            Text('Nombre de personnes: $numPeople'),
            Text('Type d\'hébergement: $accommodationType'),
            // Affichage des résultats de vol
            Text('Résultats des vols:'),
            Expanded(
              child: ListView.builder(
                itemCount: flights.length,
                itemBuilder: (context, index) {
                  final flight = flights[index];
                  return ListTile(
                    title: Text(flight
                        .toString()), // Ajustez selon la structure de vos données
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
