import 'package:agar_vision/schema/Experiment.dart';
import 'package:agar_vision/services/Authentication.dart';
import 'package:agar_vision/services/backend/ExperimentService.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockExperimentService extends Mock implements ExperimentService {
  Future<List<Experiment>> getExperiments() => super.noSuchMethod(
        Invocation.method(#getExperiments, []),
        returnValue: Future.value([]),
      );
}

class MockAuthenticationService extends Mock implements AuthenticationService {}