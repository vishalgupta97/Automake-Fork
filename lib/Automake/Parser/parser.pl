#!/usr/bin/perl
use lexer;
use tree;
@arr=({value=>1,input=>2,stmts=>3,stmt=>4},
	{'='=>5,':'=>6},
	{end=>7},
	{value=>1,stmt=>8,reduce=>[1,\&input]},# input=> stmts
	{"\n"=>9},
	{value=>10},
	{value=>11},
	{},
	{"\n"=>12},
	{reduce=>[2,\&stmts]}, # stmts=> stmt '\n'
	{reduce=>[3,\&automakerule]}, # stmt=> value '=' value
	{reduce=>[3,\&makerule]}, # stmt=> value ':' value
	{reduce=>[3,\&stmts]}); # stmts=> stmts stmt '\n' 

open(data,"<input.txt");
my @tokens;
while(<data>)
{
	push @tokens,lex($_);
}
print "Lexer Output\n";
foreach $token (@tokens)
{
	print join(" ",@{$token}),"\n";
}
push @tokens,["end"];
@stack=(0);
print "Parser Output\n";
while(@stack)
{
	if($stack[-1]==7)
	{
		print "Complete\nTree Traversal\n";
		printgraph($stack[-4]);
		#traverse($stack[-4],0,0);
		last;
	}
	my @curr_token=@{$tokens[0]};	
	if($val=$arr[$stack[-1]]{$curr_token[0]})
	{
		push @stack,\@curr_token,$val;
		shift @tokens;
	}
	elsif($val=$arr[$stack[-1]]{reduce})
	{
		my @val1=@$val;
		my @param;
		for($i=1;$i<=2*$val1[0];$i++)
		{
			if($i%2==0)
			{
				$val=pop @stack;
				push @param,$val;
			}
			else
			{
				pop @stack;
			}
		}
		#print @param,"12\n";
		@param=reverse @param;
		push @stack,$val1[1]->(@param);
		push @stack,$arr[$stack[-2]]{$stack[-1]->{name}};
	}
	else
	{
		die "Unexpected Token ". $curr_token."\n";
	}
	# foreach $ele (@stack)
	# {
		# if(ref($ele) eq 'ARRAY')
		# {
			# print @$ele," ";
		# }
		# elsif(ref($ele) eq 'HASH')
		# {
			# print %$ele," ";
		# }
		# else
		# {
			# print $ele," ";
		# }
	# }
	# print "\n";
	print @stack,"\n";
}