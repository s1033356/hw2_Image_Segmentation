function T=Otsu(A,m,n)
% format long
uT=mean(mean(A));
P=zeros(256);
F=zeros(256);
H=zeros(256);
for i=1:m  
  for j=1:n  g=1+A(i,j); P(g)=P(g)+1; end;
end
low=min(min(1+A));  high=max(max(1+A));  Th=low;
F(low)=P(low);
for k=low+1:high
  F(k)=F(k-1)+P(k);
end
H(low)=low*P(low);
for k=low+1:high
  H(k)=H(k-1)+k*P(k);
end
HS=H(high);
Jotsu=-1.0;
for k=low+1:high-1
  u0=H(k)/F(k);
  u1=(HS-H(k))/(F(high)-F(k));
  p0=F(k)/F(high); p1=1-p0;
  t=p0*(u0-uT)^2+p1*(u1-uT)^2;
  if (t > Jotsu) Jotsu=t; Th=k; end
end
T=Th-1;