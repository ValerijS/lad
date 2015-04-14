function stat1VAD(audifile)
[ampl,frc] = audioread(audifile);
numberFrames1=round(size(ampl)/(frc/20));
numberFrames = numberFrames1(1);
lengthFrame=round(frc/20);
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
vad1 = 1:numberFrames;
for k = 1:numberFrames
  % max(ind(1:min(20,round(numberFrames/5))))
   if ind(k) > 60000 %9.55*max(ind(1:min(20,round(numberFrames/5))))  %0.02;
      vad1(k) =100;
   else   
      vad1(k) = 0;
   end
end
%mean( varNoice(n,1))   
%max(ind(1:min(20,round(numberFrames/5))))%vad = zerosnumberFrames-1;
vad = ampl;%any vector with same size
for j = 1:numberFrames-1
  for k = 1:lengthFrame
    vad((j-1)*(lengthFrame-1) +k) = vad1(j);
  end
end
plot(vad,'r')
hold on,plot(ampl.*200,'b'),hold off 

