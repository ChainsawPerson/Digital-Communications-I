function errors=ask_Nyq_filter_new(k,Nsymb,nsamp,EbNo)
L=2^k;
SNR=EbNo-10*log10(nsamp/2/k);
x=randi([0,1],[1,Nsymb*k]);
xreshape=reshape(x,[k,Nsymb])'; %reshape

% Different encoding
step=2;
mapping=-(L-1):step:(L-1);
xsym=bi2de(reshape(x,k,length(x)/k).','left-msb');
y=[];
for i=1:length(xsym)
 y=[y mapping(xsym(i)+1)];
end

delay=10; %group delay
filtorder=delay*nsamp*2; 
rolloff=0.4; 


rNyquist=rcosine(1,nsamp,'fir/sqrt',rolloff,delay);


y1=upsample(y,nsamp);
ytx=conv(y1,rNyquist);
ynoisy=awgn(ytx,SNR,'measured');
yrx=conv(ynoisy,rNyquist);
yrx=yrx(2*delay*nsamp+1:end-2*delay*nsamp);
yrx=downsample(yrx,nsamp); 


for i=1:length(yrx)
    [m,j]=min(abs(mapping-yrx(i)));
    xr(i,:)=de2bi(j-1,k,'left-msb');
end
err=not(xr==xreshape);
errors=sum(sum(err)); 