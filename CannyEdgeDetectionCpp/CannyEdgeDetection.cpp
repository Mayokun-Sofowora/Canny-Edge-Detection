#include "pch.h"
#include "CannyEdgeDetection.h"

void ExecuteCannyEdgeCpp(int arraysize, int height, int width, unsigned short* in_redAddr,
    unsigned short* in_greenAddr, unsigned short* in_blueAddr, unsigned short* out_redAddr,
    unsigned short* out_greenAddr, unsigned short* out_blueAddr) {
    // Your implementation goes here

    // Example: Call assembly functions
    for (int i = 0; i < arraysize; ++i) {
        // Call the assembly functions for gradient magnitude and hysteresis thresholding
        // The results should be stored in out_redAddr, out_greenAddr, and out_blueAddr
        gradMagnitude(in_redAddr[i], in_greenAddr[i], in_blueAddr[i]);
        hysteresisThresholding();

        // Define a variable to hold the result
        unsigned short result = 0;

        // Store the result in the output arrays
        out_redAddr[i] = result;
        out_greenAddr[i] = result;
        out_blueAddr[i] = result;
    }
}