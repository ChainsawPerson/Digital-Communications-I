L=8; step=2; % ο αριθμός των πλατών και το βήμα μεταξύ τους
k=log2(L);
nsamp = 32;
Nbits=10002; %πλήθος bits (μήκος ακολουθίας)
Nsymb=Nbits/k; %πλήθος συμβόλων
x=randi([0,1],[1,Nbits]); % τυχαία δυαδική ακολουθία 10000 bits
z=length(x);

% Κωδικοποίηση Gray
mapping=[step/2; -step/2];
if(k>1)
 for j=2:k
 mapping=[mapping+2^(j-1)*step/2; ...
 -mapping-2^(j-1)*step/2];
 end
end
xsym=bi2de(reshape(x,k,length(x)/k).','left-msb');
y=[];
for i=1:length(xsym)
 y=[y mapping(xsym(i)+1)];
end

% Σηματοδοσία Nyquist
delay = 8;
filtorder = delay*nsamp*2;
rolloff = 0.40;
rNyquist = rcosine(1,nsamp,'fir/sqrt',rolloff,delay);

%υπερδειγματοληψία και εφαρμογή φίλτρου rNyquist
y_up = upsample(y,nsamp);
ytx = conv(y_up,rNyquist);
yrx = conv(ytx,rNyquist);
yrx = yrx(2*delay*nsamp+1:end-2*delay*nsamp); % περικοπη λόγω καθυστέρησης
figure(1); % σχεδίαση yrx και υπέρθεση της εισόδου
plot(yrx(1:10*nsamp)); 
pause
figure(2);
plot(yrx(1:10*nsamp)); hold;
stem([1:nsamp:nsamp*10],y(1:10),'filled');
pause;
figure(3); % το φάσμα του σήματος στο δέκτη
pwelch(yrx,[],[],[],nsamp);