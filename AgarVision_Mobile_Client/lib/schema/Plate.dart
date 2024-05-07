import 'package:uuid/uuid.dart';
// Import statement for BaseEntity class, presumably a base class for database entities.
import 'package:agar_vision/schema/BaseEntity.dart';

// Definition of a Plate class which inherits from BaseEntity.
class Plate extends BaseEntity {
  // Properties of the Plate class.
  final String image; // Immutable string to store the image URL or identifier.
  String type; // Mutable string to indicate the type of plate.
  List<String> bacteria; // List of bacteria species present on the plate.
  List<PlatePart> parts; // List of different parts or sections of the plate.
  String plateId;
  // Constructor for Plate class with required fields initialized.
  Plate(
      {required this.image,
      required this.parts,
      required this.bacteria,
      required createdBy, // createdBy inherited from BaseEntity.
      required createdDate, // createdDate inherited from BaseEntity.
      required this.type,
      required this.plateId})
      : super(
            createdBy: createdBy,
            createdDate: createdDate); // Call to the base class constructor.

  // Factory constructor to create a Plate instance from JSON data.
  factory Plate.fromJson(Map<String, dynamic> json) {
    // Returns a new Plate object populated from the JSON map.
    return Plate(
        image: json['image'],
        parts: PlatePart.fromArrayJson(json['parts']),
        bacteria: (json['bacteria'] as List).map((e) => e.toString()).toList(),
        createdDate: DateTime.parse(json['createdDate']),
        createdBy: json['createdBy'],
        type: json['type'],
        plateId: json['id']);
  }

  // Getter to retrieve image URL. Currently returns null, indicating it might be overridden or yet to be implemented.
  String? get imageUrl => null;

  // Method to convert a Plate instance to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'bacteria': bacteria,
      'parts': parts.map((e) => e.toJson()).toList(),
      'type': type
    };
  }
}

// Definition of the PlatePart class.
class PlatePart {
  final String
      example; // Immutable string to store example identifier or description.
  final double
      dilution; // Immutable double value indicating the dilution factor.
  final CountingMethod
      countMethod; // Immutable enumeration for counting method.
  List<int> dropsCount = []; // Mutable list to store count of drops per part.

  // Constructor for initializing PlatePart.
  PlatePart(
      {required this.example,
      required this.dilution,
      required this.countMethod,
      this.dropsCount = const []});

  static List<PlatePart> fromArrayJson(List<dynamic>? array) {
    // Handling 'parts' list in JSON, converting each entry to a PlatePart instance.
    if(array==null)
      return [];
    return (array).map((e) {
      return PlatePart.fromJson(e);
    }).toList();
  }
  // Factory constructor to create a PlatePart instance from JSON data.
  PlatePart.fromJson(Map<String, dynamic> json)
      : example = json['example'],
        dilution = json['dilution'],
        countMethod = CountingMethod.fromString(json['dilution']),
        dropsCount = PlatePart.getDropsCount(json);

  // Method to convert a PlatePart instance to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'example': example,
      'dilution': dilution.toString(),
      'countMethod': countMethod.value,
      'dropsCount': dropsCount
    };
  }

  // Static method to get drops count from JSON data.
  static List<int> getDropsCount(Map<String, dynamic> json) {
    if (json['dropsCount'] == null) return List<int>.empty(growable: true);
    return (json['dropsCount'] as List<dynamic>).map((e) {
      return int.tryParse(e.toString()) != null ? int.parse(e.toString()) : -1;
    }).toList();
  }
}

// Enumeration to represent different counting methods.
enum CountingMethod {
  Automatic("automatic"), // Automated counting.
  Manual("manual"), // Manual counting.
  Deshe("deshe"); // Deshe method, specific to the context.

  const CountingMethod(
      this.value); // Constructor to initialize with a specific value.

  final String value; // Property to hold the enumeration value as string.

  // Static method to parse string into a corresponding CountingMethod enum.
  static CountingMethod fromString(Object val) {
    String value = val.toString();
    switch (value.toLowerCase()) {
      case 'automatic':
        return CountingMethod.Automatic;
      case 'manual':
        return CountingMethod.Manual;
      case 'deshe':
        return CountingMethod.Deshe;
      default:
        return CountingMethod
            .Automatic; // Defaults to Automatic if not matched.
    }
  }
}

// Class AddNewPlate to handle creation of new Plate instances.
class AddNewPlate {
  final String image; // Immutable string for the image URL or identifier.
  String type; // Mutable string to indicate the type of plate.
  List<String> bacteria; // List of bacteria species present on the plate.
  List<PlatePart> parts; // List of different parts or sections of the plate.

  // Constructor for AddNewPlate.
  AddNewPlate(
      {required this.image,
      required this.parts,
      required this.bacteria,
      required this.type});

  // Factory constructor to create an AddNewPlate instance from JSON data.
  AddNewPlate.fromJson(Map<String, dynamic> json)
      : image = json['image'],
        bacteria = json['bacteria'],
        parts = json['parts'],
        type = json['type'];

  // Method to convert an AddNewPlate instance to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'bacteria': bacteria,
      'parts': parts.map((e) => e.toJson()).toList(),
      'type': type
    };
  }

  // Method to create a Plate instance from an AddNewPlate object.
  Plate toPlateViewModel(String imageName) {
    var uuid = Uuid();

    return Plate(
        image: imageName,
        parts: parts,
        bacteria: bacteria,
        createdBy: '', // Empty string for creator, likely to be set later.
        createdDate:
            DateTime.now(), // Sets the creation date to the current date.
        type: type,
        plateId: uuid.v4());
  }
}