function baseTile = getBaseTile()
%gives back the structure baseTile which contains the location of the
%optodes. a,b,c emitters, 1-4 mirrors. optode 3 signals the center.
baseTile.optode_1 = [0,8.880,0]; %detector 1
baseTile.optode_2 = [7.690,-4.440,0]; %detector 2
baseTile.optode_3 = [0,0,0]; %detector 3
baseTile.optode_4 = [-7.690,-4.440,0]; %detector 4
baseTile.optode_a = [0,-10.810,0]; % source 1
baseTile.optode_b = [9.361,5.405,0]; %source 2
baseTile.optode_c = [-9.361,5.405,0]; %source 3

