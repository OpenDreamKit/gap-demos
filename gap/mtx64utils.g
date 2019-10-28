
ParMult := function(m1, m2)
    MTX64_WriteMatrix(m1,"a");
    if IsIdenticalObj(m1,m2) then
        MTX64_fMultiply(".","a","a","c");
    else
        MTX64_WriteMatrix(m2,"b");
        MTX64_fMultiply(".","a","b","c");
    fi;
    return MTX64_ReadMatrix("c");
end;

MTX64_KroneckerProduct := function(mat1, mat2)
    local  n1, m1, n2, m2, n, m, f, mat, i, j;
    n1 := MTX64_NumRows(mat1);
    m1 := MTX64_NumCols(mat1);
    n2 := MTX64_NumRows(mat2);
    m2 := MTX64_NumCols(mat2);
    n := n1*n2;
    m := m1*m2;
    f := MTX64_FieldOfMatrix(mat1);
    mat := MTX64_NewMatrix(f, n, m);
    for i in [1..n1] do
        for j in [1..m1] do
            MTX64_DPaste(mat2*mat1[i,j], n2*(i-1),  n2, 
                    n1*(j-1), mat);
        od;
    od;
    return mat;
end;

  
 
    
        
