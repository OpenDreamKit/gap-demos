BenchMark := function(f, args...)
    local  ma, rt, ns, res, r, wall, cpu;
    ma := TotalMemoryAllocated(); 
    rt := Runtime(); 
    ns := NanosecondsSinceEpoch(); 
    res := CallFuncListWrap(f, args);
    r := rec(mem := TotalMemoryAllocated() - ma,
             wall := NanosecondsSinceEpoch() - ns,
             cpu := Runtime() -rt);
    if IsBound(res[1]) then
        r.result := res[1];
    fi;
    return r;
end;


assemble := function(ns, scale, unit)
    local  s;
    if ns mod scale = 0 then
        return Concatenation(String(QuoInt(ns, scale)),unit);
    else 
        s := Concatenation(String(QuoInt(ns, scale)),".");
        if ns mod QuoInt(scale,10) = 0 then
            Append(s, String(QuoInt(ns, QuoInt(scale, 10)) mod 10));
        else
            Append(s, String(QuoInt(ns, QuoInt(scale, 100)) mod 100));
        fi;
        Append(s,unit);
        return s;
    fi;
end;

ns2string := function(ns)
    if ns > 10^9 then
        return assemble(ns, 10^9, "s");
    elif ns > 10^6 then
        return assemble(ns, 10^6, "ms");
    elif ns > 10^3 then
        return assemble(ns, 10^3, "us");
    else
        return assemble(ns, 1, "ns");
    fi;
end;

mem2string := function(bytes)
    if bytes > 2^40 then
        return assemble(bytes, 2^40, "TB");
    elif bytes > 2^30 then
        return assemble(bytes, 2^30, "GB");
    elif bytes > 2^20 then
        return assemble(bytes, 2^20, "MB");
    elif bytes > 2^10 then
        return assemble(bytes, 2^10, "KB");
    else
        return assemble(bytes, 1, "B");
    fi;
end;

ShowBench := function(args...)     
    local  r;
    r := CallFuncList(BenchMark, args);
    Print("wall time: ",ns2string(r.wall)," cpu time: ",
          ns2string(10^6*r.cpu)," memory allocated: ",
          mem2string(r.mem));
    if IsBound(r.result) then
        Print(" result returned\n");
    else
        Print(" no result returned\n");
    fi;
end;

   

AddMat := function(m1, m2)
    local  i;
    for i in [1..Length(m1)] do
        AddRowVector(m1[i], m2[i]);
    od;
end;


ShallowCopyMat := m -> List(m, ShallowCopy);




choprange := function(size, pieces)
    local  block, bigger, ranges, base, i, top;
    block := QuoInt(size,pieces);
    bigger := size mod pieces;
    ranges := [];
    base := 0;
    for i in [1..pieces] do
        top := base + block;
        if i <= bigger then
            top := top+1;
        fi;
        Add(ranges, [base+1..top]);
        base := top;
    od;
    return ranges;
end;


block := function(m, chop1, chop2)
    local  a, b, iranges, jranges, x, i, row, j;
    a := Length(m);
    if a = 0 then
        return [];
    fi;
    b := Length(m[1]);
    iranges := choprange(a,chop1);
    jranges := choprange(b,chop2);
    x := [];    
    for i in [1..chop1] do
        row := [];        
        for j in [1..chop2] do
            Add(row, m{iranges[i]}{jranges[j]});
        od;
        Add(x, row);
    od;
    return MakeImmutable(x);
end;

unblock := function(blocks)
    local  chop1, chop2, a, b, m, ibase, i, itop, jbase, j, jtop, 
           base;
    chop1 := Length(blocks);
    if chop1 = 0 then
        return [];
    fi;
    chop2 := Length(blocks[1]);
    a := Sum([1..chop1], i -> Length(blocks[i][1]));
    b := Sum([1..chop2], j -> Length(blocks[1][j][1]));
    m := NullMat(a,b);
    ibase := 0;    
    for i in [1..chop1] do
        itop := ibase + Length(blocks[i][1]);        
        jbase := 0;
        for j in [1..chop2] do
            jtop := jbase + Length(blocks[1][j][1]);
            m{[ibase+1..itop]}{[jbase+1..jtop]} := blocks[i][j];
            base := jtop;
        od;
        ibase := itop;
    od;
    return m;
end;

              
    

Accumulate := function(op, makebase, tasks) 
    local  i, acc;
    i :=   WaitAnyTask(tasks);
    acc := makebase(TaskResult(tasks[i]));    
    Remove(tasks,i);    
    while Length(tasks) > 0 do
        i := WaitAnyTask(tasks);
        op(acc, TaskResult(tasks[i]));
        Remove(tasks,i);    
    od;
    return acc;
end;

    


MatMulWithTasks := function(m1, m2, chop1, chop2, chop3)
    local  A, B, prodtasks, sumtasks, C;
    
    # divide matrices into blocks
    A := block(m1, chop1, chop2);
    B := block(m2, chop2, chop3);

    # Start chop1*chop2*chop3 multiply tasks
    prodtasks := List([1..chop1], i-> List([1..chop2], j-> 
        List([1..chop3], k -> RunTask(\*, A[i][j],B[j][k]))));
    # And chop1 * chop3 tasks to do the summations, as the products
    # become available
    sumtasks := List([1..chop1], i -> List([1..chop3], k-> 
        RunTask(Accumulate,AddMat,ShallowCopyMat, 
                prodtasks[i]{[1..chop2]}[k])));
    # Finally wait for the summations to complete and assemble the result
    C := List(sumtasks, row -> List(row, TaskResult));
    return unblock(C);
end;

    
ParList := function(l, f...)
    local  func, n, block, blocks;
    func := f[1];    
    n := Length(l);        
    if Length(f) > 1 then
        block := f[2];
    else
        block := n;
    fi;
    if block = n then
        return List(List(l, x->RunTask(func,x)),TaskResult);
    else
        blocks := choprange(n, block);        
        return Concatenation(List(List(blocks, b -> RunTask(List, l{b}, func)),TaskResult));
    fi;
end;

ParFiltered := function(l, f...)
    local  bs, filt, i;
    if Length(f) > 1 then
        bs := ParList(l, f[1], f[2]);        
    else
        bs := ParList(l, f[1]);        
    fi;
    filt := [];    
    for i in [1..Length(l)] do
        if bs[i] then
            Add(filt, l[i]);
        fi;
    od;
    return filt;
    
end;


    
Read("/Users/sal/gap/makepar.g");

ParBrute := function(s)
    return ParFiltered(PartitionsSet([2..s.rank]), p -> TestPartition(s,p),100);
end;


        
