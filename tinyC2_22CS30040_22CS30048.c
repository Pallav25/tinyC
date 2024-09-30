#include "tinyC2_22CS30040_22CS30048.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tinyC2_22CS30040_22CS30048.h"
struct node* create_leaf( char *value) {
    struct node *m = (struct node *)malloc(sizeof(struct node));
    m->id = strdup(value);
    m->firstchild = NULL;
    m->nextsibling = NULL;
    return m;
}

struct node* create_root(struct node* child,char *id) {
    struct node *m = (struct node *)malloc(sizeof(struct node));
    m->firstchild = child;
    m->nextsibling = NULL;
    m->id = strdup(id);
    return m;
}

void addchild(struct node* parent, struct node* child) {
    struct node *m = parent->firstchild;
    if (m == NULL) {
        parent->firstchild = child;
    } else {
        while (m->nextsibling != NULL) {
            m = m->nextsibling;
        }
        m->nextsibling = child;
    }
}

void print_tree(struct node *root,int depth) {
    if (!root) return;
    if(strcmp(root->id,"NULL")==0) return;
    for(int i = 0; i <depth; i++) {
        printf("  ");
    }
    printf("--->");
    printf("%s\n", root->id);
    struct node *m = root->firstchild;
    while (m != NULL) {
        print_tree(m,depth+1);
        m = m->nextsibling;
    }
}


int main() {
    
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
