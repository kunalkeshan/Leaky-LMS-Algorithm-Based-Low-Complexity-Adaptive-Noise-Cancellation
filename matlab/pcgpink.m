[s,fs]=audioread('a0007.mp3');
[v1,fs]=audioread('pink-noise.mp3');
v=v1*0.95;
v = v(1:16060);
s = s(1:16060);
orig=s+v;