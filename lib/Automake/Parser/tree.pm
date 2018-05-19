#!/usr/bin/perl
package tree;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(input automakerule makerule stmts traverse printgraph);
# Grammar Rule : input => stmts
# Create a node having child as stmts.
sub input($)
{
	my ($val) = @_;
	my %node = (name => input, childs => [$val]);
	return \%node;
}
# Grammar Rule : stmt=> value '=' value
# Creates a node having a left hand side value in lhs variable and right hand side value in rhs variable.
sub automakerule($$$)
{
	my($lhs,$sym,$rhs) = @_;
	my %node = (name => stmt, lhs => $lhs, rhs =>$rhs,type => automake);
	return \%node;
}
# Grammar Rule : stmt=> value ':' value
# Creates a node having a left hand side value in lhs variable and right hand side value in rhs variable.
sub makerule($$$)
{
	my($lhs,$sym,$rhs)=@_;
	my %node = (name => stmt, lhs => $lhs, rhs => $rhs,type => make);
	return \%node;
}
# Grammar Rule : (1) stmts=> stmt '\n'
# Creates a node having a child as stmt
#				 (2) stmts=> stmts stmt '\n'
# Insert a node with stmt into the child array of stmts hash
sub stmts($$;$)
{
	my($val1,$val2,$val3)=@_;
	if($val3 == undef)
	{
		my %node = (name => stmts, childs => [$val1]);
		my %nodeval = (name => stmts, childs => [\%node]);
		return \%nodeval;
	}
	else
	{
		my %node = (name => stmts,childs => [$val2]);
		push @{$val1->{childs}}, \%node;
		return $val1;
	}
}
#printgraph(hash)
#prints the AST by traversing the tree starting at node pointed by hash.
sub printgraph($)
{
	my $FH;
	open($FH, '>', 'ast.gv') or die $!;
	print $FH "graph graphname {\n";
	my ($ref) = @_;
	print $FH "0 [label=\"Root\"];";
	traverse($ref, $FH, 0, 1);
	print $FH "}\n";
	close $FH;
}
#traverse(Hash, File Handle, Parent Id, Node Id)
#traverses the tree recursively. Prints the information about the current node to file. Call all its child with Parent Id equal to current Node Id and Node Id equal to (Parent Id*2+i) where i is the ith Child.
sub traverse($$$$)
{
	my ($ref,$FH,$parent,$id)=@_;
	my %node = %$ref;
	#print $level," ",$pos," ",$node{name}," ";
	print $FH "$parent--$id;\n";
	my $label = "";
	@keys = sort grep {!/^childs/} keys %node;
	foreach $key (@keys)
	{
		$label .= $key."=>";
		if(ref($node{$key}) eq 'ARRAY')
		{
			$label .= join(" ",@{$node{$key}})."\n";
		}
		else
		{
			$label .= $node{$key}." ";
		}
	}
	print $FH "$id [label=\"$label\"];";
	if( $node{childs} )
	{
		my $val1 = $node{childs};
		my $i = 1;
		foreach $child (@$val1)
		{
			trave rse($child,$FH,$id,2*$id+$i);
			$i++;
		}
	}
}