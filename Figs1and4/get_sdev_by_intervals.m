function [ sdev, year0 ] = get_sdev_by_intervals( ts, year_mon, nyears, months, overlap_or_rand )

sdev = [];

year = unique(year_mon(:,1));
a = 1;
b = length(year)-nyears+1;

if overlap_or_rand == 0
	% random sampling
	r = floor((b-a).*rand(1000,1) + a);
else
	dyear = overlap_or_rand;
	r = 1:dyear:length(year)-(nyears-dyear);
end

year0 = year(r);

for mm = 1 : length(year0)

	switch upper(months)
		case 'NDJ'
			ll = find( year_mon(:,1) >= year0(mm) & year_mon(:,1) <= year0(mm) + nyears - 1 & ( year_mon(:,2) >= 11 | year_mon(:,2) <= 1 ));
		case 'ALL'
			ll = find( year_mon(:,1) >= year0(mm) & year_mon(:,1) <= year0(mm) + nyears - 1 );
	end

	sdev(mm) = nanstd(ts(ll));

end

