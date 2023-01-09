// Stencil Text
// By Curt McDowell <maker@fishlet.com> 2023-01-08
// Licensed under the Creative Commons - Attribution - ShareAlike.
// https://creativecommons.org/licenses/by-sa/4.0/
// Requires: fontmetrics library MIT (c) 2018 Alexander Pruss
//   (in the latter I added the function measureTextOffsets)
// Unfortunately the metrics are slightly off or entirely wrong for
//   some common accented latin characters including éèëêė so these
//   are worked around.

use <fontmetrics.scad>;

_holes_latin =
    "04689@#&AÁÀÃÄÂǍȦÅBẞDÐOÓÒÕÖÔǑȮØPQRaáàãäâǎȧbdeéèëêėgoóòõöôǒȯøpq";

_equiv_latin = [
    ["A", "ÁÀÃÄÂǍȦÅ"],
    ["B", "ẞ"],
    ["O", "ÓÒÕÖÔǑȮØ"],
    ["a", "áàãäâǎȧ"],
    ["e", "éèëêė"],
    ["o", "óòõöôǒȯø"]
];

_short = "abdegopq";

_join = function(array_str, i = 0)
    i == len(array_str) ? "" :
        str(array_str[i], _join(array_str, i + 1));
    
_map_ch = function(ch)
    let (trans = [
            for (equiv = _equiv_latin)
                if (len(search(ch, equiv[1])) > 0)
                    equiv[0]
         ])
        len(trans) > 0 ? trans[0] : ch;

_simplify = function(s)
    _join([for (i = [0 : len(s) - 1])
               _map_ch(s[i])]);

// Stencil text, spaced by actual character widths
module Stencil_Text(message, font, size, slit_width_pct=8) {
    holes_map =
        [for (ch = [0 : len(message) - 1])
         len(search(message[ch], _holes_latin)) > 0];

    offs = measureTextOffsets(text = str(_simplify(message), " "),
                              font = font,
                              size = size);

    offs_shifted = [for (i = [1 : len(offs) - 1]) offs[i]];

    // Divding widths by a little extra (0.1) compensate approximately
    // for char spacing.
    widths = offs_shifted - offs;
    centers = offs + widths / 2.1;
    slit_size = size * slit_width_pct / 100;
        
    for (i = [0 : len(message) - 1])
        difference() {
            ch = message[i];
            translate([offs[i], 0])
                text(ch,
                     font = font,
                     size = size,
                     halign = "left");
            if (ch != " " && holes_map[i]) {
                // Really too slow to make use of metrics for this
                // ascent = measureTextAscender(_map_ch(ch), size, font);
                // descent = measureTextDescender(_map_ch(ch), size, font);
                // echo(ch, ascent, descent);
                short = len(search(_map_ch(ch), _short)) > 0;
                slit_height = short ? size * 0.9 : size * 1.1;
                translate([centers[i] - slit_size / 2, -size * 0.1])
                    square([slit_size, slit_height]);
            }
        }
}

module _test_stencil() {
    Test_Font = "Liberation Sans:style=Bold";
    Test_Size = 20;
    Test_Text = _holes_latin;
    
    Stencil_Text(Test_Text, Test_Font, Test_Size);
}

_test_stencil();