ls *.sac | awk '{print "taup_setsac -ph p-0 -evdpkm " $1}' > p_arrival.taup
sh -v p_arrival.taup

matlab -nodesktop -nosplash << END
addpath('~/lib')
find_empty_headers('t0')
quit
END

for k in `cat tmp2`; do grep $k p_arrival.taup; done > p_arrival2.taup
sed 's/p-/P-/g' p_arrival2.taup > tmp3; mv tmp3 p_arrival2.taup; rm tmp*
sh -v p_arrival2.taup
