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

gapRecord.data[1].locations := maplocations;;
gapRecord.data[1].z := values;;
gapRecord.data[1].zmax := Maximum(List(counts, c -> c[2]));;

if IsBound( gapRecord.layout ) then
    gapRecord.layout.height := 1000;;
else
    gapRecord.layout := rec( height := 1000 );;
fi;

return gapRecord;

end;