function [h] = ystd2hyp(h,type,args)
h.std.type = type;
h.std.args = args;
h.sam.fresh = 1;
h = hypfill(h);