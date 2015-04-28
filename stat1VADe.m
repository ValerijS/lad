function [vad4,vad14] = stat1VADe(audifile,addnoice)
[ampl,frc] = audioread(audifile);
noicelySigal = ampl+addnoice*randn(size(ampl));
%ampl1 = ampl;
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
for n = 1 : lengthFrame
    varNoice(n,1)= var(FRAME(n,1:min(20,round(numberFrames/5))));
end 
ind = 1:numberFrames;
for k= 1:numberFrames
ind(k) = sum(abs(FRAME(:,k)).^2./varNoice(:,1)-log(varNoice(:,1))-1);
end
levNois  = max(ind(1:min(20,round(numberFrames/5))));
if levNois > 1.0000e+04
    koef = 2;
else
    koef = 2;
end    
vad14 = 1:numberFrames;
for k = 1:numberFrames
  % max(ind(1:min(20,round(numberFrames/5))))
   if ind(k) > koef * max(ind(1:min(20,round(numberFrames/5))))  
      vad14(k) =1;
   else   
      vad14(k) = 0;
   end
end
%mean( varNoice(n,1))   
%max(ind(1:min(20,round(numberFrames/5))))%vad = zerosnumberFrames-1;
vad4 = ampl;%any vector with same size
for j = 1:numberFrames-1
  for k = 1:lengthFrame
    vad4((j-1)*(lengthFrame-1) +k) = vad14(j);
  end
end


