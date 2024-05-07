import 'package:agar_vision/schema/Plate.dart';

/// Represents the result of a plate prediction.
class PlatePredictionResult {
  /// The base64 encoded image of the prediction result.
  final String resultImageBas64;

  /// The result of the prediction.
  final int result;
  List<PlatePart> QuartersResults = []; // To Store 4 Quarters details

  /// Creates a new instance of [PlatePredictionResult].
  PlatePredictionResult({
    /// The base64 encoded image of the prediction result. [required]
    required this.resultImageBas64,

    /// The result of the prediction. [required]
    required this.result,
    required this.QuartersResults
  });

  /// Creates a new instance of [PlatePredictionResult] from a JSON object.
  factory PlatePredictionResult.fromJson(Map<String, dynamic> json) {
    return PlatePredictionResult(
      resultImageBas64: json['resultImage'],
      result: json['result'],
      QuartersResults:PlatePart.fromArrayJson(json['QuartersResults'])
    );
  }

  /// Converts the [PlatePredictionResult] instance to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'resultImage': resultImageBas64,
      'result': result,
      'QuartersResults': QuartersResults,
    };
  }
}
