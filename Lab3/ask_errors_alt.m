function errors=ask_errors_alt(k,Nsymb,nsamp,EbNo)
% Η συνάρτηση αυτή εξομοιώνει την παραγωγή και αποκωδικοποίηση alternative
% θορυβώδους σήματος L-ASK και μετρά τον αριθμό των εσφαλμένων συμβόλων.
% Υπολογίζει επίσης τη θεωρητική πιθανότητα εσφαλμένου συμβόλου, Pe.
% Επιστρέφει τον αριθμό των εσφαλμένων συμβόλων, καθώς και τον συνολικό
% αριθμό των συμβόλων που παρήχθησαν.
% k είναι ο αριθμός των bits/σύμβολο, ώστε L=2^k,
% Nsymb ο αριθμός των παραγόμενων συμβόλων (μήκος ακολουθίας L-ASK)
% nsamp ο αριθμός των δειγμάτων ανά σύμβολο (oversampling ratio)
% EbNo είναι ο λόγος Eb/No, σε db
L=2^k;
SNR=EbNo-10*log10(nsamp/2/k); % SNR ανά δείγμα σήματος
% Διάνυσμα τυχαίων ακεραίων {±1, ±3, ... ±(L-1)}. Να επαληθευτεί
x=(2*floor(L*rand(1,Nsymb))-L+1)*5/2; % d = 5
Px=(L^2-1)*5^2/12; % θεωρητική ισχύς σήματος
Pr = sum(x.^2)/length(x); % μετρούμενη ισχύς σήματος (για επαλήθευση)
h = cos(2*pi*(1:nsamp)/nsamp); h=h/sqrt(h*h');
y=upsample(x,nsamp); % μετατροπή στο πυκνό πλέγμα
y=conv(y,h); % το προς εκπομπή σήμα
y=y(1:Nsymb*nsamp); % περικόπτεται η ουρά που αφήνει η συνέλιξη
ynoisy=awgn(y,SNR,'measured'); % θορυβώδες σήμα
matched=ones(1,nsamp);
%for i=1:nsamp matched(i)=h(end-i+1); end
yrx=conv(ynoisy,matched);
z = yrx(nsamp:nsamp:Nsymb*nsamp); % Yποδειγμάτιση -- στο τέλος
                                % κάθε περιόδου Τ
A=5*[-L+1:2:L-1]/2;
for i=1:length(z)
[m,j]=min(abs(A-z(i)));
z(i)=A(j);
end
err=not(x==z);
errors=sum(err);
end