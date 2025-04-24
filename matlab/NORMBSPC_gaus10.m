[s,fs]=audioread('sp01.wav');
s1=resample(s,1,1);
v=0.0225*randn (size(s1)); % adding a random Gaussian noise eqn 
orig=s1+v; % noisy speech signal 
player = audioplayer(v, fs);
player1 = audioplayer(s1, fs);
player2 = audioplayer(orig, fs);