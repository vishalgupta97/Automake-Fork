#!/usr/bin/perl
package tree;
use Exporter;
our @ISA=qw(Exporter);
our @EXPORT=qw(input automakerule makerule stmts traverse printgraph);
sub input($)
{
	my ($val)=@_;
	my %node=(name=>input,childs=>[$val]);
	return \%node;
}
sub automakerule($$$)
{
	my($lhs,$sym,$rhs)=@_;
	my %node=(name=>stmt,lhs=>$lhs,rhs=>$rhs,type=>automake);
	return \%node;
}
sub makerule($$$)
{
	my($lhs,$sym,$rhs)=@_;
	my %node=(name=>stmt,lhs=>$lhs,rhs=>$rhs,type=>make);
	return \%node;
}
sub stmts($$;$)
{
	my($val1,$val2,$val3)=@_;
	print @_;
	print "\n";
	if($val3==undef)
	{
		my %node=(name=>stmts,childs=>[$val1]);
		my %nodeval=(name=>stmts,childs=>[\%node]);
		return \%nodeval;
	}
	else
	{
		my %node=(name=>stmts,childs=>[$val2]);
		push @{$val1->{childs}},\%node;
		return $val1;
	}
}
sub printgraph($)
{
	my $FH;
	open($FH,'>','ast.gv') or die $!;
	print $FH "graph graphname {\n";
	my ($ref)=@_;
	print $FH "0 [label=\"Root\"];";
	traverse($ref,$FH,0,1);
	print $FH "}\n";
	close $FH;
}
sub traverse($$$$)
{
	my ($ref,$FH,$parent,$id)=@_;
	my %node=%$ref;
	#print $level," ",$pos," ",$node{name}," ";
	print $FH "$parent--$id;\n";
	my $label="";
	@keys=sort grep {!/^childs/} keys %node;
	print keys %node;
	foreach $key (@keys)
	{
		$label.=$key."=>";
		if(ref($node{$key}) eq 'ARRAY')
		{
			$label.=join(" ",@{$node{$key}})."\n";
		}
		else
		{
			$label.=$node{$key}." ";
		}
	}
	#my $label=$node{name}." ";
	#if($node{val})
	#{
	#	my @nodeval=@{$node{val}};
	#	$label=$label.join(" ",@nodeval)." ";
	#	print @nodeval;
	#}
	print $FH "$id [label=\"$label\"];";
	if($node{childs})
	{
		my $val1=$node{childs};
		my $i=1;
		foreach $child (@$val1)
		{
			traverse($child,$FH,$id,2*$id+$i);
			$i++;
		}
	}
}