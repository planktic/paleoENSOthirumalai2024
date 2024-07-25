function [ case_name_list, kabp, year_0, year_f ] = get_cesm_case_clim_info( ens_name );

if nargin == 0
	ens_name = 'allforc';
end

case_name_list_file = [ 'case_name_list_clim_info_' ens_name ];

[ case_name_list, kabp, year_0, year_f ] = textread(case_name_list_file,'%s%n%n%n%*[^\n]','delimiter','\t','commentstyle','matlab');
