function mysimpleVAD(audifile)
pr1 = audioread(audifile);
for k =1:length (pr1)/1000
pr(k) = sum(pr1((k-1) * 1000 +1:k*1000).^2);
end
levNois = mean(pr(1:20));
frameLenght = length (pr1)/1000;
for k = 1:frameLenght
if pr(k) > (15* levNois)
vad1(k) = 100;
else
vad1(k) = 0;
end
end
for j = 1:frameLenght
for k = 1:1000
vad((j-1)*1000 +k) = vad1(j);
end
end
plot(vad)
hold on,plot(pr1.*200),hold off
