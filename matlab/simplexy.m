close all;
clear all;

f = '../data/1430258910-example.csv';

header_lines = 1;

unix_time = get_csvcol(f, header_lines, 1);
dat_tempc = get_csvcol(f, header_lines, 9);

dummyx = (unix_time/86400 + datenum(1970,1,1));


% Create the plot
hold on;
box on;
plot(dummyx, dat_tempc,'-k')
set(gca, 'YLim', [10, 35])
title('Time vs. Temperature ', 'FontSize', 16)
xlabel('Time (s)', 'FontSize', 14)
ylabel('Temperature (C) ', 'FontSize', 14)

datetick('x','MM:SS')

%set(gca, 'XTick', dummyx);
%set(gca, 'XTickLabel', labels);

hold off;