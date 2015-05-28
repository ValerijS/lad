function [vad4,vad14,ampl] = stat1VAD_f_28_05_15(audifile,addnoice,sw,s,a)
%if sw=1 -> 'dd(a)' is using,recomendate a = 0.97,if also s=2 -> complicate
%variant othewise - simple.If  sw=2 -> 'ml(s)is using, s- number of frames for avarige 
%for apostSLR, s=1 -> simple "ml" .

[ampl,frc] = audioread(audifile);
noicelySigal = ampl+addnoice*randn(size(ampl));

ampl = noicelySigal;
lengthFrame=round(frc/100);
numberFrames1=round(size(ampl)/lengthFrame);
numberFrames = numberFrames1(1);

frame = ones(numberFrames,lengthFrame)';%format

for k = 1: numberFrames-1
    for n = 1 : lengthFrame
         frame(n,k) = ampl((k-1)* lengthFrame+n);
         
    end %devide sample into frames: frame(n,k)- n'th element of k'th frame.
end
FRAME = fft(frame);%array coef. Furue of y = x + d(x-speech,d- noice) for every frame k, 
%k -collume of array FRAME[lengthFrame,numberFrames] conteins coef. Furue -Y(n,k)
% of sample(vector[lengthFrame])from this frame.
varNoice = ones(lengthFrame,1);% format
varNoice1 = ones(lengthFrame,numberFrames);%format
for n = 1 : lengthFrame
    varNoice(n,1)= mean(abs(FRAME(n,1:min(20,round(numberFrames/5)))).^2);% Var mod coef_
    %_Furue of noise - D(n) (VarD(n)),calculated along first 20 frames.
    varNoice1(n,1:numberFrames)= mean(abs(FRAME(n,1:min(20,round(numberFrames/5)))).^2);%_
    %_VarD(n,k) = VarD(n) (for all k), distributed(dublicated) along all frames for
    %every coef. Furue-n, [array(lengthFrame,numberFrames)].
end 
apostSNR = (abs(FRAME).^2)./varNoice1;% aposteriory SNR (array[lengthFrame
%-numberFrames]), |Y(n,k)|^2/VarD(n,k) .
apostSNR1 = apostSNR; %format for averiged along s frames aposteriory SNR.
apriSNR = (apostSNR-1);%format
A = apriSNR;%format
%nu = apostSNR;%format
nu = (apriSNR./(apriSNR+1)).*apostSNR;

K1 = apriSNR > (apostSNR.*0);
P1 = apriSNR.*K1;

if s == 2
apriSNR(:,1) = (apostSNR(:,1)-1).*(1-a)+a;
nu(:,1) = (apriSNR(:,1)./(apriSNR(:,1)+1)).*apostSNR(:,1);
A(:,1) = (sqrt(nu(:,1))./apostSNR(:,1)).*0.8862.*exp(nu(:,1)./(-2)).*((nu(:,1)+1).*besselk(0,nu(:,1)./2)+nu(:,1).*besselk(1,nu(:,1)./2)).*abs(FRAME(:,1));
%sqrt(abs(varNoice1(:,1)));
for k = 1: numberFrames-1
apriSNR(:,k+1) = (A(:,k).^2./varNoice1(:,k)).*a+ P1(:,k+1).*(1-a); 
%nu(:,k+1) = (apriSNR(:,k+1)./(apriSNR(:,k+1)+1)).*apostSNR(:,k+1);
A(:,k+1) = (sqrt(nu(:,k+1))./apostSNR(:,k+1)).*0.8862.*exp(nu(:,k+1)./(-2)).*((nu(:,k+1)+1).*besselk(0,nu(:,k+1)./2)+nu(:,k+1).*besselk(1,nu(:,k+1)./2)).*abs(FRAME(:,k+1));
end
end
if sw > 1
if s >1
    for k = s :numberFrames

apostSNR1(1: lengthFrame,k) =sum(apostSNR(1: lengthFrame,(k-s+1):k)'./s)';

    end
K = (apostSNR.*((apostSNR1-1)./apostSNR1)-log(apostSNR1)) > (apostSNR1.*0);
P = (apostSNR.*((apostSNR1-1)./apostSNR1)-log(apostSNR1)).*K;     
   
else
%K = (apostSNR.*(apriSNR./(apriSNR+1))-log(apriSNR+1)) > (apostSNR1.*0);
%P = (apostSNR.*(apriSNR./(apriSNR+1))-log(apriSNR+1)).*K;

K = (apostSNR-log(apostSNR)-1) > (apostSNR.*0);
P = (apostSNR-log(apostSNR)-1).*K; 
end
else
%K = (apostSNR.*(apriSNR./(apriSNR+1))-log(apriSNR+1)) > (apostSNR1.*0);
%P = (apostSNR.*(apriSNR./(apriSNR+1))-log(apriSNR+1)).*K;
K = (apostSNR.*apriSNR)./(apriSNR+1)-log(apriSNR+1) > (apostSNR1.*0);
P = ((apostSNR.*apriSNR)./(apriSNR+1)-log(apriSNR+1)).*K;
end

ind = sum(P(:,1:numberFrames))/lengthFrame;


levNois  = mean(ind(s:min(20 + s, round(numberFrames/5))));
if levNois > 1.0
    koef = 4;
else
    koef = 4;
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

plot(ampl,'b'),
hold off 



