function [vad3, vad13] = weakfricdetVADe(audifile,addnoice)
[sampl,frc] = audioread(audifile);
numberFrames1=round(size(sampl)/(frc/100));
numberFrames = numberFrames1(1);
ampl = sampl;
noicelySigal = ampl+addnoice*randn(size(ampl));
ampl1 = ampl;
ampl = noicelySigal;
sampl = ampl;
frc1 = round(frc);
frameLenght1 = round(frc1/100);
nunberFrame2 = round(frameLenght1/4)-1;
framLength2 = round(frameLenght1/nunberFrame2);

for k = 1:length(sampl)/frameLenght1
   samplInFrame(k,:) = sampl((k-1) * frameLenght1 +1:k*frameLenght1);
end
frc;
for k =1:length(sampl)/frameLenght1
    for t = 1: nunberFrame2
        vecEngForFr(k,t) = sum(samplInFrame(k,(t-1)*4+1:t*4).^2);
    end    
   
end
for k =1:length(sampl)/frameLenght1
    frIndicator(k) = var(vecEngForFr(k,:));
end 
vecEngForFr(40:45,10:15);
levNois = mean(frIndicator(1:min(20,round(numberFrames/5))));
if levNois > 1.0000e-7
    koef = 100;
else
    koef = 509;
end    
frameLenght = length (sampl)/frameLenght1;

for k = 1:frameLenght
if  frIndicator(k) > koef*levNois;
vad13(k) = 1;
else
vad13(k) = 0;
end
end

for j = 1:frameLenght
for k = 1:frameLenght1
vad3((j-1)*frameLenght1 +k) = vad13(j);
end
end

