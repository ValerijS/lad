function mysimpleVAD(audifile)
[sampl,frc] = audioread(audifile);
frc1 = round(frc);
frameLenght1 = round(frc1/44.1);
nunberFrame2 = round(frameLenght1/4)-1;
framLength2 = round(frameLenght1/nunberFrame2);

for k = 1:length(sampl)/frameLenght1
   samplInFrame(k,:) = sampl((k-1) * frameLenght1 +1:k*frameLenght1);
end
frc;
for k =1:length(sampl)/frameLenght1
    for t = 1: nunberFrame2
        vecEngForFr(k,t) = sum(samplInFrame(k,(t-1)*4+1:t*4).^2);
    end    
   
end
for k =1:length(sampl)/frameLenght1
    frIndicator(k) = var(vecEngForFr(k,:));
end 
vecEngForFr(40:45,10:15);
levNois = mean(frIndicator(1:20));
frameLenght = length (sampl)/frameLenght1;

for k = 1:frameLenght
if  frIndicator(k) > 333*levNois;
vad1(k) = 100;
else
vad1(k) = 0;
end
end

for j = 1:frameLenght
for k = 1:frameLenght1
vad((j-1)*frameLenght1 +k) = vad1(j);
end
end
plot(vad)
hold on,plot(sampl.*200), hold off
