[s,fs]=audioread('sp01.wav');
% [s,fs]=audioread('natrajan_2a.wav');
[v1,fs]=audioread('street.wav');
s1=resample(s,1,1);
v=v1*0.95;
v = v(1:length(s1));
orig=s1+v; 
player = audioplayer(v, fs);
player1 = audioplayer(s, fs);
player2 = audioplayer(orig, fs);