use strict;
use warnings;

use Test::More 'no_plan';

use Data::Dumper;
$Data::Dumper::Terse=1;
$Data::Dumper::Indent=0;

BEGIN { use_ok('Data::Pairs') };

my( $pairs, @values, @keys, @array, $aref, @pos );

$pairs = Data::Pairs->new( [ {c=>3}, {a=>1}, {b=>2}, ] );

@values = $pairs->get_values();
is( "@values", "3 1 2",
    "get_values(), all values, like 'values %hash'" );

@values = $pairs->get_values( qw( a b c ) );
is( "@values", "3 1 2",
    "get_values(), selected values, like '\@hash{'c','a','b'}', i.e., data-ordered" );

@keys = $pairs->get_keys();
is( "@keys", "c a b",
    "get_keys(), like 'keys %hash'" );

@keys = $pairs->get_keys( qw( a b c ) );
is( "@keys", "c a b",
    "get_keys() for selected keys, data-ordered" );

@pos = $pairs->get_pos( qw( a b c ) );
is( Dumper(\@pos), "[{'a' => 1},{'b' => 2},{'c' => 0}]",
    "get_pos() for selected keys, parameter-ordered" );

@array = $pairs->get_array();
is( Dumper(\@array), "[{'c' => 3},{'a' => 1},{'b' => 2}]",
    "get_array(), list context" );

$aref = $pairs->get_array();
is( Dumper($aref), "[{'c' => 3},{'a' => 1},{'b' => 2}]",
    "get_array(), scalar context" );

@array = $pairs->get_array( qw( b c ) );
is( Dumper(\@array), "[{'c' => 3},{'b' => 2}]",
    "get_array() for selected keys, data-ordered" );

$pairs->set( a=>0 ); @values = $pairs->get_values( qw( a b c ) );
is( "@values", "3 0 2",
    "set() a value" );

# at pos 1, overwrite 'a'
$pairs->set( A=>1,1 ); @values = $pairs->get_values( qw( A b c ) );
is( "@values", "3 1 2",
    "set() a value at a position" );

$pairs->add( d=>4 ); @values = $pairs->get_values( qw( A b c d ) );
is( "@values", "3 1 2 4",
    "add() a value" );

# add at pos 2, between 'A' and 'b'
$pairs->add( a=>0,2 ); @values = $pairs->get_values( qw( A a b c d ) );
is( "@values", "3 1 0 2 4",
    "add() a value at a position" );

is( $pairs->exists('a'), 1,
    "exists() true" );
is( $pairs->exists('B'), '',
    "exists() false" );

$pairs->delete('A');
is( Dumper($pairs), "bless( [{'c' => 3},{'a' => 0},{'b' => 2},{'d' => 4}], 'Data::Pairs' )",
    "delete()" );

$pairs->clear();
is( Dumper($pairs), "bless( [], 'Data::Pairs' )",
    "clear()" );
