$if(has-tables)$
.\"t
$endif$
$if(adjusting)$
.ad $adjusting$
$endif$
.TH "$man_title$" "$man_section$" "$revision_date$" "$man_footer$" "$man_header$"
$if(hyphenate)$
.hy
$else$
.nh \" Turn off hyphenation by default.
$endif$
$for(header-includes)$
$header-includes$
$endfor$
$for(include-before)$
$include-before$
$endfor$
$body$
$for(include-after)$
$include-after$
$endfor$
$if(authors)$
.SH AUTHORS
$for(authors)$$authors$$sep$; $endfor$
$endif$
