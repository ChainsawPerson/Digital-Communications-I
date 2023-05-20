function errors=ask_errors(k,Nsymb,nsamp,EbNo)
% Η συνάρτηση αυτή εξομοιώνει την παραγωγή και αποκωδικοποίηση
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
y=rectpulse(x,nsamp);
n=wgn(1,length(y),10*log10(Px)-SNR);
ynoisy=y+n; % θορυβώδες σήμα
y=reshape(ynoisy,nsamp,length(ynoisy)/nsamp);
matched=ones(1,nsamp);
z=matched*y/nsamp;
A=5*[-L+1:2:L-1]/2;
for i=1:length(z)
[m,j]=min(abs(A-z(i)));
z(i)=A(j);
end
%hist(x,A);
err=not(x==z);
errors=sum(err);
end