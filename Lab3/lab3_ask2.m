close all;
clear all;
clc;
AM = 20096;
k = mod(AM,2)+3;
L = 2^k;
%d = 5;
Nsymb = 60000;
nsamp = 20;
EbNo = 1:20;
Pe = ((L-1)/L)*erfc(sqrt(3*10.^(EbNo/10)*log2(L)/(L^2-1)));
BER_theor = Pe/log2(L);
errors = zeros(1,20);
for i = 1:20
    errors(i) = ask_errors(k,Nsymb,nsamp,EbNo(i)); % d = 5
end
BER_pract = errors/(Nsymb*k);
hold on;
set(gca,'yscale','log');
semilogy(EbNo,BER_theor,'r');
semilogy(EbNo,BER_pract,'b+');
hold off;
title('BER of 8-ASK');
xlabel('Eb/No (dB)');
ylabel('BER');
legend('BER Theoritical','BER Practical');