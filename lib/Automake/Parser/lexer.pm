#!/usr/bin/perl
package lexer;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(lex);
# lex(string)
# Takes as input a string of line. Divides it into tokens as specified by Regex and outputs an array of Tokens. Every Token is an array having two values: token name and its value. If its an operator, it has only one value.
sub lex($)
{
	@tokens;
	while($_)
	{
		if(s/^([\w_]+)//o)
		{
			push @tokens,["value",$1];
		}
		elsif(s/^(:|=|\n)//o)
		{
			push @tokens,[$1];
		}
		elsif(s/^\r//o)
		{
		}
		else
		{
			die "Incorrect input $_";
		}
	}
	return @tokens;
}

