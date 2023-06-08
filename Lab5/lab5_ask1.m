clc;
clear all;
close all;
% Διάνυσμα mapping για την κωδικοποίηση Gray M-QAM
% Αφορά σε πλήρες ορθογωνικό πλέγμα σημείων, διάστασης M=L^2
% l=log2(L): αριθμός bit ανά συνιστώσα (inphase, quadrature)
M=64;
k=log2(M);
L=sqrt(M);
l=log2(L);
core=[1+1i;1-1i;-1+1i;-1-1i]; % τετριμμένη κωδικοποίηση, M=4
mapping=core;
if(l>1)
 for j=1:l-1
 mapping=mapping+j*2*core(1);
 mapping=[mapping;conj(mapping)];
 mapping=[mapping;-conj(mapping)];
 end
end;
scatter(real(mapping), imag(mapping),'filled','d');
xlabel("In-Phase");
ylabel("Quadrature");
for i=1:M
    text(real(mapping(i))-l/8,imag(mapping(i))+l/8,num2str(de2bi(i-1,k,'left-msb')), 'FontSize', 8);
end