//
//  bookmark_layout.h
//  Quilt
//
//  Created by Richard Jones on 15/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#ifndef Quilt_bookmark_layout_h
#define Quilt_bookmark_layout_h

#include <stdint.h>

struct quilt_tree_node;

struct quilt_tree_node
{
    struct quilt_tree_node *children[4];
    /*
     ---------
     | 0 | 1 |
     ---------
     | 2 | 3 |
     ---------
     */
    uint8_t patch_size;
    void *bookmark;
    uint8_t bookmark_width;
    uint8_t bookmark_height;
};

struct quilt_tree
{
    struct quilt_tree_node_list *rootlist;
    
};

struct quilt_tree *new_quilt_tree(void);
void quilt_tree_add(struct quilt_tree *, void *bookmark, uint8_t bookmark_width, uint8_t bookmark_height);
void quilt_tree_remove(struct quilt_tree *, void *bookmark, uint8_t bookmark_width, uint8_t bookmark_height);
// Swapping?

#endif