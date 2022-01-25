function M = IgnoreSmallErrors(M)
M = M.*(abs(M)>1e-9);
M = double(sym(M));
end

