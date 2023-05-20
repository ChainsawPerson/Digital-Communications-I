close all;
clear all;
clc;
AM = 20096;
k = mod(AM,2)+3;
L = 2^k;
d = 5;
Nsymb = 60000;
nsamp = 20;
EbNo = 12;
SNR=EbNo-10*log10(nsamp/2/k);
x=(2*floor(L*rand(1,Nsymb))-L+1)*d/2;
h=ones(1,nsamp); h=h/sqrt(h*h'); % κρουστική απόκριση φίλτρου
                % πομπού (ορθογωνικός παλμός μοναδιαίας ενέργειας)
y=upsample(x,nsamp); % μετατροπή στο πυκνό πλέγμα
y=conv(y,h); % το προς εκπομπή σήμα
y=y(1:Nsymb*nsamp); % περικόπτεται η ουρά που αφήνει η συνέλιξη
y2 = y;
ynoisy=awgn(y,SNR,'measured'); % θορυβώδες σήμα
for i=1:nsamp 
    matched(i)=h(end-i+1);
end
yrx=conv(ynoisy,matched);
z = yrx(nsamp:nsamp:Nsymb*nsamp); % Yποδειγμάτιση -- στο τέλος
                                % κάθε περιόδου Τ
A=5*[-L+1:2:L-1]/2;
for i=1:length(z)
[m,j]=min(abs(A-z(i)));
z(i)=A(j);
end
disp("Exercise 3 Part a:")
disp(" ");
err=not(x==z);
errors=sum(err);
disp("Altered Code Errors = " + num2str(errors));
disp("ask_errors Errors = " + num2str(ask_errors(k,Nsymb,nsamp,EbNo)));
disp(" ");

yrx2 = conv(y2,matched);
figure(); stem(x(1:20));
figure(); stem(y2(1:20*nsamp));
figure(); stem(yrx2(1:20*nsamp));

