PackageReleaseDates := function()

local pkgnames, dates, releases, name, r, d;
pkgnames := SortedList(RecNames(GAPInfo.PackagesInfo));
dates := [];
releases := [];

for name in pkgnames do
  r := PackageInfo( name )[1];
  d := List( SplitString( r.Date, "/" ), Int );
  if d = [ fail ] then
    d := List( SplitString( r.Date, "." ), Int );
  fi;
  Add( dates, d );
  Add( releases, [ r.Date, r.PackageName, r.Version ] );
od;
Print("\n");

SortParallel( dates, releases, 
    function(d1,d2) 
    return d1[3] < d2[3] or 
           ( d1[3]=d2[3] and d1[2]<d2[2] ) or 
           ( d1[3]=d2[3] and d1[2]=d2[2] and d1[1]<d2[1] ) ; 
    end );

Print("*** Releases in chronological order:\n");
for r in releases do
  Print( r[1], " : ", r[2], " ", r[3], "\n" );
od;
Print("\n");

return Collected(List(dates,x->x[3]));

end;

PackageReleaseDatesSummary := function(reldates)
local x;
Print("*** Number of packages last updated in specified year:\n");
for x in reldates do
  Print(x[1], " : ", x[2], "\n");
od;
Print("\n");
end;

# SPDX license identifier in PackageInfo.g
PackagesByLicenseType:=function()

local pkgnames, haveSPDXinfo, lackSPDXinfo, x;

pkgnames := SortedList(RecNames(GAPInfo.PackagesInfo));

haveSPDXinfo := Filtered( pkgnames, n -> IsBound( GAPInfo.PackagesInfo.(n)[1].License));
lackSPDXinfo := Filtered( pkgnames, n -> not IsBound( GAPInfo.PackagesInfo.(n)[1].License));

Print("*** ", Length(haveSPDXinfo), " packages have SPDX license identifier in PackageInfo.g\n");
Print("*** ", Length(lackSPDXinfo), " packages have no SPDX license identifier in PackageInfo.g\n\n");

Print("*** Licence types, when SPDX license identifier provided:\n");
for x in  Collected( List( haveSPDXinfo, n -> GAPInfo.PackagesInfo.(n)[1].License) ) do
  Print(x[2], " : ", x[1], "\n");
od;
Print("\n");

end;

# Test files
PackagesStandardTests:=function()

local pkgnames, havetests, lacktests, name;

pkgnames := SortedList(RecNames(GAPInfo.PackagesInfo));

havetests := Filtered( pkgnames, n -> IsBound( GAPInfo.PackagesInfo.(n)[1].TestFile));
lacktests := Filtered( pkgnames, n -> not IsBound( GAPInfo.PackagesInfo.(n)[1].TestFile));

Print("*** ", Length(havetests), " packages have standard test in PackageInfo.g\n");
Print("*** ", Length(lacktests), " packages have no standard test in PackageInfo.g\n\n");

Print("For packages with tests, use the list below for Travis CI tests:\n");
for name in havetests do
  Print("- PKG_NAME=",name,"\n");
od;
Print("\n");

Print("For packages without tests, this is the TODO list to add them:\n");
for name in lacktests do
  Print("- [ ] ", name,"\n");
od;
Print("\n");

end;

# GAPDoc manuals
PackagesManualFormats:=function()

local pkgnames, nogapdoc, nocss, name, d, book;

pkgnames := SortedList(RecNames(GAPInfo.PackagesInfo));

nogapdoc := [ ];
nocss    := [ ];

for name in pkgnames do  
  d := PackageInfo( name )[1].PackageDoc;
  for book in d do
    if IsBound(book.HTMLStart) then
      if EndsWith(book.HTMLStart, "/chapters.htm") then
        Add (nogapdoc, name);
      elif Filename(DirectoriesPackageLibrary( name,"" ),"doc/manual.css") = fail then
        Add (nocss, name);
      fi;
    else
      Print("No HTML version for book ", book.BookName, " in " , name," package\n");
    fi;
  od;  
od;

Print("*** ", Length(pkgnames)-Length(nogapdoc), 
  " packages use GAPDoc (immediately or via AutoDoc) \n\n");
Print("*** ", Length(nogapdoc), " packages do not have GAPDoc-based documentation:\n");
for name in nogapdoc do
  Print("- [ ] ", name, "\n");
od;
Print("\n");

Print("*** ", Length(nocss), " GAPDoc-based manuals miss css files:\n");
for name in nocss do
  Print("- [ ] ", name, "\n");
od;
Print("\n\n");
end;

# Package authors
PackageAuthors:=function()

local pkgnames, authors, names, out, surnames, s, d, n;

pkgnames := SortedList(RecNames(GAPInfo.PackagesInfo));

authors:=List(pkgnames,n->GAPInfo.PackagesInfo.(n)[1].Persons);
authors:=List(authors, a -> List(a, x -> [ x.LastName, x.FirstNames ] ) );
authors:=Concatenation(authors);
authors:=Set(authors);
names:=List(authors, x -> Concatenation( x[2], " ", x[1], ", \<\>" ) );
out:="";
for n in names do
  Append(out, n );
od;
Print("*** Around ", Length(authors), " package authors/maintainers involved\n");
Print("(this is an estimate, and the list may contain duplicates):\n\n");
Print(out);
Print("\n\n");

# Now check for those with same surname and different first names whether 
# they are same persons with different spelling, or different persons.

Print("Authors with the same surname and different first names:\n");
surnames:=Set(List(authors,x -> x[1]));
d:=Filtered(surnames, s -> Number( authors, a -> a[1]=s ) > 1 );
for s in d do
  names := Filtered(authors, a -> a[1]=s);
  names := Concatenation(List(names, x -> Concatenation( x[2], " ", x[1], ", \<\>" ) ) );
  Print(" - ", names,"\n");
od;
Print("\n\n");
 
end;

maplocations := 
[ "", "Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", 
"Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", 
"Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", 
"Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzgovina", "Botswana", "Bouvet Island", 
"Brazil", "British Indian Ocean Territory", "British Virgin Islands", "Brunei", "Bulgaria", 
"Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", 
"Central African Republic", "Chad", "Chile", "China", "Christmas Island", 
"Cocos [Keeling] Islands", "Colombia", "Comoros", "Congo - Brazzaville", "Congo - Kinshasa", 
"Cook Islands", "Costa Rica", "Cote d'Ivoire", "Croatia", "Cuba", "Cyprus", "Czech Republic", 
"Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", 
"Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands", "Faroe Islands", 
"Fiji", "Finland", "France", "French Guiana", "French Polynesia", 
"French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", 
"Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guinea", "Guinea-Bissau",
"Guyana", "Haiti", "Heard Island and McDonald Islands", "Honduras", "Hong Kong SAR China", 
"Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", 
"Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea", "Kuwait", 
"Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", 
"Lithuania", "Luxembourg", "Macau SAR China", "Macedonia", "Madagascar", "Malawi", "Malaysia", 
"Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritiana", "Mauritius", 
"Mayotte", "Mexico", "Micronesia", "Moldova", "Monaco", "Mongolia", "Montserrat", "Morocco", 
"Mozambique", "Myanmar [Burma]", "Namibia", "Nauru", "Nepal", "Netherlands", 
"Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", 
"Niue", "Norfolk Island", "North Korea", "Northern Mariana Islands", "Norway", "Oman", 
"Pakistan", "Palau", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", 
"Pitcairn Islands", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", 
"Russia", "Rwanda", "Saint Helena", "Saint Kitts and Nevis", "Saint Lucia", 
"Saint Pierre and Miquelon", "Saint Vincent and the Grenadines", "Samoa", "San Marino", 
"Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", 
"Singapore", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", 
"South Georgia and the South Sandwich Islands", "South Korea", "Spain", "Sri Lanka", "Sudan", 
"Suriname", "Svalbard and Jan Mayen", "Swaziland", "Sweden", "Switzerland", "Syria", "Taiwan", 
"Tajikstan", "Tanzania", "Thailand", "Timor-Leste", "Togo", "Tokelau", "Tonga", 
"Trinidad and Tobago", "Tunisia", "Turkemenistan", "Turkey", "Turks and Caicos Islands", 
"Tuvalu", "U.K.", "U.S Minor Outlying Islands", "U.S Virgin Islands", "U.S.", "Uganda", 
"Ukraine", "United Arab Emirates", "Uruguay", "Uzbekistan", "Vanuatu", "Vatican City", 
"Venezuela", "Vietnam", "Wallis and Futuna", "Western Sahara", "Yemen", "Zambia", "Zimbabwe" ];

values:=List(maplocations, c -> "0");

# countries, their alternative names, places and developers
# 1) name for `maplocations`
# 2) alternative names that may appear in PackageInfo.g
# 3) places that belong to this country
# 4) developers that work in this country
# 
pkgdata:= [

[ "Australia", 
[ ],
[ "Melbourne","Sydney","Tasmania" ],
[ ] ],

[ "Austria", 
[ ],
[ "Hagenberg" ],
[ "Christof Nöbauer" ] ],

[ "Brazil", 
[ "Brasil" ],
[ ],
[ ] ],

[ "Germany", 
[ "Deutschland", "GERMANY" ],
[ "Aachen","Bielefeld","Braunschweig","Darmstadt","Frankfurt am Main","Kaiserslautern","Munich","Stuttgart" ],
[ "Mohamed Barakat", "Frank Celler", "Andreas Distler", "Sebastian Gutsche", "Sergei Haller", "René Hartung", "Ludger Hippe", "Burkhard Höfling", "Max Horn", "Stefan Kohl", "Frank Lübeck", "Lukas Maas", "Thomas Merkwitz", "Werner Nickel", "Max Neunhöffer", "Richard Rossmanith", "Christian Sievers",  "Helmut Volklein", "Fabian Zickgraf"] ],

[ "Ireland", 
[ ],
[ "Galway" ],
[ ] ],

[ "Italy", 
[ "Catania" ],
[ "Catania", "Trento" ],
[ "Strazzanti Francesco" ] ],

[ "Japan", 
[ ],
[ "Japan" ],
[ ] ],

[ "Netherlands", 
[ ],
[ ],
[ "Reinald Baart", "Jasper Cramwinckel", "Eric Minkes", "Erik Roijackers" ] ],

[ "Norway", 
[ ],
[ ],
[ "Øystein Skartsæterhagen" ] ],

[ "New Zealand", 
[ "Zealand" ],
[ "Auckland" ],
[ ] ],

[ "Portugal", 
[ ],
[ "Porto", ", PT" ],
[ "José João Morais", "Jose Morais" ] ],

[ "Russia", 
[ ],
[ ],
[ "Vladimir Gerdt", "Vladimir Kornyak" ] ],

[ "Spain", 
[ ],
[ ],
[ "Juan Ignacio García-García", "Benjamín Alarcón Heredia", "Carlos Jesús Moreno Ávila", "Ignacio Ojeda", "Alfredo Sánchez-R. Navarro" ] ],

[ "Sweden", 
[ ],
[ ],
[ "Klara Stokes" ] ],

[ "Turkey", 
[ ],
[ ],
[ "Nurullah Ankaralioglu", "Enver Onder Uslu" ] ],

[ "U.K.", 
[ "1LY", "2AZ", "9SX", "Kingdom", "Scotland", "SCOTLAND", "UK" ],
[ "Bangor", "Edinburgh", "London", "Open University", "Oxford", "Plymouth", "St Andrews" ],
[ "Björn Assmann", "Marco Costantini", "Andrés Herrera-Poyatos", "Anne Heyworth", "Adam James", "Kay Magaard", "Emma J. Moore", "Simon Nickerson", "Richard A. Parker", "Markus Pfeiffer", "Chris Wensley" ] ],

[ "Ukraine", 
[ ],
[ "Zaporozhye" ],
[ ] ],

[ "United Arab Emirates", 
[ ],
[ "Al Ain" ],
[ ] ],

[ "U.S.", 
[ "USA", "U.S", "U.S.A." ],
[ "Eugene", "Fort Collins, CO", "Seattle" ],
[ "Marcus Bishop", "Alexander Hulpke", "Chris O'Neill", "Marc Roeder", "Ákos Seress", "Alessio Sammartano", "Jhevon Smith", "Benjamin Steinberg", "Glen Whitney" ] ],

];

location := function(author)
    local address, loc, country;

    if author.LastName = "GAP Team" then
        return "";
    fi;
    
    if IsBound(author.PostalAddress) and Length(author.PostalAddress)>0 then
        address :=author.PostalAddress;
    elif IsBound(author.PostalAddres) and Length(author.PostalAddres)>0 then
        address :=author.PostalAddres;
    else
        address := fail;
    fi;

    if address <> fail then
        loc := SplitString( address, ",\n", " ");
        loc := loc[Length(loc)];
        country := First( maplocations, c -> Length(c)>0 and EndsWith(loc,c) );
        if country <> fail then
            return country;
        fi;
        country := First( pkgdata, c -> EndsWith(loc,c[1]) );
        if country <> fail then
            return country[1];
        fi;
        country := First( pkgdata, c -> ForAny(c[2], s -> EndsWith(loc,s) ) );
        if country <> fail then
            return country[1];
        fi;
    fi;    

    if IsBound(author.Place) then
        loc := author.Place;
        country := First( pkgdata, c -> EndsWith(loc,c[1]) );
        if country <> fail then
            return country[1];
        fi;
        country := First( pkgdata, c -> ForAny(c[2], s -> EndsWith(loc,s) ) );
        if country <> fail then
            return country[1];
        fi;
        country := First( pkgdata, c -> ForAny(c[3], s -> EndsWith(loc,s) ) );
        if country <> fail then
            return country[1];
        fi;
    fi;
    
    country := First( pkgdata, c -> ForAny(c[4], s -> s = Concatenation( author.FirstNames, " ", author.LastName) ) );
    if country <> fail then
        return country[1];
    fi;
    return fail;    
end;

PackagesByCountries:=function()

local gapRecord, countries, country, n, author, counts, c, pos;

gapRecord:=
rec(
  data := [ rec(
          autocolorscale := false,
          colorbar := rec(
              thickness := 10,
              title := "" ),
          colorscale := [ [ 0, "rgb(255,255,255)" ], 
                          [ 0.01, "rgb(245,195,157)" ], 
                          [ 0.2, "rgb(245,160,105)" ], 
                          [ 1, "rgb(178,10,28)" ] ],
          locationmode := "country names",
          locationssrc := "Dreamshot:9297:009d61",
          name := "B",
          showscale := true,
          type := "choropleth",
          zauto := false,
          zmin := 0,
          zsrc := "Dreamshot:9297:7e6159" ) ],
  frames := [ rec(
          layout := rec(
              autosize := false,
              font := rec(
                  size := 10 ),
              geo := rec(
                  center := rec(
                      lat := 76.15672511523269,
                      lon := -81.57473507220712 ),
                  projection := rec( type := "equirectangular" ) ),
              height := 300,
              hovermode := "closest",
              margin := rec(
                  b := 40,
                  l := 40,
                  r := 40,
                  t := 75 ),
title := "Locations of GAP package authors",
              titlefont := rec(
                  family := "Overpass",
                  size := 12 ),
              width := 400 ),
          name := "workspace-breakpoint-0" ) ],
  layout := rec(
      autosize := true,
      font := rec(
          family := "Overpass" ),
      geo := rec(
          center := rec(
              lat := 55.31688841607437,
              lon := -65.03023468634588 ),
          projection := rec( type := "equirectangular" ) ),
      height := 500,
      hovermode := "closest",
      title := "Locations of GAP package authors",
      titlefont := rec(
          family := "Overpass" ) ) );

countries:=[];;
for n in pkgnames do
    for author in GAPInfo.PackagesInfo.(n)[1].Persons do
        country := location(author);
        if country <> fail then
            Add(countries,country);
        else    
            Print("Warning: no country detected for ", author.FirstNames, " ", author.LastName, ", package ", n, "\n");
        fi;
    od;
od;

counts:=Collected(countries);

for c in counts do
    pos := Position(maplocations,c[1]);
    if pos <> fail then 
        values[pos]:=String(c[2]);
    fi;
od;  

gapRecord.data[1].locations := ShallowCopy(maplocations);;
gapRecord.data[1].z := ShallowCopy(values);;
gapRecord.data[1].zmax := Maximum(List(counts, c -> c[2]));;

Print("--------------------------------------------------------\n");
Print("Package activities by country\n");
Print("--------------------------------------------------------\n");
values := List(values,Int);
StableSortParallel(values,maplocations,function(v,w) return v > w; end);
for c in [1..Length(values)] do
    if values[c] = 0 then 
        break; 
    fi;
    Print(values[c], " : ", maplocations[c], "\n");
od;    
Print("--------------------------------------------------------\n");

if IsBound( gapRecord.layout ) then
    gapRecord.layout.height := 1000;;
else
    gapRecord.layout := rec( height := 1000 );;
fi;

return gapRecord;

end;