import 'package:flutter/material.dart';
import 'api_service.dart'; // Assurez-vous que le chemin est correct

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> selectedCountries = [];
  int numPeople = 1;
  String accommodationType = 'Hotel';
  String dateType = 'precise'; // Option sélectionnée pour les dates
  DateTime? startDate;
  DateTime? endDate;
  DateTime? selectedMonth;
  int numDays = 0;
  List<String> selectedAirports = [];

  final ApiService apiService = ApiService(); // Instance de ApiService

  // Fonction pour sélectionner une date précise
  void _selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 5)),
      ),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  // Fonction pour sélectionner un mois
  void _selectMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year, DateTime.now().month,
          1), // Premier jour du mois actuel
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2100, 12, 31),
      // Ne permettre que la sélection du premier jour de chaque mois
      selectableDayPredicate: (DateTime date) {
        return date.day == 1; // Seul le premier jour du mois est sélectionnable
      },
      helpText: 'Sélectionner un mois', // Texte d'aide à afficher
      fieldLabelText: 'Mois',
    );
    if (picked != null) {
      setState(() {
        selectedMonth = picked;
      });
    }
  }

  // Interface principale
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planifier votre voyage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sélectionnez un pays:'),
            TextField(
              decoration: const InputDecoration(hintText: 'Entrer un pays'),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    selectedCountries.add(value);
                  });
                }
              },
            ),
            Wrap(
              children: selectedCountries.map((country) {
                return Chip(
                  label: Text(country),
                  onDeleted: () {
                    setState(() {
                      selectedCountries.remove(country);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text('Nombre de personnes:'),
            TextField(
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(hintText: 'Nombre de personnes'),
              onChanged: (value) {
                setState(() {
                  numPeople = int.tryParse(value) ?? 1; // Valeur par défaut à 1
                });
              },
            ),
            const SizedBox(height: 20),
            const Text('Sélection du type de dates :'),
            Row(
              children: [
                Radio(
                  value: 'precise',
                  groupValue: dateType,
                  onChanged: (value) {
                    setState(() {
                      dateType = value.toString();
                    });
                  },
                ),
                const Text('Dates précises'),
                Radio(
                  value: 'month',
                  groupValue: dateType,
                  onChanged: (value) {
                    setState(() {
                      dateType = value.toString();
                    });
                  },
                ),
                const Text('Mois et nombre de jours'),
              ],
            ),
            const SizedBox(height: 20),
            if (dateType == 'precise') ...[
              const Text('Sélectionnez une plage de dates :'),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  startDate == null || endDate == null
                      ? 'Choisir une plage de dates'
                      : 'Du ${startDate.toString().substring(0, 10)} au ${endDate.toString().substring(0, 10)}',
                ),
              ),
            ] else ...[
              const Text('Sélectionnez un mois :'),
              ElevatedButton(
                onPressed: () => _selectMonth(context),
                child: Text(selectedMonth == null
                    ? 'Choisir un mois'
                    : 'Mois: ${selectedMonth.toString().substring(0, 7)}'),
              ),
              const SizedBox(height: 20),
              const Text('Nombre de jours :'),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Nombre de jours'),
                onChanged: (value) {
                  setState(() {
                    numDays = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ],
            const SizedBox(height: 20),
            const Text('Type d\'hébergement:'),
            Row(
              children: [
                Radio(
                  value: 'Hotel',
                  groupValue: accommodationType,
                  onChanged: (value) {
                    setState(() {
                      accommodationType = value.toString();
                    });
                  },
                ),
                const Text('Hôtel'),
                Radio(
                  value: 'Room',
                  groupValue: accommodationType,
                  onChanged: (value) {
                    setState(() {
                      accommodationType = value.toString();
                    });
                  },
                ),
                const Text('Chambre dans logement'),
                Radio(
                  value: 'Apartment',
                  groupValue: accommodationType,
                  onChanged: (value) {
                    setState(() {
                      accommodationType = value.toString();
                    });
                  },
                ),
                const Text('Appartement seul'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Aéroports de départ :'),
            TextField(
              decoration: const InputDecoration(
                  hintText: 'Entrer un ou plusieurs aéroports'),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    selectedAirports.add(value);
                  });
                }
              },
            ),
            Wrap(
              children: selectedAirports.map((airport) {
                return Chip(
                  label: Text(airport),
                  onDeleted: () {
                    setState(() {
                      selectedAirports.remove(airport);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Vous pouvez mettre ici la logique de recherche des vols
                  // par exemple avec apiService
                  List<dynamic> flights = [];

                  if (dateType == 'precise' &&
                      startDate != null &&
                      endDate != null) {
                    try {
                      flights = await apiService.fetchFlights(
                        selectedAirports.isNotEmpty
                            ? selectedAirports.first
                            : 'CDG', // Utiliser le premier aéroport ou un aéroport par défaut
                        selectedCountries.isNotEmpty
                            ? selectedCountries.first
                            : 'JFK', // Utiliser le premier pays ou une destination par défaut
                        startDate!,
                        endDate!,
                      );
                    } catch (e) {
                      print(e); // Affichez l'erreur dans la console
                    }
                  }

                  // Navigation vers l'écran des résultats
                  Navigator.pushNamed(context, '/results', arguments: {
                    'countries': selectedCountries, // Envoie la liste des pays
                    'dateType': dateType,
                    'startDate': startDate,
                    'endDate': endDate,
                    'selectedMonth': selectedMonth,
                    'numDays': numDays,
                    'numPeople': numPeople,
                    'accommodationType': accommodationType,
                    'airports':
                        selectedAirports, // Envoie la liste des aéroports
                    'flights': flights, // Envoie les résultats des vols
                  });
                },
                child: const Text('Rechercher'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
