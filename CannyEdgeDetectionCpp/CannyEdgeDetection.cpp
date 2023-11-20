#include "pch.h"
#include "CannyEdgeDetection.h"

void ExecuteCannyEdgeCpp(int arraysize, int height, int width, unsigned short* in_redAddr,
    unsigned short* in_greenAddr, unsigned short* in_blueAddr, unsigned short* out_redAddr,
    unsigned short* out_greenAddr, unsigned short* out_blueAddr) {
    
    // Allocate memory for intermediate results
    unsigned short* edgesData = new unsigned short[arraysize];
    unsigned short* gradientMagnitudeData = new unsigned short[arraysize];
    unsigned short* gradientDirectionData = new unsigned short[arraysize];

    // Example: Call assembly functions
    for (int i = 0; i < arraysize; ++i) {
        // Call the assembly functions for gradient magnitude and hysteresis thresholding
        // The results should be stored in out_redAddr, out_greenAddr, and out_blueAddr
        gradMagnitude(in_redAddr[i], in_greenAddr[i], in_blueAddr[i]);

        // Define parameters for hysteresisThresholding
        unsigned short* edges = edgesData;
        int hysteresisWidth = width;
        int hysteresisHeight = height;

        hysteresisThresholding(edges, hysteresisWidth, hysteresisHeight, &out_redAddr[i]);


        // Define parameters for nonMaximumSuppression
        unsigned short* gradientMagnitude = gradientMagnitudeData;
        unsigned short* gradientDirection = gradientDirectionData;

        nonMaximumSuppression(gradientMagnitude, gradientDirection, width, height, &out_greenAddr[i]);

        // Store the result in the blue channel (for example)
        out_blueAddr[i] = out_redAddr[i] & out_greenAddr[i];
    }
    // Clean up: release allocated memory
    delete[] edgesData;
    delete[] gradientMagnitudeData;
    delete[] gradientDirectionData;
}