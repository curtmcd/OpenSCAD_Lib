// Radial Text
// By Curt McDowell <maker@fishlet.com> 2021-10-27
// Licensed under the Creative Commons - Attribution - ShareAlike.
// https://creativecommons.org/licenses/by-sa/4.0/
// Requires: fontmetrics library MIT (c) 2018 Alexander Pruss
//   (in the latter I added the function measureTextOffsets)

use <fontmetrics.scad>;

// Radial text, spaced by actual character widths
module Radial_Text(r, angle, message, font, size,
                   letter_hole_support = false) {
    centers = function(offsets, i = 0)
        i >= len(offsets) - 1 ? [] :
            concat([(offsets[i] + offsets[i + 1]) / 2],
                   centers(offsets, i + 1));

    last_ch = len(message) - 1;

    total_width = measureText(text = message,
                              font = font,
                              size = size);

    char_offsets = measureTextOffsets(text = str(message, " "),
                                      font = font,
                                      size = size);
    char_centers = centers(char_offsets);
    char_angles = [for (offset = char_centers) angle * offset / total_width];
    char_holes_latin_ext =
        "04689@#&AÁÀÃÄÂǍȦÅBẞDÐOÓÒÕÖÔǑȮØPÞQRaáàãäâǎȧªbdðeéèëêėgoóòõöôǒȯøºpþq°";
    char_has_holes = [for (ch = [0 : last_ch])
                      len(search(message[ch], char_holes_latin_ext)) > 0];

    for (ch = [0 : last_ch])
        rotate(char_angles[ch])
            translate([r, 0])
                rotate(-90)
                    mirror([1, 0])
                        difference() {
                            text(message[ch],
                                 font = font,
                                 size = size,
                                 halign = "center");
                            if (letter_hole_support && char_has_holes[ch]) {
                                translate([0, size * 0.45])
                                    square([size * 0.1, size * 1.25],
                                            center = true);
                            }
                        }

}
