Mnesia Table Fragmentation
==========================

How to start
------------

Launch erl shell with mnesia:

    erl -mnesia

Compile:

    c(frags).

Create the tables and schema:

    frags:create().

Start the observer, and inspect the "Table Viewer -> View/Mnesia Tables" menu:

    observer:start().

You should see two frags. Try adding some sample data:

    frags:populate(100).    

Now those tables shold have more data. Now add and remove
some frags and observer the tables:

    frags:add_frag().
    frags:add_frag().
    frags:del_frag().

Now delete all the frags by repeated issuing `del_frag`:

    frags:del_frag().
    ...

Make sure only one table remains. Then disable
the fragmentation for this table:

    frags:deactivate().


At this point it becomes a regular table. We are no longer
able to add fragments. Try this (what happends?):

    frags:add_frag().

Take NOTE that adding data with `populate` will not always work now.
This is because it still hashes (to frags) that don't exist.
Use `populate_no_frag` to add data (which uses just vanilla
transactions):

    frags:populate_no_frag(100).

Now reactivate the fragmentation:

    frags:activate().

And we can add frags again:

    frags:add_frag().



References
----------
Following these two resources:

- https://erlangcentral.org/wiki/index.php/Mnesia_Table_Fragmentation
- http://erlang.org/doc/apps/mnesia/Mnesia_chap5.html#id79999