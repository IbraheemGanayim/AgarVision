import cv2
import numpy as np

def load_image(image_path):
    """Load an image from the file system using a raw string path to handle file paths correctly."""
    image = cv2.imread(image_path)
    if image is None:
        raise FileNotFoundError("Image file not found at: " + image_path)
    return image

def preprocess_image(image):
    """Convert image to grayscale and apply Gaussian blur to reduce noise and improve detection."""
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    blurred = cv2.GaussianBlur(gray, (11, 11), 0)
    return blurred

def detect_plate(image):
    """Use Hough Circle transform to find the largest circle, likely the agar plate."""
    circles = cv2.HoughCircles(image, cv2.HOUGH_GRADIENT, 1, image.shape[0]/2, param1=100, param2=30, minRadius=100, maxRadius=400)
    if circles is not None:
        circles = np.round(circles[0, :]).astype("int")
        return circles[0]  # Assuming the largest detected circle is the agar plate
    return None

def create_mask(image, circle, scale=0.85):
    """Create a circular mask slightly smaller than the detected plate to exclude edges."""
    mask = np.zeros((image.shape[0], image.shape[1]), dtype=np.uint8)
    cv2.circle(mask, (circle[0], circle[1]), int(circle[2] * scale), (255), thickness=-1)
    return mask

def divide_into_quarters(image):
    """Divide the masked area into four quarters."""
    h, w = image.shape[:2]
    return [
        image[:h//2, :w//2],  # Top-left
        image[:h//2, w//2:],  # Top-right
        image[h//2:, :w//2],  # Bottom-left
        image[h//2:, w//2:]   # Bottom-right
    ]

def detect_colonies(image, mask):
    """Apply the mask to the image and detect colonies using Hough Circles within the masked region."""
    masked_image = cv2.bitwise_and(image, image, mask=mask)
    circles = cv2.HoughCircles(masked_image, cv2.HOUGH_GRADIENT, dp=1.2, minDist=20, param1=30, param2=20, minRadius=5, maxRadius=40)
    return circles

def mark_colonies(image, circles):
    """Draw circles around detected colonies and return the count."""
    if circles is not None:
        circles = np.round(circles[0, :]).astype("int")
        for (x, y, r) in circles:
            cv2.circle(image, (x, y), r, (0, 255, 0), 4)
        return image, len(circles)
    return image, 0

def main():
    image_path = r"C:\path\to\your\agar\plate\image.jpg"  # Use a raw string for the path
    image = load_image(image_path)
    preprocessed = preprocess_image(image)
    circle = detect_plate(preprocessed)
    
    if circle is None:
        print("No agar plate detected.")
        return
    
    mask = create_mask(preprocessed, circle)
    quarters = divide_into_quarters(image)
    quarter_masks = divide_into_quarters(mask)

    total_count = 0
    for i, (quarter, quarter_mask) in enumerate(zip(quarters, quarter_masks)):
        circles = detect_colonies(preprocessed, quarter_mask)
        quarter_marked, count = mark_colonies(quarter, circles)
        total_count += count
        cv2.imshow(f'Quarter {i+1}', quarter_marked)
    
    print(f"Total colonies detected: {total_count}")
    cv2.waitKey(0)
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()
