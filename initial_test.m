clear all  
close all

charging_ratio=0.5;
chromo_length=200;
for i = 1: chromo_length
	if charging_ratio <= rand
		chromo(i)=0;
	else
		chromo(i)=ceil(4*rand);
	end
end
		