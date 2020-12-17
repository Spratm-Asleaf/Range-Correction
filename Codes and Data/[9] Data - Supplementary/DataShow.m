clear all;
close all;
fclose all;
clc;

%% Load Data
data = load('data.log');
[timeLen, ~] = size(data);

plotTimeIntv = (1:timeLen)*0.1; % sampling time is 0.1

plot(plotTimeIntv, data,'linewidth',2.5);
legend('Range 0','Range 1','Range 2','Range 3','Range 4','Range 5');
xlabel('Time (second)','fontsize',14);
set(gca,'fontsize',14);
axis([15 45 -1 11]);