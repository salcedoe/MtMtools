function [c] = get_currency(val)
%GET_CURRENCY - converts inputed numeric value into string formatted to
% local currency
%
% adapted from
% https://www.mathworks.com/matlabcentral/answers/32171-function-to-format-number-as-currency 

j = java.text.NumberFormat.getCurrencyInstance();
c = string(j.format(val));

end