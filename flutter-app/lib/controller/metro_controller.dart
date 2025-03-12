import 'package:get/get.dart';
import '../models/metro_station.dart';

class MetroController extends GetxController {
  final RxList<MetroStation> stations = <MetroStation>[
    MetroStation(name: "New El-Marg", line: 1),
    MetroStation(name: "El-Marg", line: 1),
    MetroStation(name: "Ezbet El-Nakhl", line: 1),
    MetroStation(name: "Ain Shams", line: 1),
    MetroStation(name: "El-Matareyya", line: 1),
    MetroStation(name: "Helmeyet El-Zaitoun", line: 1),
    MetroStation(name: "Hadayeq El-Zaitoun", line: 1),
    MetroStation(name: "Saray El-Qobba", line: 1),
    MetroStation(name: "Hammamat El-Qobba", line: 1),
    MetroStation(name: "Kobri El-Qobba", line: 1),
    MetroStation(name: "Manshiet El-Sadr", line: 1),
    MetroStation(name: "El-Demerdash", line: 1),
    MetroStation(name: "Ghamra", line: 1),
    MetroStation(name: "Al-Shohadaa", line: 1),
    MetroStation(name: "Orabi", line: 1),
    MetroStation(name: "Nasser", line: 1),
    MetroStation(name: "Sadat", line: 1),
    MetroStation(name: "Saad Zaghloul", line: 1),
    MetroStation(name: "Sayeda Zeinab", line: 1),
    MetroStation(name: "El-Malek El-Saleh", line: 1),
    MetroStation(name: "Mar Girgis", line: 1),
    MetroStation(name: "El-Zahraa", line: 1),
    MetroStation(name: "Dar El-Salam", line: 1),
    MetroStation(name: "Hadayeq El-Maadi", line: 1),
    MetroStation(name: "Maadi", line: 1),
    MetroStation(name: "Sakanat El-Maadi", line: 1),
    MetroStation(name: "Tora El-Asmant", line: 1),
    MetroStation(name: "El-Maasara", line: 1),
    MetroStation(name: "Hadayeq Helwan", line: 1),
    MetroStation(name: "Wadi Hof", line: 1),
    MetroStation(name: "Helwan University", line: 1),
    MetroStation(name: "Ain Helwan", line: 1),
    MetroStation(name: "Helwan", line: 1),
    MetroStation(name: "Shubra El-Kheima", line: 2),
    MetroStation(name: "Kolleyet El-Zeraa", line: 2),
    MetroStation(name: "El-Masara", line: 2),
    MetroStation(name: "Rod El-Farag", line: 2),
    MetroStation(name: "St. Teresa", line: 2),
    MetroStation(name: "Khalafawy", line: 2),
    MetroStation(name: "Masarra", line: 2),
    MetroStation(name: "Al-Shohadaa", line: 2),
    MetroStation(name: "Ataba", line: 2),
    MetroStation(name: "Nasser", line: 2),
    MetroStation(name: "Sadat", line: 2),
    MetroStation(name: "Opera", line: 2),
    MetroStation(name: "Dokki", line: 2),
    MetroStation(name: "El Bohoth", line: 2),
    MetroStation(name: "Cairo University", line: 2),
    MetroStation(name: "Faisal", line: 2),
    MetroStation(name: "Giza", line: 2),
    MetroStation(name: "Omm El-Masryeen", line: 2),
    MetroStation(name: "Sakiat Mekky", line: 2),
    MetroStation(name: "El-Mounib", line: 2),
    MetroStation(name: "Adly Mansour", line: 3),
    MetroStation(name: "El-Nozha", line: 3),
    MetroStation(name: "Hisham Barakat", line: 3),
    MetroStation(name: "Omar Ibn El-Khattab", line: 3),
    MetroStation(name: "Kobri El-Qobba", line: 3),
    MetroStation(name: "Abassiya", line: 3),
    MetroStation(name: "Fair Zone", line: 3),
    MetroStation(name: "El-Ahram", line: 3),
    MetroStation(name: "Haroun", line: 3),
    MetroStation(name: "Alf Maskan", line: 3),
    MetroStation(name: "Cairo International Airport", line: 3),
    MetroStation(name: "Bab El-Shaaria", line: 3),
    MetroStation(name: "Attaba", line: 3),
    MetroStation(name: "Nasser", line: 3),
    MetroStation(name: "Maspero", line: 3),
    MetroStation(name: "Zamalek", line: 3),
    MetroStation(name: "Kit Kat", line: 3),
  ].obs;
  final startStation = ''.obs;
  final endStation = ''.obs;
  RxBool isSameStation() {
    return (startStation.value == endStation.value).obs;
  }

  List<String> searchStations(String query) {
    return stations
        .where((station) =>
            station.name.toLowerCase().contains(query.toLowerCase()))
        .map((station) => station.name)
        .toList();
  }
}
