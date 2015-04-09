function mysimpleVAD(audifile)
[ampl,frc] = audioread(audifile);
numberFrames1=round(size(ampl)/(frc/20));
numberFrames = numberFrames1(1);
lengthFrame=round(frc/20);
frame = ones(numberFrames,lengthFrame)';
%preproframes = zeros(numberFrames,lengthFrame);
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
for k= 1:numberFrames
ind(k) = sum(abs(FRAME(:,k)).^2./varNoice(:,1)-log(varNoice(:,1))-1);
end

for k = 1:numberFrames
  % max(ind(1:min(20,round(numberFrames/5))))
   if ind(k) > 3.055*max(ind(1:min(20,round(numberFrames/5))))  %0.02;
      vad1(k) =100;
   else   
      vad1(k) = 0;
   end
end
mean( varNoice(n,1))   
mean(ind(1:min(20,round(numberFrames/5))))
%vad = zerosnumberFrames-1;
for j = 1:numberFrames-1
  for k = 1:lengthFrame
    vad((j-1)*(lengthFrame-1) +k) = vad1(j);
  end
end
plot(vad)
hold on,plot(ampl.*200),hold off 

