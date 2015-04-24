function [vad4,vad14] = stat1VAD_f_24_04(audifile,addnoice,s)
%s- number of frames for avarige for apostML,s>=1.
[ampl,frc] = audioread(audifile);
noicelySigal = ampl+addnoice*randn(size(ampl));

ampl = noicelySigal;
lengthFrame=round(frc/100);
numberFrames1=round(size(ampl)/lengthFrame);
numberFrames = numberFrames1(1);

frame = ones(numberFrames,lengthFrame)';

for k = 1: numberFrames-1
    for n = 1 : lengthFrame
         frame(n,k) = ampl((k-1)* lengthFrame+n);
         
    end
end
FRAME = fft(frame);
varNoice = ones(lengthFrame,1);
varNoice1 = ones(lengthFrame,numberFrames);
for n = 1 : lengthFrame
    varNoice(n,1)= var(FRAME(n,1:min(20,round(numberFrames/5))));
    varNoice1(n,1:numberFrames)= var(FRAME(n,1:min(20,round(numberFrames/5))));
end 
apostSNR = abs(FRAME.^2./varNoice1);
apostSNR1 = apostSNR;
if s >1
    for k = s :numberFrames

apostSNR1(1: lengthFrame,k) =sum(apostSNR(1: lengthFrame,(k-s+1):k)'./s)';

    end
K = (apostSNR.*((apostSNR1-1)./apostSNR1)-log(apostSNR1)) > (apostSNR1.*0);
P = (apostSNR.*((apostSNR1-1)./apostSNR1)-log(apostSNR1)).*K;     
else

K = (apostSNR-log(apostSNR)-1) > (apostSNR.*0);
P = (apostSNR-log(apostSNR)-1).*K; 
end



ind = sum(P(:,1:numberFrames))/numberFrames;


levNois  = max(ind(s:min(20 + s, round(numberFrames/5))));
if levNois > 1.0
    koef = 7.5;
else
    koef = 3.5;
end    
vad14 = 1:numberFrames;
for k = 1:numberFrames
  
   if ind(k) >koef * levNois  
      vad14(k) =1;
   else   
      vad14(k) = 0;
   end
end

vad4 = ampl;%any vector with same size
for j = 1:numberFrames-1
  for k = 1:lengthFrame
    vad4((j-1)*(lengthFrame-1) +k) = vad14(j);
  end
end
plot(vad4.*0.9,'r'),hold on

plot(ampl,'b'),hold off 



