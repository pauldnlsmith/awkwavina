# SPDX-License-Identifier: 0BSD
#
# Copyright (c) 2020-2025 Daniel Smith
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#
###############################################################################
#
#   PURPOSE: Sanitize and validate vehicle identification numbers (VINs) based
#            on length and check digit.
#
#     INPUT: A list of VINs or tabular data containing VINs.
#
#    OUTPUT: Complete input with each record prepended by 'OK' (for valid VINs)
#            or '--' (for invalid VINs). Valid VINs are sanitized to remove
#            illegal characters and convert to uppercase. Invalid VINs are left
#            as in input.
#
#     USAGE: $ awk -f awkwavina.awk [-v f=<int>]
#
# VARIABLES: f -- input field containing VIN (optional; default: complete line).
#
###############################################################################

BEGIN {
	# Assigned numeric value of each character.
	CHVAL["0"] = 0; CHVAL["1"] = 1; CHVAL["2"] = 2;
	CHVAL["3"] = 3; CHVAL["4"] = 4; CHVAL["5"] = 5;
	CHVAL["6"] = 6; CHVAL["7"] = 7; CHVAL["8"] = 8;
	CHVAL["9"] = 9; CHVAL["A"] = 1; CHVAL["B"] = 2;
	CHVAL["C"] = 3; CHVAL["D"] = 4; CHVAL["E"] = 5;
	CHVAL["F"] = 6; CHVAL["G"] = 7; CHVAL["H"] = 8;
	CHVAL["J"] = 1; CHVAL["K"] = 2; CHVAL["L"] = 3;
	CHVAL["M"] = 4; CHVAL["N"] = 5; CHVAL["P"] = 7;
	CHVAL["R"] = 9; CHVAL["S"] = 2; CHVAL["T"] = 3;
	CHVAL["U"] = 4; CHVAL["V"] = 5; CHVAL["W"] = 6;
	CHVAL["X"] = 7; CHVAL["Y"] = 8; CHVAL["Z"] = 9;

	# Weighting of each digit in the VIN.
	WT[1] = 8;  WT[2] = 7;  WT[3] = 6;
	WT[4] = 5;  WT[5] = 4;  WT[6] = 3;
	WT[7] = 2;  WT[8] = 10; WT[9] = 0;
	WT[10] = 9; WT[11] = 8; WT[12] = 7;
	WT[13] = 6; WT[14] = 5; WT[15] = 4;
	WT[16] = 3; WT[17] = 2;
}

{
	# Sanitizing input.
	vin = toupper($f)
	gsub(/[^A-Z0-9]+/, "", vin)

	# Validating VIN.
	if (!match(vin, ".*[IOQ].*") && split(vin, d, "") == 17) {
		sum = 0
		for (i = 1; i <= 17; i++)
			sum += (CHVAL[d[i]] * WT[i])

		if ((sum %= 11) == (chckd = d[9]) ||
		    (sum == 10 && chckd == "X")) {
			# VIN is valid.
			$f = vin
			print "OK", $0
			next
		}
	}

	# VIN is invalid.
	$f = $f
	print "--", $0
}
