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
Px=(L^2-1)*d^2/12; 
Pr = sum(x.^2)/length(x); 
disp("Exercise 1 Part a:");
disp(" ");
disp("Theoritical Power = " + num2str(Px));
disp("Practical Power = " + num2str(Pr));
disp(" ");
y=rectpulse(x,nsamp);
n=wgn(1,length(y),10*log10(Px)-SNR);
ynoisy=y+n; 
y=reshape(ynoisy,nsamp,length(ynoisy)/nsamp);
matched=ones(1,nsamp);
z=matched*y/nsamp;
A=d*[-L+1:2:L-1]/2;
for i=1:length(z)
    [m,j]=min(abs(A-z(i)));
    z(i)=A(j);
end
err=not(x==z);
errors=sum(err);
figure(1);
hist(x,A);

disp("Part b");
disp(" ");
k = 4;
L = 2^k;
d = 5;
Nsymb = 60000;
nsamp = 20;
for i = 1:3
    if i == 2
        EbNo = 16;
    elseif i == 3
        EbNo = 20;
    end
SNR=EbNo-10*log10(nsamp/2/k); 
x=(2*floor(L*rand(1,Nsymb))-L+1)*d/2; 
Px=(L^2-1)*d^2/12; 
Pr = sum(x.^2)/length(x); 
disp("For Eb/No = " + num2str(EbNo) + ":");
disp("Theoritical Power = " + num2str(Px));
disp("Practical Power = " + num2str(Pr));
disp(" ");
y=rectpulse(x,nsamp);
n=wgn(1,length(y),10*log10(Px)-SNR);
ynoisy=y+n; 
y=reshape(ynoisy,nsamp,length(ynoisy)/nsamp);
matched=ones(1,nsamp);
z=matched*y/nsamp;
figure(i+1);
hist(z,200);
end