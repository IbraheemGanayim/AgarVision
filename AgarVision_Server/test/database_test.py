import unittest
from database import (
    getExperiments,
    addNewExperiment,
    getExperimentPlates,
    getExperimentPlate,
    addNewPlate,
    deletePlate,
)
import json
from datetime import datetime

class TestExperimentFunctions(unittest.TestCase):
    def setUp(self):
        # Initialize the database object
        self.db = database()

    def test_getExperiments(self):
        # Test retrieving experiments for a user
        user_id = "test_user"
        experiments = getExperiments(user_id)
        self.assertIsInstance(experiments, str)
        self.assertIsNotNone(json.loads(experiments))

    def test_addNewExperiment(self):
        # Test adding a new experiment
        experiment_data = {"name": "Test Experiment", "createdBy": "test_user"}
        added_experiment = addNewExperiment(experiment_data)
        self.assertIsInstance(added_experiment, dict)
        self.assertIn("thumbnail", added_experiment)

    def test_getExperimentPlates(self):
        # Test retrieving plates for an experiment
        experiment_id = "test_experiment"
        plates = getExperimentPlates(experiment_id)
        self.assertIsInstance(plates, str)
        self.assertIsNotNone(json.loads(plates))

    def test_getExperimentPlate(self):
        # Test retrieving a specific plate for an experiment
        experiment_id = "test_experiment"
        plate_id = "test_plate"
        plate = getExperimentPlate(experiment_id, plate_id)
        self.assertIsInstance(plate, dict)

    def test_addNewPlate(self):
        # Test adding a new plate to an experiment
        experiment_id = "test_experiment"
        plate_data = {"name": "Test Plate"}
        added_plate = addNewPlate(experiment_id, plate_data)
        self.assertIsInstance(added_plate, str)
        self.assertIsNotNone(json.loads(added_plate))

    def test_deletePlate(self):
        # Test deleting a plate from an experiment
        experiment_id = "test_experiment"
        plate_id = "test_plate"
        deletePlate(experiment_id, plate_id)
        # Verify the plate is deleted
        plate = getExperimentPlate(experiment_id, plate_id)
        self.assertIsNone(plate)

if __name__ == "__main__":
    unittest.main()