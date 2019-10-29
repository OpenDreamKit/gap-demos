takesList := ["args", "statements"];


InstallMethod(DisplayString, [IsSyntaxTree],
        function(t)
    local  addDisplayStrings, s;
    addDisplayStrings := function(s, trec)
        local  first, n, first2, e;
        Add(s, trec.type);
        Add(s, "(\>\>");
        first := true;        
        for n in NamesOfComponents(trec) do
            if n = "type" then
                continue;
            fi;
            if not first then
                Add(s, ", ");
            else
                first := false;                
            fi;            
            Add(s, n);
            Add(s, " := ");
            if IsRecord(trec.(n)) then
                addDisplayStrings(s,trec.(n));
            elif n in takesList then
                Add(s,"[\>\>");
                first2 := true;                
                for e in trec.(n) do
                    if not first2 then
                        Add(s,", ");
                    else
                        first2 := false;
                    fi;
                    addDisplayStrings(s,e);
                od;
                Add(s,"\>\>]");                
            else
                Add(s, String(trec.(n)));                
            fi;
        od;
        Add(s,"\<\<)");
        return s;
    end;
    s := [];
    addDisplayStrings(s, t!.tree);
    Add(s,"\n");
    return Concatenation(s);
end);

STMatch := function(tree,pattern) 
    local  addMatches, matches;
    addMatches := function(matches, tree, pattern)
        local  nc, n, l, i;
        if tree = pattern then
            return true;
        fi;        
        if IsString(pattern) and pattern[1] = '$' then
#            Print("XXX ",pattern," ",tree,"\n");            
            matches.(pattern) := tree;
            return true;            
        fi;
        if not IsRecord(tree) then
            return false;
        fi;        
        nc := NamesOfComponents(tree);
        if nc <> NamesOfComponents(pattern) then
            return false;
        fi;
        for n in nc do
            if IsRecord(tree.(n)) then
                if not addMatches(matches, tree.(n), pattern.(n)) then
                    return false;
                fi;
            elif n in takesList then
                if not IsList(pattern.(n)) or not IsList(tree.(n)) then
                    Error("Expecting Lists");
                fi;
                l := Length(pattern.(n));
                if l <> Length(tree.(n)) then
                    return false;
                fi;
                for i in [1..l] do
                    if not addMatches(matches, tree.(n)[i], pattern.(n)[i]) then
                        return false;
                    fi;
                od;
            else
                if not addMatches(matches, tree.(n), pattern.(n)) then
                    return false;
                fi;
            fi;
        od;
        return true;
    end;
    matches := rec();
    if addMatches(matches, tree, pattern) then
        return matches;
    else
        return false;
    fi;
end;

STFind := function(tree, pattern...)
    local  findAll, finds, addFinds;
    if Length(pattern) >= 2 then
        findAll := pattern[2];
    else
        findAll := false;
    fi;
    pattern := pattern[1] ;
    finds := [];    
    addFinds := function(finds, tree, pattern, all, path)
        local  matches, nc, n, npath, l, i, nipath;
        matches := STMatch(tree, pattern);
        if matches <> false then
            Add(finds, rec(node := tree, matches := matches, path := Immutable(path)));
            if not all then 
                return true;
            fi;
        fi;
        if not IsRecord(tree) then
            return false;
        fi;        
        nc := NamesOfComponents(tree);
        for n in nc do
            npath := ShallowCopy(path);
            Add(npath, n);            
            if IsRecord(tree.(n)) then
                if addFinds(finds, tree.(n), pattern, all, npath) and not all then
                    return true;
                fi;
            elif n in takesList then
                if not IsList(tree.(n)) then
                    Error("Expecting List");
                fi;
                l := Length(tree.(n));
                for i in [1..l] do
                    nipath := ShallowCopy(npath);
                    Add(npath, i);                    
                    if addFinds(finds, tree.(n)[i], pattern, all, npath) and not all then
                        return true;
                    fi;
                od;
            else
                if addFinds(finds, tree.(n), pattern, all, npath) then
                    return true;
                fi;
            fi;
        od;
        return false;
    end;
    addFinds(finds, tree!.tree, pattern, findAll,[]);
    if findAll then
        return finds;
    elif Length(finds) >= 1 then
        return finds[1];
    else
        return fail;
    fi;
end;

STPatternSubst := function(pattern, match)
    local  subs, n;
#    Print("XXX ",pattern," -> ");    
    if IsString(pattern) and pattern[1] = '$' then
#        Print(match.(pattern),"\n");        
        return match.(pattern);
    fi;
    if not IsRecord(pattern) then
#        Print(Immutable(pattern),"\n");        
        return Immutable(pattern);        
    fi;
    subs := rec();    
    for n in NamesOfComponents(pattern) do
        if n in takesList then
            subs.(n) := List(pattern.(n), x -> STPatternSubst( x, match));
        else
            subs.(n) := STPatternSubst( pattern.(n), match);
        fi;
        
    od;
#    Print(subs,"\n");        
    return subs;
end;

STPatternReplace := function(tree, pattern, replacement)
    local  doReplace;
    doReplace := function(tree, pattern, replacement)
        local  matches, nc, subs, n;
        matches := STMatch(tree, pattern);
        if matches <> false then
#            Print(tree," ", pattern," ",matches,"\n");            
            return STPatternSubst(replacement, matches);            
        fi;
        if not IsRecord(tree) then
            return tree;
        fi;        
        nc := NamesOfComponents(tree);
        subs := rec();        
        for n in nc do
            if n in takesList then
                if not IsList(tree.(n)) then
                    Error("Expecting List");
                fi;
                subs.(n) := List(tree.(n), st -> doReplace(st, pattern, replacement));                
            else
                subs.(n) := doReplace(tree.(n), pattern, replacement);
            fi;
        od;
        return subs;
    end;
    return Objectify( SyntaxTreeType, rec(tree := doReplace(tree!.tree, pattern, replacement)));
end;


                
RewriteFunc := function(f, pattern, replacement)
    return SYNTAX_TREE_CODE(STPatternReplace(SyntaxTree(f), pattern, replacement)!.tree);
end;

IntFix :=   rec( 
                 pattern := rec(type := "EXPR_FUNCCALL_1ARGS", 
                         funcref := rec(type := "EXPR_REF_GVAR", gvar := "Int"),
                         args := [rec(type := "EXPR_QUO", left := "$1", right := rec(type := "EXPR_INT", value := "$2"))]),
                 replace := rec(type := "EXPR_FUNCCALL_2ARGS",
                         funcref := rec(type := "EXPR_REF_GVAR", gvar := "QuoInt"),
                         args := ["$1",rec(type := "EXPR_INT", value := "$2") ]));

AllGlobalGapFunctions :=  Filtered(List(Filtered(NamesGVars(), IsBoundGlobal), ValueGlobal), 
                                  x-> IsFunction(x) and not IsKernelFunction(x));

GapMethods := Flat(List(OPERATIONS, o -> List([0..6], i-> Filtered(List(MethodsOperation(o,i), x-> x.func),
                      x-> IsFunction(x) and not IsKernelFunction(x)))));

        
    
               
                        
        
