[s1,fs]=audioread('natrajan_2a.wav');
s=s1(1:7500);
v=0.25*randn (size(s)); % adding a random Gaussian noise eqn 
orig=s+v; % noisy speech signal