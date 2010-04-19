Title: How Often do I Log In Daily?
Date: 2008-12-19
Icon: ../icon-64x64.png
Topics: security work


How often do I log in at work on a typical work day?

After few weeks where I felt I was having to type in passwords altogether too many times per day, I kept a list on a day last month. 

The list
========


1. Returning Windows from hibernation
1. Adobe updater forces a reboot
1. Customer's bug tracker*
1. Mozilla Firefox master password
1. Mozilla Thunderbird master password
1. The web app I am debugging
1. The web app I am debugging
1. The web app I am debugging
1. The web app I am debugging*
1. MySQL (development database)
1. MySQL (development database)
1. The web app I am debugging
1. The web app I am debugging
1. New database server
1. Root on new database server
1. MySQL (staging database)
1. Customer's bug tracker*
1. Rebooted windows
1. Mozilla Firefox master password
1. The web app I am debugging
1. Customer's bug tracker*
1. Customer's bug tracker*
1. The web app I am debugging
1. The web app I am debugging
1. The web app I am debugging
1. The web app I am debugging
1. New database server
1. Root on new database server
1. Mozilla Thunderbird master password

> *= web browser remembered my password for me 

Most annoying
=============

The most egregious item in the list is the customer’s bug database, which for reasons that elude me logs me out and forces me to log back in every twenty minutes or so. For some reason it takes a significant fraction of a minute to log back in again, and when it does it goes back to the list of bugs, not the page I was on when I was logged out. Worse, it is set up to flush the cached page, which means what I had entered in to the form is lost.   The working process goes like this:

1. Log in to bug database. Wait for list of bugs to appear (it seems to take forever).
2. Click on the Priority heading and wait for it to sort by priority,
2. Click on the Priority heading and wait for it to sort by priority *descending*,
1. Click on highest priority bug and wait for it to appear.
1. Write down the bug number in my scratchpad.
1. Investigate bug and fix it.
1. Check in fix
1. Enter message in to the form on the bug report and click Submit,
1. Bug database has logged me out so it shows me the login page.
1. Log in to bug database. Wait for list of bugs to appear (it seems to take forever).
1. Enter the bug number in to the form to retrieve the bug report.
1. Enter the text again and click Submit.

Generally I remember to copy and paste the message somewhere else just in case it gets junked, but when I forget it is incredibly annoying.

Second most annoying
====================

Had to reboot Windows twice.

Inevitable but still annoying
=============================

Naturally it is hard to work on a web application without having to of
in as different users from time to time. I try to mitigate this by
having different web browsers open so I am (for example) logged in as a
normal user on Mozilla Firefox and as the administrator on Google Chrome
so I can make changes and see their effect without logging out and in
twice. The problem is that as well as my development system there is
also the staging site and the live site to consider, and I also have to check bugs on a copy of IE 6 that runs on a virtual machine somewhere.

Alternatives?
=============

OpenID might be useful for reducing the number of times I need to enter a username and password—there has also been some talk of building OpenID in to web browsers to further streamline the process.  If the damned bug-list could delegate authentication to some more-sensible  site it would greatly reduce the irritation using it causes me during the work day.

Alas! this probably would not suffice for the web application I am debugging, given that the client would object that I need to be using the same authentication mechanisms as the end-users, and end-users cannot be expected to understand OpenID.


