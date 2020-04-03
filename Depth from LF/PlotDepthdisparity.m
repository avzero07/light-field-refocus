function [  ] = PlotDepthdisparity( figname,gt,dmin,dmax,ftitle )
% [  ] = PlotDepthdisparity( figname,gt,dmin,dmax,ftitle )
% figname is a number to name the figure
% gt id the disparity map
% cmin and dmax are the min and maximum disparities
% ftitle tite of the plot
%   Returns nothing
% Francisco Carlos Calderón M.Sc april 2014
% Creative commons 2.5 share alike by non-commercial
%   calderonfatgmaildotcom
figurex=figure(figname);
colormap('jet');
axes1 = axes('Parent',figurex,'YDir','reverse',...
    'TickDir','out',...
     'Layer','top',...
    'DataAspectRatio',[1 1 1],...
    'CLim',[-dmax -dmin]);
box(axes1,'on');
hold(axes1,'all');
image(gt,'Parent',axes1,'CDataMapping','scaled');
colorbar('peer',axes1);
title(ftitle)
axis off
end

