% determine how many months does the saving of
% interest overtaken the cost of points.
% assuem 30 years loan, 2% annual inflation

compRates = [6.99, 7.125, 7.125, 7.375, 7.49]/12/100;
%compRates = [6.99, 7.125, 7.25, 7.49]/12/100;

baseRates = ones(1,length(compRates))*7.49/12/100;
rateCosts = [4325, 2703, 1605, 660, 0];
%rateCosts = [4231, 2613, 2224, 0];

for i = 1:length(compRates)
    fprintf("Rates = %.3f\n", compRates(i)*12*100);
    breakevenmonths(baseRates(i), compRates(i), rateCosts(i));
end

function idx = breakevenmonths(baseRate, compRate, rateCost)
% function to determine how many months does it take for purchasing points
% break even.
totalMonths = 30 * 12;
loanAmount = 335000;

[~, monthlyIntBase, ~, ~] = amortize (baseRate, totalMonths, loanAmount);
[~, monthlyIntComp, ~, ~] = amortize (compRate, totalMonths, loanAmount);
monthlyIntBase = monthlyIntBase';
monthlyIntComp = monthlyIntComp';

% if inflation.
r = 0.02; % annual inflation rate
rm = (1+r)^(1/12) - 1; % if no inflation, set it 0;
rvec = (1-rm).^(0:359);
rvec = rvec';

monthlyIntBaseAdj = monthlyIntBase .* rvec;
monthlyIntCompAdj = monthlyIntComp .* rvec;

cumIntBaseAdj = cumsum(monthlyIntBaseAdj);
cumIntCompAdj = cumsum(monthlyIntCompAdj);

diff = cumIntCompAdj - cumIntBaseAdj;
idx = find((diff + rateCost) < 0 ,1);
if isempty(idx)
    idx = inf; % no match found
end

fprintf("It takes %d months to break even.\n", idx)
end