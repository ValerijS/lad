function mysimpleVAD(audifile)
[ampl,frc] = audioread(audifile);
numberFrames=size(ampl)/(frc/20);
lengthFrame=frc/20;
for k = 1: numberFrames
    for n = 2 : lengthFrame
         frame(k,n) = ampl((k-1)* lengthFrame+n-1);
    end
end    
for k = 1: numberFrames
    for n = 2 : lengthFrame
        preproframes(k,n) = frame(k,n)-mean(frame(k,:))- 0.96*(frame(k,n-1)-mean(frame(k,:)));
    end
end
for k = 1:numberFrames
    EnergyFrames(k) = sum(preproframes(k,:).^2);%sum(ampl((k-1) * lengthFrame +1:k*lengthFrame).^2)
    for m = round(2*frc/1000):round(frc/50);
        R(k,m) = sum(preproframes(k,1:lengthFrame - m).*preproframes(k,1+m:lengthFrame))/EnergyFrames(k);
    end
    M(k) = max(R(k,:));
end

levNois = -log(1-mean(M(1:min(20,round(numberFrames/5))))) %mean(M(1:20));
for k = 1:numberFrames
   L(k) = -log(1-M(k)); 
   if L(k) > 1.71*levNois;
      vad1(k) =100;
   else   
      vad1(k) = 0;
   end
end


for j = 1:numberFrames-1
  for k = 1:lengthFrame
    vad((j-1)*(lengthFrame-1) +k) = vad1(j);
  end
end
plot(vad)
hold on,plot(ampl.*200),hold off
