#!/usr/bin/perl
package lexer;
use Exporter;
our @ISA=qw(Exporter);
our @EXPORT=qw(lex);
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

#print("Enter an Expression\n");
#$_=<STDIN>;
#@tokens=lex($_);
#foreach $token (@tokens)
#{
#	print join(" ",@{$token}),"\n";
#}

