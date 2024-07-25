function Index = findIndexStrCell( strCell, findStr )
IndexC = strfind(strCell,findStr);
Index_b = find(not(cellfun('isempty',IndexC)));
Index = [];
for kk=1:length(Index_b)
	if strcmp(strCell{Index_b(kk)},findStr)
		Index = Index_b(kk);
		return
	end		
end
