function [vad4,vad14] = stat1VADe_23_04(audifile,addnoice,s,a)
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
FRAME = fft(frame);%array coef. Furue of y = x + d, for every frame k - 
%collume from lengthFrame coef-Y(n,k)[array(lengthFrame,numberFrames)]
varNoice = ones(lengthFrame,1);% format
varNoice1 = ones(lengthFrame,numberFrames);%format
for n = 1 : lengthFrame
    varNoice(n,1)= var(FRAME(n,1:min(20,round(numberFrames/5))));% Var coef_
    %_Furue of noise - D(n) (VarD(n)),calculated along first 20 frames.
    varNoice1(n,1:numberFrames)= var(FRAME(n,1:min(20,round(numberFrames/5))));%_
    %_VarD(n,k) = Vard(n) (for all k), distributed along all frames for
    %every coef. Furue-n, [array(lengthFrame,numberFrames)].
end 
apostSNR = (abs(FRAME).^2)./varNoice1;% aposteriory SNR [array(lengthFrame
%-numberFrames)], Y(n,k)^2/VarD(n,k) .
apostSNR1 = apostSNR; % averiged along s frames aposteriory SNR.
apriSNR = apostSNR;
A = apriSNR;
nu = (apriSNR./(apriSNR+1)).*apostSNR;
K1 = (apostSNR-1) > (apostSNR.*0);
P1 = (apostSNR-1).*K1; 
A(:,1) = sqrt(abs(varNoice1(:,1)));
for k = 1: numberFrames-1
apriSNR(:,k+1) = (A(:,k).^2./varNoice1(:,k)).*a+ P1(:,k+1).*(1-a);   
A(:,k+1) = (sqrt(nu(:,k+1))./apostSNR(:,k+1)).*0.8862.*exp(nu(:,k+1)./(-2)).*((nu(:,k+1)+1).*besselk(0,nu(:,k+1)./2)+nu(:,k+1).*besselk(1,nu(:,k+1)./2)).*abs(FRAME(:,k+1));
end
if s >1
    for k = s :numberFrames

apostSNR1(1: lengthFrame,k) =sum(apostSNR(1: lengthFrame,(k-s+1):k)'./s)';

    end
K = (apostSNR.*((apostSNR1-1)./apostSNR1)-log(apostSNR1)) > (apostSNR1.*0);
P = (apostSNR.*((apostSNR1-1)./apostSNR1)-log(apostSNR1)).*K;     
   
else
K = (apostSNR.*(apriSNR./(apriSNR+1))-log(apriSNR+1)) > (apostSNR1.*0);
P = (apostSNR.*(apriSNR./(apriSNR+1))-log(apriSNR+1)).*K;      
%K = (apostSNR-log(apostSNR)-1) > (apostSNR.*0);
%P = (apostSNR-log(apostSNR)-1).*K; 
end



ind = sum(P(:,1:numberFrames))/lengthFrame;


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



