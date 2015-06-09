function Analyze =  VAD_comparing2_09_06_15_(audifile,addnoice,addnoice1,addnoice2,addnoice3)
%addnoice = 0|.01|.02|.03|.05 - coef. of level of noice for first recorder
%addnoice1 = 0|.01|.02|.03|.05 - coef. of level of noice for second recorder
%...
[ampl,~] = audioread(audifile);
noicelySigal = ampl+addnoice*randn(size(ampl));
ampl1 = addnoice*randn(size(ampl));%noice, wich is added.
signal = ampl;
ampl = noicelySigal;

[~,vad12] = stat1VAD_h(audifile,addnoice,2,2,0.97,1);
X12 = vad12;
[~,vad12] = stat1VAD_h(audifile,addnoice1,2,2,0.97,1);
X121 = vad12;
%L_F_SqwenrgyVAD = sum( abs(X12 - X121))
%numberVoiceFrameSqwenrgyVAD = sum(X12)
alg(1).name = 'stat1_h_dd_VAD';
alg(1).numberVoiceFrames = sum(X12);
alg(1).numberLostAndFaluerFframes = [sum( abs(X12 - X121)),addnoice,addnoice1];
alg(1).numberLostFframes = (alg(1).numberLostAndFaluerFframes(1) + sum(X12 - X121))/2;
alg(1).ratio_Errors_to_Voice_Fframes = alg(1).numberLostAndFaluerFframes(1)/alg(1).numberVoiceFrames;
[~,vad11] = stat1VAD_f_27_04_15(audifile,addnoice,2,2,0.97);
X11 = vad11;
[~,vad11] = stat1VAD_f_27_04_15(audifile,addnoice1,2,2,0.97);
X111 = vad11;
%L_F_SqwenrgyVAD = sum( abs(X12 - X121))
%numberVoiceFrameSqwenrgyVAD = sum(X12)
alg(3).name = 'stat1_dd_VAD';
alg(3).numberVoiceFrames = sum(X11);
alg(3).numberLostAndFaluerFframes = [sum( abs(X11 - X111)),addnoice,addnoice1];
alg(3).numberLostFframes = (alg(1).numberLostAndFaluerFframes(1) + sum(X11 - X111))/2;
alg(3).ratio_Errors_to_Voice_Fframes = alg(1).numberLostAndFaluerFframes(1)/alg(1).numberVoiceFrames;

[~,vad14] = stat1VADe(audifile,addnoice);
X14 = vad14;
[~,vad14] = stat1VADe(audifile,addnoice1);
X141 = vad14;
%L_F_stat1VAD = sum( abs(X14 - X141))
%numberVoiceFramestat1VAD = sum(X14)
alg(4).name = 'stat1_ml_VAD';
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
Y2 = stat1VAD_f_27_04_15(audifile,addnoice,2,2,0.97);
Y1 = weakfricdetVADe(audifile,addnoice);
subplot(2,2,1)
plot(stat1VAD_h(audifile,addnoice,2,2,0.97,1),'k'),hold on
plot(Y1.*1.2,'m'),legend('stat ha dd VAD','weakfricdetVAD'),hold on
plot(Y2.*1.4,'c'),hold on
plot(stat1VADe(audifile,addnoice).*1.6,'r'),hold on
%plot(stat1VAD_h(audifile,addnoice1,2,2,0.97,1),'k'),hold on%plot(vad.*1.4,'c'),hold on
plot(signal,'g'),hold on
plot(ampl1,'y'),hold on
plot(ampl,'b'), title('X Without additional noice(N)'),hold off

subplot(2,2,2)
%plot(avcorpeak2e_09_04_15_VAD(audifile,addnoice1).*1.4,'c'),
%hold on ,
%plot(weakfricdetVADe(audifile,addnoice1).*1.2,'m'),hold on
plot(stat1VAD_h(audifile,addnoice1,2,2,0.97,1),'k'),hold on
plot(weakfricdetVADe(audifile,addnoice1).*1.2,'m'),hold on
plot(Y2.*1.4,'c'),hold on
plot(stat1VADe(audifile,addnoice1).*1.6,'r'),hold on
legend('1','2','stat dd VAD','stat ml VAD')
title('Fig12. X+ N')
plot(signal,'g'),hold on
plot(ampl1,'y')
hold on,plot(ampl,'b'),hold off
subplot(2,2,3)
%plot(sqwenrgyVADe(audifile,addnoice2),'k'),
hold on,
plot(weakfricdetVADe(audifile,addnoice2).*1.2,'m'),hold on
plot(stat1VAD_h(audifile,addnoice2,2,2,0.97,1),'k'),hold on,title('Fig13. X + 2*N')
plot(stat1VADe(audifile,addnoice2).*1.6,'r'),hold on%,legend('stat1 dd VAD')
plot(Y2.*1.4,'c'),hold on
plot(weakfricdetVADe(audifile,addnoice2).*1.2,'m'),hold on
%plot(avcorpeak2e_09_04_15_VAD(audifile,addnoice2).*1.4,'c'),
%hold on
plot(signal,'g'),hold on
plot(ampl1,'y')
hold on,plot(ampl,'b'),hold off
subplot(2,2,4)
%plot(stat1VADe(audifile,addnoice3).*1.6,'r'), legend('stat1VAD'),hold on
plot(weakfricdetVADe(audifile,addnoice3).*1.2,'m'),hold on
plot(stat1VAD_h(audifile,addnoice3,2,2,0.97,1).*0.9,'k'),hold on
plot(Y2.*1.4,'c'),hold on
plot(stat1VADe(audifile,addnoice3).*1.6,'r'),hold on
title('Fig.14 X+3*N')
plot(weakfricdetVADe(audifile,addnoice3).*1.2,'m'),hold on
%plot(avcorpeak2e_09_04_15_VAD(audifile,addnoice3).*1.4,'c'),
hold on
plot(signal,'g'),hold on
plot(ampl1,'y')
hold on,plot(ampl,'b'),hold off


