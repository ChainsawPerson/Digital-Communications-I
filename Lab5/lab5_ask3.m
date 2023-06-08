clc;
clear all;
close all;
L=4; % LxL σηματικός αστερισμός, L=2^l, l>0
l=log2(L); k=2*l; M=L^2;
Nsymb=30000;
nsamp=32; % συντελεστής υπερδειγμάτισης, # δειγμάτων/Τ
fc=10; % συχνότητα φέροντος, πολλαπλάσιο του Baud Rate (1/T)
EbNo=10; % Eb/No, σε db
SNR=EbNo-10*log10(nsamp/k/2); % SNR ανά δείγμα σήματος
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W=(11.25-8.75)*10^6;
R=8*10^6;
a=k*W/R-1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
core=[1+1i;1-1i;-1+1i;-1-1i];
mapping=core;
if(l>1)
for j=1:l-1
mapping=mapping+j*2*core(1);
mapping=[mapping;conj(mapping)];
mapping=[mapping;-conj(mapping)];
end
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% ΠΟΜΠΟΣ %%%%%%%%%%%%
x=floor(2*rand(k*Nsymb,1)); % τυχαία δυαδική ακολουθία
xsym=bi2de(reshape(x,k,length(x)/k).','left-msb')';
y=[];
for n=1:length(xsym)
y=[y mapping(xsym(n)+1)];
end
%Ορισμός φίλτρου μορφοποίησης
delay = 8; % Group delay (# περιόδωνΤ)
filtorder = delay*nsamp*2;
rolloff = 0.25; % συντελεστής εξάπλωσης φίλτρου
rNyquist=rcosine(1,nsamp,'fir/sqrt',rolloff,delay);
%Εκπεμπόμενο σήμα
ytx=upsample(y,nsamp);
ytx = conv(ytx,rNyquist);
% Υπολογισμός & σχεδιασμός φάσματος
figure(1); pwelch(real(ytx),[],[],[],nsamp); % σε κλίμακα 1/T
% quadrature modulation
m=(1:length(ytx));
s=real(ytx.*exp(1i*2*pi*fc*m/nsamp));
figure(2); pwelch(s,[],[],[],nsamp); % σε κλίμακα 1/T
% Προσθήκη λευκού γκαουσιανού θορύβου
Ps=10*log10(s*s'/length(s)); % ισχύςσήματος, σεdb
Pn=Ps-SNR; % αντίστοιχη ισχύς θορύβου, σε db
n=sqrt(10^(Pn/10))*randn(1,length(ytx));
snoisy=s+n; % θορυβώδες ζωνοπερατό σήμα
% Αποδιαμόρφωση
yrx=2*snoisy.*exp(-1i*2*pi*fc*m/nsamp); clear s;
yrx = conv(yrx,rNyquist);
figure(3); pwelch(real(yrx),[],[],[],nsamp); % κλίμακα 1/T
yrx = downsample(yrx,nsamp); % Υποδειγμάτιση στο πλέγμα nT
yrx = yrx(2*delay+(1:length(y))); % περικοπή άκρων συνέλιξης.
% ----------------------
yi=real(yrx); yq=imag(yrx); % συμφασική και εγκάρσια συνιστώσα
xrx=[]; % διάνυσμα δυαδικής ακολουθίας εξόδου --αρχικά κενό
q=[-L+1:2:L-1];
for n=1:length(yrx) % επιλογή πλησιέστερου σημείου
[m,j]=min(abs(q-yi(n)));
yi(n)=q(j);
[m,j]=min(abs(q-yq(n)));
yq(n)=q(j);
m=1;
while(mapping(m)~=yi(n)+1i*yq(n)) m=m+1; end
xrx=[xrx; de2bi(m-1,k,'left-msb')'];
end
scatterplot(yrx); % διάγραμμα διασκορπισμού
title('Scatter plot, Eb/No=10dB');
% ΕΚΤΙΜΗΣΗ ΡΥΘΜΟΥ ΛΑΘΩΝ
% Με δύο τρόπους: (α) με σύγκριση των σημείων QAM (y-yrx)
% (β) με σύγκριση των δυαδικών ακολουθιών (x-xrx)
ber1=sum(not(y==(yi+1i*yq)))/length(x);
ber2=sum(not(xrx==x))/length(x);