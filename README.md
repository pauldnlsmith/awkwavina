# awkwavina

*awkwavina* is a utility for sanitizing and validating vehicle identification
numbers (VINs) in bulk. Written in portable AWK, it's simple, lightweight and
reasonably quick.

## Usage

```
$ awk -f awkwavina.awk [-v f=<int>] [FILE..]
```

## About

All vehicles currently sold in the US and Canada must have VINs that match a
standardized format:

* 17 alphanumeric characters (excluding i/I, o/O and q/Q)  
* A valid check digit (9th character)

*awkwavina* reads in a list of VINs (or tabular data containing VINs) from one
or more files or standard input, removes illegal characters and verifies the
length and check digit.

Records are printed to standard out prepended with 'OK' (for valid VINs) or
'--' (for invalid VINs). Valid VINs are printed sanitized (uppercase, without
illegal characters). Invalid VINs are printed without sanitization.

## Configuration

For simplicity, *awkwavina* includes only basic customization. Besides standard
AWK variables (FS/OFS, RS/ORS etc.), *awkwavina* adds an 'f' variable. This is
used to select which field of the input contains the VIN. If 'f' is not set,
the complete line will be read and validated.

## License

Made freely available under a Zero-Clause BSD license.
