# Copyright overlap diagnostic: en_attempt_1.json

Method: 3-word shingles of the draft text (lowercased, tokens = letters/digits/Devanagari), each hashed (sha256, first 16 hex) and looked up in the NCERT fingerprint set. Score = matched shingles / all shingles (duplicates counted).
Reference files: 

- Tokens: 1035
- Shingles (denominator): 1033
- Matched shingles (numerator): 240
- Score: 23.23% (gate threshold 20%; threshold unchanged)
- Longest matching passage: 10 tokens

This is a text-similarity measurement against hashed reference text. It is not legal clearance and not a verdict of infringement. The reference holds hashes only, so the matching NCERT sentences themselves cannot be shown; the passages below are the draft's own words that matched.

## standard_terminology: 31 passages, 81 shingles, 34% of the matched total
- "electric current is"
- "rate of flow of electric charges"
- "across any cross section of a conductor"
- "electric potential difference between two points is"
- "the potential difference across its ends"
- "in a series combination"
- "total circuit resistance"
- "resistance in a parallel combination"
- "the equivalent resistance of a"
- "heating effect of electric current and"
- "electric power when"
- "resistance and resistivity"

## other_short_phrase: 42 passages, 75 shingles, 31% of the matched total
- "is defined as the net"
- "charge from one point to"
- "law states that"
- "at a constant"
- "is directly proportional to the"
- "it passes through"
- "in a series circuit"
- "electric charge is"
- "combination of resistors"
- "the flow of electric charges"
- "inversely on its area of cross section"
- "on the nature of the material"

## long_passage: 7 passages, 47 shingles, 20% of the matched total
- "is the work done to move a unit"
- "the current flowing through a metallic wire is"
- "resistance r is the property of a conductor to"
- "depends directly on the length of the conductor"
- "is directly proportional to the square of current"
- "the commercial unit of electrical energy is kilowatt hour kwh"
- "and does not depend on the current flowing through it"

## repeated_boilerplate: 19 passages, 25 shingles, 10% of the matched total
- "ohm s law  (x3)"
- "is the sum of  (x2)"
- "joule s law of heating  (x2)"
- "p v i  (x2)"
- "in volts v  (x2)"
- "electric current in  (x2)"
- "total resistance r  (x2)"
- "energy consumed in  (x2)"
- "a metallic wire  (x2)"

## formula_notation: 8 passages, 10 shingles, 4% of the matched total
- "v w q"
- "v i r a"
- "v i r"
- "i current in"
- "current i s"
- "v r s"
- "current i p v"
- "v r p"

## function_words_only: 2 passages, 2 shingles, 1% of the matched total
- "it is an"
- "what is the"
