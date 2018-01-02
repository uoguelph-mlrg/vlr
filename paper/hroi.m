function [h] = hroi(h,roi)
h.name.key = [h.name.key,'-roi-',roi];
h = hypfill(h);