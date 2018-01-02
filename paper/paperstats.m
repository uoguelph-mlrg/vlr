function [] = paperstats()
h = hypdef_final;
names = {'i15','m16','VLR'};
o{1} = load('data/misc/i15-mantoman.mat');
o{2} = load('data/misc/m16-mantoman.mat');
o{3} = load(h.save.name,'o'); o{3} = o{3}.o;
tests.rank.pair = @(x1,x2)signrank([x1(:)-x2(:)]);
tests.rank.unpr = @(x1,x2)ranksum(x1(:),x2(:));

mansi = arrayfun(@(i)median(o{i}.si,2),1:2,'un',0); mansi = cat(1,mansi{:});
statscompare(tests.rank.unpr,{o{1}.si(:),o{3}.si(:)},'i15:VLR',{'ALL'});
statscompare(tests.rank.unpr,{o{2}.si(:),o{3}.si(:)},'m16:VLR',{'ALL'});
statscompare(tests.rank.unpr,{mansi,o{3}.si(:)},'man:VLR',{'ALL'});