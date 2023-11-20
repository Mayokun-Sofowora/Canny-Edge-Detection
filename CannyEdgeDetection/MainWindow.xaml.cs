using Emgu.CV;
using Emgu.CV.CvEnum;
using Emgu.CV.Structure;
using System;
using Microsoft.Win32;
using System.IO;
using System.Windows;
using System.Windows.Media.Imaging;

namespace CannyEdgeDetection
{
    public partial class MainWindow : Window
    {
        private BitmapImage? originalImage;

        public MainWindow()
        {
            InitializeComponent();
            originalImage = null;
        }

        private void loadImageButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                // Open the file dialog box
                OpenFileDialog dialog = new OpenFileDialog();
                dialog.Filter = "Image files (*.jpg, *.png) | *.jpg;*.png";

                // If the user selects a file, load it
                if (dialog.ShowDialog() == true)
                {
                    // Load the image
                    originalImage = new BitmapImage(new Uri(dialog.FileName));

                    // Display the original image
                    OriginalImage.Source = originalImage;

                    // Reset threshold values
                    UpperThresholdSlider.Value = 50;
                    LowerThresholdSlider.Value = 150;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error loading image: {ex.Message}");
            }
        }

        private void cannyEdgeDetectionButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (originalImage != null)
                {
                    // Convert the image to grayscale
                    Mat grayscaleMat = ConvertToGrayscale(originalImage);

                    // Apply Canny edge detection
                    Mat edges = new Mat();
                    CvInvoke.Canny(grayscaleMat, edges, (int)UpperThresholdSlider.Value, (int)LowerThresholdSlider.Value);

                    // Convert the edge image to BitmapImage
                    BitmapImage edgeImage = ConvertToBitmapImage(edges);

                    // Display the edge-detected image
                    EdgeImage.Source = edgeImage;

                    // Dispose the Mat objects to release memory
                    grayscaleMat.Dispose();
                    edges.Dispose();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error processing image: {ex.Message}");
            }
        }

        private Mat ConvertToGrayscale(BitmapImage image)
        {
            // Convert BitmapImage to Mat
            Mat matImage = ConvertToMat(image);

            // Convert the image to grayscale
            Mat grayscaleMat = new Mat();
            CvInvoke.CvtColor(matImage, grayscaleMat, ColorConversion.Bgr2Gray);

            return grayscaleMat;
        }

        private Mat ConvertToMat(BitmapImage bitmapImage)
        {
            // Convert BitmapImage to byte array
            byte[] imageBytes;
            using (MemoryStream stream = new MemoryStream())
            {
                BitmapEncoder encoder = new BmpBitmapEncoder(); // You can change this based on your image format
                encoder.Frames.Add(BitmapFrame.Create(bitmapImage));
                encoder.Save(stream);
                imageBytes = stream.ToArray();
            }

            // Convert byte array to Mat
            Mat mat = new Mat();
            CvInvoke.Imdecode(imageBytes, ImreadModes.Color, mat);

            return mat;
        }

        private BitmapImage ConvertToBitmapImage(Mat mat)
        {
            // Convert Mat to byte array
            byte[] imageBytes = mat.ToImage<Bgr, byte>().ToJpegData();

            // Convert byte array to BitmapImage
            BitmapImage bitmapImage = new BitmapImage();
            bitmapImage.BeginInit();
            bitmapImage.StreamSource = new MemoryStream(imageBytes);
            bitmapImage.EndInit();
            bitmapImage.Freeze();

            return bitmapImage;
        }

        private void Lower_Value(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            // Handle lower threshold value change
            LowerThresholdSlider.Value = e.NewValue; // Update threshold value
        }

        private void Upper_Value(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            // Handle upper threshold value change
            UpperThresholdSlider.Value = e.NewValue; // Update threshold value
        }


    }
}
