function [ case_name_list, kabp, year_0, year_f ] = get_cesm_case_list( ens_name, get_long_cases )

if nargin == 0
	ens_name = 'allforc';
	get_long_cases = 0;
end

case_name_list_file = [ 'case_name_list_' ens_name ];

[ case_name_list, kabp, case_is_long, year_0, year_f ] = textread(case_name_list_file,'%s%n%n%n%n%*[^\n]','delimiter','\t','commentstyle','matlab');

if get_long_cases

	k = find( case_is_long == 1 );
	case_name_list = case_name_list(k);
	kabp = kabp(k);
	year_0 = year_0(k);
	year_f = year_f(k);

end
