clear all
close all

% chromo=round(4*rand(200,1));

% find(chromo==0);
% countzero=1;
% while sum(chromo(1:count)==chromo(1:count-1))

% 	temp=
% 	count=count+1;
% for i=1:length(chromo)
% 	if sum(chromo(1:i))==sum(chromo(1:i-1))
% 		tempzero=countzero;
% 		countzero=countzero+1;
% % working_period=
% % charging_period=

charging_ratio=0.5;
chromo_length=200;
for i = 1: chromo_length
	if charging_ratio <= rand
		chromo(i,1)=0;
	else
		chromo(i,1)=ceil(4*rand);
	end
end

count=1;
ii=1;
gg=1;
while count < length(chromo)

	if chromo(count) == 0
		cc=1;

		while chromo(count)==0 & count < length(chromo)
			temp(ii)=cc;
			cc=cc+1;
			count=count+1;

		end
		ii=ii+1;
	else 
		dd=1;
		while chromo(count)~=0 & count < length(chromo)
			tempp(gg)=dd;
			dd=dd+1;
			count=count+1;
		end
		gg=gg+1;
	end
end

if length(temp)>length (tempp)
	temp=temp(1:end-1);
elseif length(temp)<length(tempp)
	tempp=tempp(1:end-1);
end
sum(temp>tempp)/length(temp)