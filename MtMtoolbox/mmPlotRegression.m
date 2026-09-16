function hp = mmPlotRegression(x,y)
%MMPLOTREGRESSION Add best fit line to scatter plot
%   Inputs: x and y should be 
arguments
    x {mustBeNumeric, mustBeVector}
    y {mustBeNumeric, mustBeVector}
end


% calculate the regression line
p = polyfit(x, y, 1);  % creates best fit line (returns slope and intercept)
xFit = linspace(min(x), max(x), 100); % create a vector of x values from min to max of data
yFit = polyval(p, xFit); % calculate Y values from x using best-fit line

% plot the regression line
hold on
hp = plot(xFit, yFit, 'k-', 'LineWidth', 1, 'DisplayName', 'Best Fit Line');

end