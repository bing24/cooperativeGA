clear all
close all

first_gene=round(4*rand(200,1));

initialx=5;
initialy=7;

for i=1:length(first_gene)
	if i==1
		currentx(i)=initialx;
		currenty(i)=initialy;
	elseif first_gene(i)==1
currentx(i)=currentx(i-1);
currenty(i)=currenty(i-1)+1;
	elseif first_gene(i)==2
currentx(i)=currentx(i-1)-1;
currenty(i)=currenty(i-1);
	elseif first_gene(i)==3	
currentx(i)=currentx(i-1);
currenty(i)=currenty(i-1)-1;
	elseif first_gene(i)==4
currentx(i)=currentx(i-1)+1;
currenty(i)=currenty(i-1);
	elseif first_gene(i)==0
currentx(i)=currentx(i-1);
currenty(i)=currenty(i-1);		
		end

	end

	
plot(currentx,currenty)