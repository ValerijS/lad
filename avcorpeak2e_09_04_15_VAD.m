function [vad, vad1] = avcorpeak2e_09_04_15_VAD(audifile,addnoice)
[ampl,frc] = audioread(audifile);
noicelySigal = ampl+addnoice*randn(size(ampl));
%ampl1 = addnoice*randn(size(ampl));%noice, wich is added.
%%signal = ampl;
ampl = noicelySigal;
lengthFrame=round(frc/100);
numberFrames1=round(size(ampl)/lengthFrame);
numberFrames = numberFrames1(1);

frame = ones(numberFrames,lengthFrame);
preproframes = zeros(numberFrames,lengthFrame);
for k = 1: numberFrames-1
    for n = 2 : lengthFrame
         frame(k,n) = ampl((k-1)* lengthFrame+n-1);
    end
end    
for k = 1: numberFrames
    for n = 2 : lengthFrame
        preproframes(k,n) = frame(k,n)-mean(frame(k,:))- 0.96*(frame(k,n-1)-mean(frame(k,:)));
    end
end
EnergyFrames = zeros(1,numberFrames);
minDelay = round(2*frc/1000);
maxDelay = round(frc/50);
R = zeros(1, maxDelay - minDelay);
M = zeros(1,numberFrames);
L = zeros(1,numberFrames);
vad1 = zeros(1,numberFrames);

for k = 1:numberFrames-1
    EnergyFrames(k) = sum(preproframes(k,:).^2);%sum(ampl((k-1) * lengthFrame +1:k*lengthFrame).^2);
    for m = minDelay:maxDelay
        R(k,m) = sum(preproframes(k,1:lengthFrame - m).*preproframes(k,1+m:lengthFrame))/EnergyFrames(k);
    end
    M(k) = max(R(k,:));
    end

levNois = -log(1-mean(M(1:min(100,round(numberFrames/5)))));
if levNois > 0.005
    koef = 2;
else
    koef = 9;
end    
for k = 1:numberFrames
   L(k) = -log(1-M(k)); 
   if L(k) > koef * levNois 
      vad1(k) =1;
   else   
      vad1(k) = 0;
   end
end

vad = numberFrames-1;
for j = 1:numberFrames-1
  for k = 1:lengthFrame
    vad((j-1)*(lengthFrame-1) +k) = vad1(j);
  end
end

