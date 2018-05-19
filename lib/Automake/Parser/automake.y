%token value
%%

input : stmts ;
stmts : stmt '\n'
		| stmts stmt '\n'
stmt  : value '=' value  
		| value ':' value 

%%