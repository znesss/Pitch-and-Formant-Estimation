# Pitch and formants estimation

This project is done by Matlab.

Running the main file, provides two control panels, first of which is to record a wave file and the second is to open a file. Both are loaded into the program area and can be seen as a signal in the first plot. The path is displayed and it is also possible to listen to this audio file.

The second panel is where we can choose the parameters and ask the program to use them in order to show the plot of F0, F1, F2, F3 and the average of these values for the whole signal. The parameters are as follows:


1. Gender: is used to confine the search among frequencies more relevant to each gender. The default value is unknown. We can choose male or female if we are sure and want a more precise result.

2. Frame duration: The time interval in which we will have a single value for each parameter. This duration should be as long as a short phoneme (10 to 30msec) and we assume that we maintain stationarity in this small interval in time domain. But the smaller this frame, the wider main beam in frequency we will have after applying Fourier transform on the frame. Therefore, less
but more important side lobes lead to spectral leakage. Hence, choosing an appropriate frame size is crucial. This frame is later multiplied by a window, so that the frequencies are better obtained.

3. Overlap rate: The process is done for each frame, but these frames should overlap so that no information is missed in between. This rate is usually considered 50% of the frame size.

4. VUV Threshold: This parameter as an input to the function that detects Voiced frames, is used when the pitch is detected according to the desired frequency range, but this detected f0 may be a false positive, since it may have a magnitude which is not high enough to be a pitch. That is where we should compare this potential F0 with VUV threshold to determine if it is a voiced frame or not. This threshold is experimentally set to 0.1 in most references.

5. VUV method: If we don’t want to use VUV threshold to tell the difference between Voiced and Unvoiced frames, we can use the second method (ZCR) that is based on a simple computation.

6. nFreq: The Z-transform is the main calculation in formant extraction done by LPC method, so the Number of evaluation points has to be adjusted by the user. nFreq is a positive integer scalar no less than 2. N should be set to a value greater than the filter order.

There are four Buttons in the panel that are responsible of performing Homomorphic analysis for pitch and formant extraction. After pressing each button, the call backs run and we can see the resulting plot with the desired frequencies over time. An average of this parameter is also shown.

There are two buttons to calculate pitch but both follow the same steps, the only difference is that the second button uses Matlab rceps command. The reason of its presence is to compare its result with the result of the Cepstrum that is taken step by step in the code.

