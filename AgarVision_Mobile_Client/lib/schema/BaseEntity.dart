// Define a class for a base entity with two properties: createdDate and createdBy
class BaseEntity {
  // Declare createdDate as a final DateTime property
  final DateTime createdDate;

  // Declare createdBy as a final String property
  final String createdBy;

  // Define a constructor for the class that takes two required arguments
  BaseEntity({required this.createdBy, required this.createdDate});
}