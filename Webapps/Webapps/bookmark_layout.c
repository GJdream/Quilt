//
//  bookmark_layout.c
//  Quilt
//
//  Created by Richard Jones on 15/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#include <stdlib.h>
#include "bookmark_layout.h"

struct quilt_tree *new_quilt_tree(void)
{
    struct quilt_tree *retTree = (struct quilt_tree*)malloc(sizeof(struct quilt_tree));
    return retTree;
}

void quilt_tree_add(struct quilt_tree *t, void *bookmark, uint8_t bookmark_width, uint8_t bookmark_height)
{
    /*struct quilt_tree_node *n = t->rootlist->start;
    uint8_t min_patch_size = bookmark_height > bookmark_width ? bookmark_height : bookmark_width;
    uint8_t found_space = 0;
    
    while(n)
    {
        if(n->patch_size < min_patch_size)
            ; //Break?

        
    }
    
    if(!found_space)
        ;// Create a new root node and insert there.*/
}

void quilt_tree_remove(struct quilt_tree *, void *bookmark, uint8_t bookmark_width, uint8_t bookmark_height);