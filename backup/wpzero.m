function wpt_out = wpzero(wpt_in, node_lvl, node_idx)

wpt_out = wpt_in;


for l_idx = 1:length(node_idx)
    
    node = [node_lvl,node_idx(l_idx)];
    
    wpt_out = wpjoin(wpt_out, node);
    cfs = read(wpt_out, 'cfs', node);
    newcfs = zeros(size(cfs));
    wpt_out = write(wpt_out, 'cfs', node, newcfs);    
end