function  soundrecordings(varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%[X,~] = audioread(varargin{1});
N = 0.01 *randn(size(audioread(varargin{1})));
N1 = 0.01 *randn(size(audioread(varargin{2})));
X = audioread(varargin{1});
X1 = audioread(varargin{2});
T = (3.8:.1:5.8);
%Mx = T.*0-.2;
D = T.*0;
My = (-1:.1:1);
subplot(2,2,1)
plot(X,'b'),title('Fig.1. First recording in a  realistic environment(X1)')
hold on,plot(D+1,My,'k +')
hold off
subplot(2,2,2)
plot(X1,'b'),title('Fig.2. Second recording in a  realistic environment(X2)')
hold on,plot(D+1,My,'k +')
hold off
audifile = varargin{1};
audifile1 = varargin{2};
addnoice3 = 0;
subplot(2,2,3)
plot(stat1VADe(audifile,addnoice3).*4,'r'),hold on, legend('stat1VAD')
plot(weakfricdetVADe(audifile,addnoice3).*2,'m'),hold on,% legend('weakfricdetVAD')
plot(sqwenrgyVADe(audifile,addnoice3),'k'),hold on, %legend('sqwenrgyVAD')

plot(avcorpeak2e_09_04_15_VAD(audifile,addnoice3).*3,'c'),hold on,% legend('avcorpeak2e_09_04_15_VAD')
hold on,plot(X,'b'),hold off
title('Fig3. VADs for X1')

subplot(2,2,4)
plot(weakfricdetVADe(audifile1,addnoice3).*1.2,'m'),hold on, legend('weakfricdetVAD')
plot(sqwenrgyVADe(audifile1,addnoice3),'k'),hold on,% legend('sqwenrgyVAD')
plot(stat1VADe(audifile1,addnoice3).*1.6,'r') ,hold on %legend('stat1VAD'),hold on
plot(avcorpeak2e_09_04_15_VAD(audifile1,addnoice3).*1.4,'c'),hold on,% legend('avcorpeak2e_09_04_15_VAD')
title('Fig4. VADs for X2')
hold on,plot(X1,'b'),hold off
figure
subplot(3,2,1)
plot(X+N,'b'),title('Fig5. X1+N')
hold on,plot(D+1,My,'k +')
hold off
subplot(3,2,2)
plot(X1+N1,'b'),title('Fig6. X2+N')
hold on,plot(D+1,My,'k +')
hold off
subplot(3,2,3)
plot(X+N.*2,'b'),title('Fig7. X1+2*N')
hold on,plot(D+1,My,'k +')
hold off
subplot(3,2,4)
plot(X1+N1.*2,'b'),title('Fig8. X2+2*N')
hold on,plot(D+1,My,'k +')
hold off
subplot(3,2,5)
plot(X+N.*3,'b'),title('Fig9. X1+3*N')
hold on,plot(D+1,My,'k +')
hold off
subplot(3,2,6)
plot(X1+N1.*3,'b'),title('Fig10. X2+3*N') 
hold on,plot(D+1,My,'k +')
hold off


end

