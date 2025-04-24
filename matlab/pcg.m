[s, fs] = audioread('a0007.mp3');
% Below is abnormal for pcg
% [s,fs]=audioread('a0001.mp3');
desiredSNR = 5; % Set the desired SNR in dB (change to 5, etc. as needed)
s1=resample(s,1,1);

% Calculate the RMS of the clean signal
rms_signal = rms(s1);

% Determine the noise RMS required to achieve the desired SNR.
% SNR (dB) = 20*log10(rms_signal / rms_noise)
% ==> rms_noise = rms_signal / (10^(desiredSNR/20))
noise_rms = rms_signal / (10^(desiredSNR/20));

% Generate Gaussian noise with the computed noise RMS
v = noise_rms * randn(size(s1));

% Create the noisy speech signal
orig = s1 + v;

% Create audio players to listen to each signal (optional)
player_noise = audioplayer(v, fs);
player_clean = audioplayer(s1, fs);
player_noisy = audioplayer(orig, fs);

% Optionally, play the sounds:
% play(player_clean);  % Plays the clean signal
% play(player_noise);  % Plays the noise signal
% play(player_noisy);  % Plays the noisy signal
