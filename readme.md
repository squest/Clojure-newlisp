## Clojure-lsp

A set of macros and functions to make the scripting experience using newlisp feels a bit clojurish

#### Background 

If you're a Clojurian like myself and looking for a lisp that can start quickly, have small memory footprint, 
run on multiple platforms, have a rich enough features to get the jobs done quickly, and did I mention start quickly(?)
then I recommend you to use newLisp.

It's only 300K and the resulting executables range from 300-500K. It's fast enough.
And for me, it's important that it includes its runtime in the executables which make it possible 
for me to have full access to the language from the executables (so I can do evals to the dynamically loaded files, 
or make the exe watching a folder to be run using a scheduler, and you can still changing those extra files, etc). 
In short, it's a lisp, it's fast enough, it does my dirty cores, and its fun (rather ugly and inconsistent though).

Now to make the newlisping experience more clojurish, here's some Clojure's macros and functions I can't 
live without (I bet you can't live without ->> and ->, and probably think why wouldn't other lisps 
had this feature 20-30 years ago, it's soo obvious that all lispers need this right?!).

Obviously there are some adjustment in the behaviour of the macros/functions, but in general, it has the same spirit :)

#### Roadmap

- Macros : ->>, ->, if-let, when-let, f# (as an alias for anonymous function, so you can still use %, %2, etc).
- Functions : keep, map-indexed (I renamed it to mapi and keepi), and many others.

#### Need help!!

It's awesome if someone can write edn-reader/writer though, I'm sure we will use it a lot.




