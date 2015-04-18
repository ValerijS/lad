function Analyze =  VAD_comparing_15_04_15_(audifile,addnoice,addnoice1,addnoice2,addnoice3)
[ampl,frc] = audioread(audifile);
noicelySigal = ampl+addnoice*randn(size(ampl));
ampl1 = addnoice*randn(size(ampl));%noice, wich is added.
signal = ampl;
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

levNois = -log(1-mean(M(1:min(20,round(numberFrames/5)))));
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
[~,vad12] = sqwenrgyVADe(audifile,addnoice);
X12 = vad12;
[~,vad12] = sqwenrgyVADe(audifile, addnoice1);
X121 = vad12;
%L_F_SqwenrgyVAD = sum( abs(X12 - X121))
%numberVoiceFrameSqwenrgyVAD = sum(X12)
alg(1).name = 'sqwenrgyVAD';
alg(1).numberVoiceFrames = sum(X12);
alg(1).numberLostAndFaluerFframes = [sum( abs(X12 - X121)),addnoice,addnoice1];
alg(1).numberLostFframes = (alg(1).numberLostAndFaluerFframes(1) + sum(X12 - X121))/2;
alg(1).ratio_Errors_to_Voice_Fframes = alg(1).numberLostAndFaluerFframes(1)/alg(1).numberVoiceFrames;

%[~,vad12] = sqwenrgyVADe (audifile,addnoice);
X11 = vad1;
[~,vad1] = avcorpeak2e_09_04_15_VAD(audifile, addnoice1);
X111 = vad1;
%L_F_AvcorpeakVAD = sum( abs(X11 - X111));
%numberVoiceFrameAvcorpeakVAD = sum(X11) 
alg(3).name = 'avcorpeakVAD';
alg(3).numberVoiceFrames = sum(X11);
alg(3).numberLostAndFaluerFframes = [sum( abs(X11 - X111)),addnoice,addnoice1];
alg(3).numberLostFframes = (alg(3).numberLostAndFaluerFframes(1) + sum(X11 - X111))/2;
alg(3).ratio_Errors_to_Voice_Fframes = alg(3).numberLostAndFaluerFframes(1)/alg(3).numberVoiceFrames;
[~,vad14] = stat1VADe(audifile,addnoice);
X14 = vad14;
[~,vad14] = stat1VADe(audifile, addnoice1);
X141 = vad14;
%L_F_stat1VAD = sum( abs(X14 - X141))
%numberVoiceFramestat1VAD = sum(X14)
alg(4).name = 'stat1VAD';
alg(4).numberVoiceFrames = sum(X14);
alg(4).numberLostAndFaluerFframes = [sum( abs(X14 - X141)),addnoice,addnoice1];
alg(4).numberLostFframes = (alg(4).numberLostAndFaluerFframes(1) + sum(X14 - X141))/2;
alg(4).ratio_Errors_to_Voice_Fframes = alg(4).numberLostAndFaluerFframes(1)/alg(4).numberVoiceFrames;
[~,vad13] = weakfricdetVADe(audifile,addnoice);
X13 = vad13;
[~,vad13] = weakfricdetVADe(audifile, addnoice1);
X131 = vad13;
alg(2).name = 'weakfricdetVAD';
alg(2).numberVoiceFrames = sum(X13);
alg(2).numberLostAndFaluerFframes = [sum( abs(X13 - X131)),addnoice,addnoice1];
alg(2).numberLostFframes = (alg(2).numberLostAndFaluerFframes(1) + sum(X13 - X131))/2;
alg(2).ratio_Errors_to_Voice_Fframes = alg(2).numberLostAndFaluerFframes(1)/alg(2).numberVoiceFrames;
%numberVoiceFrameweakfricdetVAD = sum(X13)
Analyze = alg;
Y2 = sqwenrgyVADe(audifile,addnoice);
Y1 = weakfricdetVADe(audifile,addnoice);
subplot(2,2,1)
plot(Y1.*1.2,'m'),hold on,legend('weakfricdetVAD')
plot(Y2,'k'),hold on
plot(stat1VADe(audifile,addnoice).*1.6,'r'),hold on
plot(vad.*1.4,'c'),hold on
plot(signal,'g'),hold on
plot(ampl1,'y'),hold on
plot(ampl,'b'), title('X Without additional noice(N)'),hold off

subplot(2,2,2)
plot(avcorpeak2e_09_04_15_VAD(audifile,addnoice1).*1.4,'c'),hold on ,legend('avcorpeakVAD')
plot(weakfricdetVADe(audifile,addnoice1).*1.2,'m'),hold on
plot(sqwenrgyVADe(audifile,addnoice1),'k'),hold on
plot(stat1VADe(audifile,addnoice1).*1.6,'r'),hold on
title('Fig12. X+ N')
plot(signal,'g'),hold on
plot(ampl1,'y')
hold on,plot(ampl,'b'),hold off
subplot(2,2,3)
plot(sqwenrgyVADe(audifile,addnoice2),'k'),hold on,legend('sqwenrgyVAD')
plot(weakfricdetVADe(audifile,addnoice2).*1.2,'m'),hold on
plot(sqwenrgyVADe(audifile,addnoice2),'k'),hold on,title('Fig13. X + 2*N')
plot(stat1VADe(audifile,addnoice2).*1.6,'r'),hold on,legend('sqwenrgyVAD')
plot(avcorpeak2e_09_04_15_VAD(audifile,addnoice2).*1.4,'c'),hold on
plot(signal,'g'),hold on
plot(ampl1,'y')
hold on,plot(ampl,'b'),hold off
subplot(2,2,4)
plot(stat1VADe(audifile,addnoice3).*1.6,'r'), legend('stat1VAD'),hold on
plot(weakfricdetVADe(audifile,addnoice3).*1.2,'m'),hold on
plot(sqwenrgyVADe(audifile,addnoice3),'k'),hold on
title('Fig.14 X+3*N')
plot(avcorpeak2e_09_04_15_VAD(audifile,addnoice3).*1.4,'c'),hold on
plot(signal,'g'),hold on
plot(ampl1,'y')
hold on,plot(ampl,'b'),hold off


