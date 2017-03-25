for a=1:length(algs)
    for i=1:length(wt)
        wallTime(a,i)=wt(i).(algs{a});
    end
end