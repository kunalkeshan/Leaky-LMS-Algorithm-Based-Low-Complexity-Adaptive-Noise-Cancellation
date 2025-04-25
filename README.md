# Leaky LMS Algorithm-Based Low Complexity Adaptive Noise Cancellation [^1]

This project implements a multistage Leaky Least Mean Square (LLMS) adaptive filtering technique for noise cancellation in biomedical and speech signals. The primary motivation is to improve the accuracy of signal-based diagnosis (e.g., Parkinson's disease detection) by effectively removing environmental and instrumental noise from speech and phonocardiogram (PCG) recordings. All signal processing and output generation were performed using MATLAB.

## Table of Contents

- Overview
- Features
- Installation & Requirements
- Usage
- Datasets Used
- Results
- References

## Overview

Noise in biomedical and speech signals can significantly affect diagnostic accuracy, especially in applications such as early detection of neurodegenerative diseases. The LLMS algorithm offers a low-complexity, stable, and effective solution for adaptive noise cancellation. This project demonstrates the application of a multistage LLMS filter to denoise both PCG and speech signals, enhancing their suitability for downstream analysis and diagnosis.

## Features

- **Multistage LLMS adaptive filtering** for robust noise cancellation
- Designed for both **biomedical (PCG)** and **speech** signals
- **MATLAB-based implementation** for easy integration and reproducibility
- Evaluation on real-world, noisy datasets

## Installation & Requirements

- **MATLAB** (R2018b or later recommended)
- **MATLAB Online** works for this project too.
- Signal Processing Toolbox (for advanced filtering and analysis)
- Download the datasets as described below

## Usage

1. **Download the datasets** (see "Datasets Used" section).
2. Place the dataset files in the appropriate directories as expected by the MATLAB scripts.
3. Run the main MATLAB script: (Reference file [`processSignal.m`](./matlab/processSignal.m))

   ```matlab
   %   Inputs:
    %     sourceType  – 'pcg' or 'speech'
    %     condition   – 'normal' or 'abnormal'
    %     desiredSNR  – desired SNR in dB (numeric)
    %     method      – one of {'lms','llms','nllms','rllms'}
   processSignal('pcg', 'normal', 0, 'nllms');
   ```

4. Output results (denoised signals, SNR, MSE, correlation coefficients) will be shown in the command window for each stage.

## Datasets Used

### 1. PhysioNet/CinC Challenge 2016 Phonocardiogram (PCG) Dataset

- **Source:** [PhysioNet/CinC Challenge 2016](https://archive.physionet.org/pn3/challenge/2016/)
- **Description:** Contains 3,126 heart sound (PCG) recordings from both healthy subjects and patients with various cardiac pathologies, collected at multiple anatomical locations. Recordings are in WAV format, resampled to 2,000 Hz, and range from 5 seconds to over 2 minutes. Each recording is labeled as either "normal" or "abnormal." The dataset includes a wide variety of noise sources such as talking, stethoscope motion, and breathing, making it ideal for testing noise cancellation algorithms[^2].
- **Use in Project:** Used to evaluate the LLMS filter's ability to denoise real-world biomedical signals and improve the reliability of automated heart sound analysis.

### 2. NOIZEUS Speech Corpus

- **Source:** [NOIZEUS: A Noisy Speech Corpus](https://ecs.utdallas.edu/loizou/speech/noizeus/)
- **Description:** Consists of 30 IEEE sentences spoken by three male and three female speakers, corrupted by eight types of real-world noise (e.g., babble, car, street, restaurant) at SNRs of 0, 5, 10, and 15 dB. The sentences are phonetically balanced and were originally sampled at 25 kHz, downsampled to 8 kHz. This corpus is widely used for benchmarking speech enhancement algorithms[^3].
- **Use in Project:** Used to test the LLMS filter's performance on speech signals, simulating real-world noisy environments encountered in clinical and telehealth scenarios.

## Results

The LLMS filter demonstrated effective noise reduction on both PCG and speech datasets. Key findings include:

- **Improved Signal-to-Noise Ratio (SNR):** Output SNR increased significantly after filtering, especially in multi-stage configurations.
- **Lower Mean Square Error (MSE):** The filter consistently reduced MSE across all tested noise levels.
- **Stability and Convergence:** The leakage parameter in the LLMS ensured stable filter weights and prevented divergence, even in highly non-stationary noise conditions.

Detailed quantitative results, including SNR, MSE, and correlation coefficients for various noise levels and filter stages, are provided in the `/reports` directory and in the project paper.

## References

- PhysioNet/CinC Challenge 2016 PCG Dataset[^2]
- NOIZEUS Speech Corpus[^3]
- Project Paper: "Leaky LMS algorithm based low complexity Adaptive Noise Cancellation" (see attached PDF)

## Acknowledgments

- PhysioNet and the contributors of the CinC Challenge 2016 for the PCG dataset
- Dr. Philipos Loizou and collaborators for the NOIZEUS speech corpus

## Contact

For questions or feedback, please open an issue in the repository or contact the project maintainer.

Citations:

[^1]: [Leaky LMS Algorithm-Based Low Complexity Adaptive Noise Cancellation Research Paper](./Leaky%20LMS%20algorithm%20based%20low%20complexity%20adaptive%20noise%20cancellation.pdf)
[^2]: https://archive.physionet.org/pn3/challenge/2016/
[^3]: https://ecs.utdallas.edu/loizou/speech/noizeus/
