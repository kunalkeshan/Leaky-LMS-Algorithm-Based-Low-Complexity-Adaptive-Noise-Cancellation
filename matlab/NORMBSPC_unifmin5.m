% [s,fs]=audioread('sp01.wav');
[s,fs]=audioread('natrajan_2a.wav');
s1=resample(s,1,1);
v=0.09*rand (size(s1)); 
orig=s1+v; % noisy speech signal 
player = audioplayer(v, fs);
player1 = audioplayer(s1, fs);
player2 = audioplayer(orig, fs);