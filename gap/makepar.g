Setup := function(g)
    local  n, r, h, sos, orbitals, pairing, nsos, norbitals, i, j, sv, 
           x, m, o, suborbs, sov;
    n := LargestMovedPoint(g);
    r := RankAction(g);
    h := Stabilizer(g,1);
    sos := OrbitsDomain(h,[1..n]);
    orbitals := List(sos, so -> MakeImmutable(Set(Orbit(g, [1,so[1]], OnPairs))));
    pairing := List(sos, so -> PositionProperty(orbitals, o -> [so[1],1] in o));
    nsos :=[];
    norbitals := [];    
    for i in [1..r] do
        j := pairing[i];
        if j = i then
            Add(nsos,sos[i]);
            Add(norbitals,orbitals[i]);            
        elif j > i then
            Add(nsos, Union(sos[i],sos[j]));
            Add(norbitals, Union(orbitals[i],orbitals[j]));
        fi;
    od;
    r := Length(nsos);
    
    sv := [];
    for i in [1..r] do
        for x in nsos[i] do
            sv[x] := i;
        od;
    od;
    m := List([1..r], i -> NullMat(r, n));
    for j in [1..r] do
        o := norbitals[j];
        for x in o do
            m[sv[x[1]]][j][x[2]] := 
              m[sv[x[1]]][j][x[2]] +1;
        od;
    od;
    return rec(g := g, n := n, rank := r,
               suborbs := nsos, mat := m,
               sov := sv,
               orbitals := norbitals);
end;


    
MakeParams := function( setup, fn)
    local  s, r, n;
    s := [];
    r := setup.rank;
    n := setup.n;    
    Append(s, ["letting n be ",String(n),
            "\nletting r be ",String(r),"\nletting suborb be "]);
    Add(s,String(setup.sov));
    Add(s,"\nletting m be ");
    Add(s,String(setup.mat));
    Add(s,"\n");
    FileString(fn, Concatenation(s));
end;

Works := function(setup, partn, i, j, k, m)  
    local x,v;        
    v := m[i][j];    
    x := v[setup.suborbs[partn[k][1]][1]];
    return ForAll(partn[k], k1 -> ForAll(setup.suborbs[k1], y->
                   v[y] = x));
end;

partmat := function(setup, partn)
    local  l;
    l := Length(partn);
    return List([1..l], i-> Sum(partn[i], i1 -> List([1..l], j->Sum(partn[j], j1 -> setup.mat[i1][j1]))));
end;


TestPartition := function( setup, partn )
    local  l, m;
    if not ForAny(partn, p -> 1 in p) then
        partn := Concatenation([[1]], partn);
        MakeImmutable(partn);
    else
        partn := Immutable(partn);
    fi;
    l := Length(partn);
    m := partmat(setup, partn);    
    return ForAll([1..l], i->
                  ForAll([1..l], j-> ForAll([1..l], k -> Works(setup, partn, i,j,k, m))));
end;

BadSpots := function(setup, partn)
    local  l, m;
    l := Length(partn);
    m := partmat(setup, partn);    
    return Filtered(Cartesian([1..l],[1..l],[1..l]), 
                   t -> not Works(setup, partn, t[1], t[2], t[3], m));
end;

   
Forbidden := function(badspots, partn2) 
    local  b, p, q, r, rpart, qpart, ppart;
    if ForAny(badspots, b -> IsSubset(partn2,[[b[1]],[b[2]],[b[3]]] )) then
        return true;
    fi;
    for b in badspots do
        p := b[1];
        q := b[2];
        r := b[3];
        if p in partn2 and q in partn2 then
            rpart := First(partn2, x->r in x);
            if ForAll(rpart, r2 -> r2 = r or not [p,q,r2] in badspots) then
                return true;
            fi;
        elif p in partn2 and r in partn2 then
            qpart := First(partn2, x->q in x);
            if ForAll(qpart, q2 -> q2 = q or not [p,q2,r] in badspots) then
                return true;
            fi;
        elif q in partn2 and r in partn2 then
            ppart := First(partn2, x->p in x);
            if ForAll(ppart, p2 -> p2 = p or not [p2,q,r] in badspots) then
                return true;
            fi;
        fi;
    od;
    return false;
end;

        
cands := function(degs, ranks)
    local  gs, ss;
    gs := AllPrimitiveGroups(DegreeAction, degs, RankAction, ranks, IsNaturalAlternatingGroup, false, IsNaturalSymmetricGroup, false,
                  IsAlmostSimple, true
                  );
    ss := List(gs, Setup);
    return Filtered(ss, s->not TestPartition(s, List([1..s.rank], i->[i])));
end;

        
Brute := function(s)
    return Filtered(PartitionsSet([2..s.rank]), p -> TestPartition(s,p));
end;

  
    
    
    
