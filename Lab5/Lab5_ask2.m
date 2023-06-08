clc;
clear all; 
close all;
nsamp=32;
Nsymb=30000;
k=6;
EbNo=10;
M=2^k;
L=sqrt(M);        % LxL ��������� ����������, L=2^l, l>0
l=log2(L);
fc=10;  % ��������� ��������, ����������� ��� Baud Rate (1/T)
SNR=EbNo-10*log10(nsamp/k/2); % SNR ��� ������ �������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W=(11.25-8.75)*10^6;
R=12*10^6;
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
%%%%%%%%%%%% ������ %%%%%%%%%%%%
x=floor(2*rand(k*Nsymb,1));  % ������ ������� ���������
xsym=bi2de(reshape(x,k,length(x)/k).','left-msb')';
y=[];
for n=1:length(xsym)
    y=[y mapping(xsym(n)+1)];
end
%������� ������� ������������
delay = 8;  % Group delay (# ���������)
filtorder = delay*nsamp*2; 
rolloff = a; % ����������� ��������� �������
rNyquist=rcosine(1,nsamp,'fir/sqrt',rolloff,delay);
%����������� ����
ytx=upsample(y,nsamp);
ytx = conv(ytx,rNyquist);
% quadrature modulation
m=(1:length(ytx));
s=real(ytx.*exp(1i*2*pi*fc*m/nsamp));
% �������� ������ ����������� �������
Ps=10*log10(s*s'/length(s));  % ������������, ��db
Pn=Ps-SNR;               % ���������� ����� �������, �� db
n=sqrt(10^(Pn/10))*randn(1,length(ytx));
snoisy=s+n; % ��������� ���������� ����
% ������������� 
yrx=2*snoisy.*exp(-1i*2*pi*fc*m/nsamp); 
yrx = conv(yrx,rNyquist);
YRX = yrx;
yrx = downsample(yrx,nsamp); % ������������� ��� ������ nT
yrx = yrx(2*delay+(1:length(y))); % �������� ����� ���������.
% ----------------------
yi=real(yrx); yq=imag(yrx); % ��������� ��� �������� ���������
xrx=[];  % �������� �������� ���������� ������ --������ ����
q=[-L+1:2:L-1];
for n=1:length(yrx)  % ������� ������������ �������
    [m,j]=min(abs(q-yi(n)));
    yi(n)=q(j);
    [m,j]=min(abs(q-yq(n)));
    yq(n)=q(j);
    m=1;
    while(mapping(m)~=yi(n)+1i*yq(n)) m=m+1; end
    xrx=[xrx; de2bi(m-1,k,'left-msb')'];
end
% �������� ������ ����� �� �������� ��� ������� QAM (y-yrx)
errors=sum(not(y==(yi+1i*yq)));

figure(1); pwelch(real(ytx),[],[],[],nsamp);
figure(2); pwelch(s,[],[],[],nsamp); % �� ������� 1/T
figure(3); pwelch(real(YRX),[],[],[],nsamp); % �� ������� 1/T
scatterplot(yrx); % ��������� �������������