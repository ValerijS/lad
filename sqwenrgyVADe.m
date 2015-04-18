function [vad2, vad12] = mysimpleVAD(audifile,addnoice)
[pr1,frc] = audioread(audifile);
lengthFrame=round(frc/100);
numberFrames=round(length(pr1)/lengthFrame);
%for k =1:min(20,round(numberFrames/5))
%pr2(k) = sum(pr1((k-1) * lengthFrame +1:k*lengthFrame).^2);
%end

pr1 = pr1+ addnoice *randn(size(audioread(audifile)));



%frame = ones(numberFrames,lengthFrame)';
for k =1:numberFrames -1
pr(k) = sum(pr1((k-1) * lengthFrame +1:k*lengthFrame).^2);
end

levNois = mean(pr(1:min(100,round(numberFrames/5))));

levNois;
if levNois > 0.01
    koef = 35;
else
    koef = 50;
end    
for k = 1:numberFrames-1
if pr(k) > koef* levNois
vad12(k) = 1;
else
vad12(k) = 0;
end
end
for k = 1:numberFrames-1
for j = 1:lengthFrame
vad2((k-1)*lengthFrame +j) = vad12(k);
end
end

