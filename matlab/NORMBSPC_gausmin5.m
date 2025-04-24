[s,fs]=audioread('sp01.wav');
[s,fs]=audioread('natrajan_2a.wav');
s1=resample(s,1,1);

% Gaussian Noise

% v=0.05*randn(size(s1)); % adding a random Gaussian noise eqn 
% orig=s1+v; % noisy speech signal 

% Pink Noise

[v1,fs]=audioread('pink-noise.mp3');
v=v1*2.8;
v = v(1:length(s1));
orig=s1+v(1:length(v)); 

player = audioplayer(v, fs);
player1 = audioplayer(s1, fs);
player2 = audioplayer(orig, fs);