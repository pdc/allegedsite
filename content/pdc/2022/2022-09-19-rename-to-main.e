Title: Changing the default branch from master to main in Git
Date: 2022-09-19
Topics: git gilab github

There are various reasons why one might want to rename the default branch of a Git repo from _master_ to _main_. Here’s a quick reminder to myself of how.

On GitHub
=========

This is easy. From the main page for your project, click on the _2 branches_ link above the file list, and then click the pencil icon next to the branch in question.

As well as renaming the branch it will change existing pull requests to target the new name.

On GitLab
=========

There is no automated mechanism (as of 2022-09): the [suggested approach][1] is to rename it locally and push the new branch:

    git checkout master
    git branch -m master main
    git push -u origin main

You can then set it as the default branch, and protect it, via the GitLab UI.
You also need to instruct merge request owners to retarget any extant merge requests.

[1]: https://docs.gitlab.com/ee/user/project/repository/branches/default.html#update-the-default-branch-name-in-your-repository


On local checkouts
==================

GitHub makes this easy by telling you the incantation, which I will here repeat:

    git branch -m master main
    git fetch origin
    git branch -u origin/main main
    git remote set-head origin -a

If, like me, you have a second checkout on your web server, then you need to run the incantation there as well. 

The GitLab recipe substitutes the following for the fourth line above:

    git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main

I think this has the same effect (but avoids a needless network transaction).


