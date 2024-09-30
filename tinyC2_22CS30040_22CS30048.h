#ifndef DRAFT1_H
#define DRAFT1_H


struct node* create_leaf( char *value);
struct node* create_root(struct node* child,char *id);
void addchild(struct node* parent, struct node* child);
void print_tree(struct node *root,int depth);
void yyerror(const char *s);



#endif // DRAFT1_H