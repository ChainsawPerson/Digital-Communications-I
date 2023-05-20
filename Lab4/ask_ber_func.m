function [ber,numBits]=ask_ber_func(EbNo, maxNumErrs, maxNumBits)
import com.mathworks.toolbox.comm.BERTool.*;
totErr=0;
numBits=0;

k=3;
Nsymb=2000;
nsamp=32;

while((totErr<maxNumErrs) && (numBits<maxNumBits))
errors=ask_Nyq_filter_theor(k,Nsymb,nsamp,EbNo);
totErr=totErr+errors;
numBits=numBits+k*Nsymb;
end
ber=totErr/numBits;