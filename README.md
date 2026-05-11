# DTMF Signal Decoder (MATLAB)

MATLAB-based digital signal processing system for decoding Dual-Tone Multi-Frequency (DTMF) audio signals. The system extracts keypad inputs from noisy audio using time-domain segmentation and frequency-domain analysis.

## Features
- Time-domain segmentation into 25ms frames
- Energy-based voice activity detection (VAD)
- FFT-based frequency analysis for tone detection
- Mapping of frequency pairs to DTMF keypad characters (0–9, A–D, *, #)
- Debouncing logic to prevent duplicate detections

## Technical Highlights
- MATLAB implementation of DSP pipeline
- Frequency peak detection and classification
- Short-Time Fourier Transform (STFT) principles
- Noise filtering and signal stabilization techniques
- Robust detection of real-world noisy signals

## What I Learned
- Practical implementation of digital signal processing theory
- Frequency-domain vs time-domain trade-offs
- Designing robust signal classification algorithms
- Translating mathematical DSP concepts into working MATLAB systems

