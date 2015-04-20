function  soundrecordings(varargin)

%N = 0.01 *randn(size(audioread(varargin{1})));
N1 = 0.01 *randn(size(audioread(varargin{2})));
X = audioread(varargin{1});
X1 = audioread(varargin{2});
%T = (3.8:.1:5.8);
%Mx = T.*0-.2;
%D = T.*0;
%My = (-1:.1:1);
subplot(2,2,1)
plot(X,'b'),title('Fig.1. First recording in a  realistic environment(X1)')
%hold on,plot(D+1,My,'k +')
hold off
subplot(2,2,2)
plot(X1,'b'),title('Fig.2. Second recording in a  realistic environment(X2)')
%hold on,plot(D+1,My,'k +')
hold off
audifile = varargin{1};
audifile1 = varargin{2};
addnoice3 = 0;
subplot(2,2,3)
plot(stat1VADe(audifile,addnoice3).*3.75,'r'),hold on, legend('stat1VAD')
plot(weakfricdetVADe(audifile,addnoice3).*2,'m'),hold on,% legend('weakfricdetVAD')
plot(sqwenrgyVADe(audifile,addnoice3),'k'),hold on, %legend('sqwenrgyVAD')

plot(avcorpeak2e_09_04_15_VAD(audifile,addnoice3).*3,'c'),hold on,% legend('avcorpeak2e_09_04_15_VAD')
hold on,plot(X,'b'),hold off
title('Fig3. VADs for X1')

subplot(2,2,4)
plot(weakfricdetVADe(audifile1,addnoice3).*1.2,'m'),hold on, legend('weakfricdetVAD')
plot(sqwenrgyVADe(audifile1,addnoice3),'k'),hold on,% legend('sqwenrgyVAD')
plot(stat1VADe(audifile1,addnoice3).*1.6,'r') ,hold on %legend('stat1VAD'),hold on
plot(avcorpeak2e_09_04_15_VAD(audifile1,addnoice3).*1.374,'c'),hold on,% legend('avcorpeak2e_09_04_15_VAD')
title('Fig4. VADs for X2')
hold on,plot(X1,'b'),hold off
N = (X-X)+randn(size(X)).*0.01;
figure
subplot(5,2,1)
plot(N,'r'),title('Fig5a. N'),axis([0 80000 -1 1])
subplot(5,2,2)
plot(N,'r'),title('Fig5b. N')
subplot(5,2,3)
plot(X,'g'),title('Fig6a.Real noice from "prob1.wav"'),axis([0 80000 -0.03 0.03])
subplot(5,2,4)
plot(X1,'g'),title('Fig6b.Real noice from "Speech.wav"%'),axis([0 150000 -0.01 0.01])
subplot(5,2,5)
plot(X+N,'b'),title('Fig7a. X1+N'),axis([0 80000 -0.06 0.06])

subplot(5,2,6)
plot(X1+N1,'b'),title('Fig7b. X2+N'),,axis([0 150000 -0.05 0.05])

subplot(5,2,7)
plot(X+N.*2,'b'),title('Fig8a. X1+2*N')

subplot(5,2,8)
plot(X1+N1.*2,'b'),title('Fig8.b. X2+2*N')

subplot(5,2,9)
plot(X+N.*3,'b'),title('Fig9a. X1+3*N')

subplot(5,2,10)
plot(X1+N1.*3,'b'),title('Fig9b. X2+3*N') 


end

