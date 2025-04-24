[s, fs] = audioread('sp01.wav');
% Below is abnormal for speech
% [s,fs]=audioread('natrajan_2a.wav');
s1 = resample(s, 1, 1);

% Define the desired SNR in dB (e.g., 0, 5, etc.)
desiredSNR = 5;  % Change this value to set a different target SNR

% Calculate the RMS value of the clean signal
rms_signal = rms(s1);

% Determine the noise RMS required to achieve the desired SNR:
% SNR (dB) = 20 * log10(rms_signal / rms_noise)
% ==> rms_noise = rms_signal / (10^(desiredSNR/20))
noise_rms = rms_signal / (10^(desiredSNR/20));

% Generate Gaussian noise with the computed noise RMS
v = noise_rms * randn(size(s1));
orig = s1 + v;  % Noisy speech signal

% If you want to try pink noise instead, uncomment and adjust the code below:
% [v1, fs] = audioread('pink-noise.mp3');
% v1 = v1 * 1.25;
% v1 = v1(1:length(s1));
% orig = s1 + v1;

% Create audio players to listen to the signals
player = audioplayer(v, fs);
player1 = audioplayer(s1, fs);
player2 = audioplayer(orig, fs);
