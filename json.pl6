use v6;

my $example_object = q:to/END/;
{
    "Image": {
        "Width": 800,
        "Height": 600,
        "Title": "View from 15th Floor",
        "Thumbnail": {
            "Url": "http://www.example.com/image/481989943",
            "Height": 125,
            "Width": 100
        },
        "Animated" : false,
        "IDs": [116, 943, 234, 38793]
    }
}
END

my $example_array = q:to/END/;
[
    {
        "precision": "zip",
        "Latitude": 37.7668,
        "Longitude": -122.3959,
        "Address": "",
        "City": "SAN FRANCISCO",
        "State": "CA",
        "Zip": "94107",
        "Country": "US"
    },
    {
        "precision": "zip",
        "Latitude": 37.371991,
        "Longitude": -122.026020,
        "Address": "",
        "City": "SUNNYVALE",
        "State": "CA",
        "Zip": "94085",
        "Country": "US"
    }
]
END

my $example_string = q:to/END/;
"Hello world"
END

my $example_int = q:to/END/;
42
END

my $example_literal = q:to/END/;
true
END

# https://www.rfc-editor.org/rfc/pdfrfc/rfc8259.txt.pdf
grammar Grammar {
    # Rules
    rule TOP {
        <value>*
    }

    rule object {
        <begin-object> (<member> (<value-separator> <member>)*)? <end-object>
    }

    rule array {
        <begin-array> (<value> (<value-separator> <value>)*)? <end-array>
    }

    rule number {
        <minus>? <int>+ <frac>? <exp>?
    }

    rule string {
        <quotation-mark> <char>* <quotation-mark>
    }

    rule literal {
        "true" | "false" | "null"
    }

    rule value {
        <literal> | <object> | <array> | <number> | <string>
    }

    rule member {
        <string> <name-separator> <value>
    }

    # Tokens
    token begin-object {
        '{'
    }

    token end-object {
        '}'
    }

    token begin-array {
        '['
    }

    token end-array {
        ']'
    }

    token name-separator {
        ':'
    }

    token value-separator {
        ','
    }

    # Numeric Tokens
    token decimal-point {
        '.'
    }

    token digit {
        <[1..9]>
    }

    token e {
        'e' | 'E'
    }

    token exp {
        <e> (<minus> | <plus>)? <int>
    }

    token frac {
        <decimal-point> <int>+
    }

    token int {
        <zero> | <digit>
    }

    token minus {
        '-'
    }

    token plus {
        '+'
    }

    token zero {
        '0'
    }

    # String Tokens
    token char {
        <unescaped> | <escaped>
    }

    token escape {
        '\\'
    }

    token quotation-mark {
        '"'
    }

    token unescaped {
        <[\x[20]..\x[21]]> | <[\x[23]..\x[5B]]> | <[\x[5D]..\x[10FFFF]]>
    }

    token escaped {
        '\\' ('"' | '\\' | '/' | 'b' | 'f' | 'n' | 'r' | 't')
    }
}

class Actions {
}

say Grammar.parse($example_object, actions => Actions.new);
