// Import the BaseEntity class from another file
import 'BaseEntity.dart';

// Define a class for an Experiment that extends the BaseEntity class
class Experiment extends BaseEntity {
  // Declare a final String property for the name of the experiment
  final String name;

  // Declare a final String property for the thumbnail of the experiment
  final String? thumbnail;

  // Declare a final String property for the id of the experiment
  final String id;

  // Define a constructor for the class that takes five required arguments
  Experiment(
      {
      // Call the superclass constructor with the required arguments
      required super.createdBy,
      required this.name,
      required this.thumbnail,
      required this.id,
      required super.createdDate});

  // Define a factory constructor that takes a Map<String, dynamic> as an argument
  factory Experiment.fromJson(Map<String, dynamic> json) {
    // Return a new instance of the Experiment class with the properties initialized from the JSON data
    return Experiment(
        createdBy: json['createdBy'],
        name: json['name'],
        thumbnail: json['thumbnail'],
        id: json['id'],
        createdDate: DateTime.parse(json['createdDate']));
  }
}