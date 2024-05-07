# auth_test.py
import unittest
from authentication import checkEmailAndPassword

class TestAuthentication(unittest.TestCase):
    def setUp(self):
        # Initialize the Firebase authentication object
        self.auth = fireauth()

    def test_checkEmailAndPassword_success(self):
        # Test successful authentication with valid email and password
        email = "test@example.com"
        password = "password123"
        user = checkEmailAndPassword(email, password)
        self.assertIsNotNone(user)

    def test_checkEmailAndPassword_invalid_email(self):
        # Test authentication with invalid email
        email = "invalid_email"
        password = "password123"
        with self.assertRaises(ValueError):
            checkEmailAndPassword(email, password)

    def test_checkEmailAndPassword_invalid_password(self):
        # Test authentication with invalid password
        email = "test@example.com"
        password = "wrong_password"
        with self.assertRaises(ValueError):
            checkEmailAndPassword(email, password)

    def test_checkEmailAndPassword_none_input(self):
        # Test authentication with None input
        email = None
        password = "password123"
        with self.assertRaises(TypeError):
            checkEmailAndPassword(email, password)

        email = "test@example.com"
        password = None
        with self.assertRaises(TypeError):
            checkEmailAndPassword(email, password)

if __name__ == "__main__":
    unittest.main()