function [ anom, clim ] = remove_mon_clim( var_mon, mon, clim )
% [ anom, clim ] = remove_mon_clim( var_mon, mon, clim )
% 
% removes the monthly climatology from a time-series, 2-D field or 3-D field
%
% input:
%
% var_mon	vector, or matrix representing a time-series(vector) or 2-D or 3-D time-varying field
%		the first dimension must be time (with monthly resolution), all other dimensions can be in any order
%
% mon		(optional) vector with the months (1 to 12) of each monthly fields in var_mon.
%		the function also accepts a two-column matrix with year and mon
%		the function will assumme that first field corresponds to January if this argument is not passed
%
% clim		(optional) monthly climatology to remove from var_mon. 
%		the function will compute the monthly climatology if this argument is not passed
%
% output:
%
% anom		anomaly computed by removing clim from var_mon
%
% clim		monthly climatology to removed from var_mon to obtain anom
%


calc_clim = 1;

if nargin == 1
	mon = mod(1 : size( var_mon,1 ),12);
	mon(find(mon==0))=12;
end

if nargin <= 2
	clim = [];
end

if nargin == 3
	if ~isempty( clim )
		calc_clim = 0;
	end
end

anom = [];

% does some understanding of the 'mon' argument. it will try to identify if any column contains month values, i.e. 1,2,....12
% if not, it will produce an error
found_mon_col = 0;
if ~isvector( mon )
	for l = 1 : size(mon,2)
		k = find( mon(:,l)>=1 & mon(:,l)<=12 );
		if length(mon) == length(k)
			% this is the month column!
			mon = mon(:,l);
			found_mon_col = 1;
			break
		end
	end
else
	k = find( mon>=1 & mon<=12 );
	if length(mon) == length(k)
		found_mon_col = 1;
	end
end

if ~found_mon_col
	error('unable to find month column')
	return
end

anom = NaN .* ones( size( var_mon ) );

if length(find(isnan(var_mon))) > 0
	rem_trend_clim = 0;
else
	rem_trend_clim = 1;
end

if sum( size( var_mon ) > 1 ) == 1 & rem_trend_clim == 1
	var_mon_dt = detrend(var_mon) + nanmean(var_mon);
else
	var_mon_dt = var_mon;
end

for m = 1 : 12

	%l = m + 0 : 12 : length( var_mon );
	l = find( mon == m );

	if calc_clim
		switch ndims(var_mon)
			case 2
				if sum( size( var_mon ) > 1 ) == 1
					% vector
					clim( m ) = nanmean( var_mon_dt( l ) );
				else
					% 2-D matrix
					clim( m, : ) = nanmean( var_mon( l, : ) );
				end
			case 3
				clim( m, :, : ) = nanmean( var_mon( l, :, : ) );
			case 4
				clim( m, :, :, : ) = nanmean( var_mon( l, :, :, : ) );
		end
	end

	%if sum( size( var_mon ) > 1 ) == 1
	%	anom( l ) = var_mon( l ) - clim( m );
	%else
	%	anom( l, : ) = var_mon( l, : ) - repmat( clim( m, : ), [ length(l) 1 ]);
	%end

	switch ndims(var_mon)
		case 2
			if sum( size( var_mon ) > 1 ) == 1
				anom( l ) = var_mon( l ) - clim( m );
			else
				%anom( l, : ) = var_mon( l, : ) - repmat( clim(m), [ length(l) 1 ]);
				anom( l, : ) = var_mon( l, : ) - repmat( clim(m), [ length(l) size(var_mon,2) ]);
			end
		case 3
			anom( l, :, : ) = var_mon( l, :, : ) - repmat( clim( m, :, : ), [ length(l) 1 ]);
		case 4
			anom( l, :, :, : ) = var_mon( l, :, :, : ) - repmat( clim( m, :, :, : ), [ length(l) 1 ]);
	end

end
