Title: Invitations and invite codes
Topics: ux
Date: 2017-11-26

Twice now I have designed an invite-code system for a new web site and twice
it has not gone in to production. So I’m going to put up my thoughts here so
that some future civilization can read them and realize I was right all along.


# What invite codes are (for)

An invite code is an additional field added to the sign-up form for a web site.
The code itself is some difficult-to-guess gibberish code that you got emailed
by a chum already on the site, and without one you cannot join up. To
facilitate things there may be an registration URL that incorporates the code
so it need not be entered by hand.

Requiring invite codes serves two main purposes:

* Allowing gradual scaling of a new web site, by limiting the rate at which
new people flood on to the system; and

* Influencing the amount of homogeneity in the social group using the site.

The second point comes from the fact that invite codes are distributed by the
existing users, who will tend to hand them out to the sort of people they
would like to have on the site. Or put another way, it reduces the ability of
internet trolls to join up a new site _en masse_ and flood it with garbage.


# Invite codes are like coins

An invitation is an entity in the system (that is, it is a thing in the
database alongside users, groups, channels, or what-have-you). It is
associated with _two_ users, called _inviter_ and _invited_, and has a unique
_code_  and possibly expiration dates and other data. The code something like
a 64-bit random number, represented as a base64 string.

As an example, suppose Ayo has an account on the St Ouses Cat Chat Club site.
As a result of some admin action (to be discussed later), an invitation has
been minted for Ayo. In the database this has Ayo as inviter and the invited
field is null. She can list her invitations on a page in her profile. These
appear as a list with columns for code, sample link, etc., and the invited
user (currently blank).

The next stage in the life cycle is that Ayo mails a link to her chum Omid,
who uses the code to register. The invitation has now been _spent_: it has
both inviter and invited slots filled. On Ayo’s invitations page she sees a
link to Omid’s account from the list of invitations. Ayo’s public profile will
have a invited list alongside her followers and following lists. Omid
similarly has a link to Ayo as his inviter on his profile somewhere. (Also
when Omid registers he is automatically set to be following Ayo and _vice
versa_).

Having invitations become a record of the relationship between users is
potentially useful from the point of view of reputation management. It makes
invitations inherently single-use, which simplifies things by avoiding any
need to keep track of how often one is used or building a user interface for
configuring it.


# Minting new invitations

Questions of how often users can invite new users, how many invitations happen
are all controlled by how often they are minted, and this will be a
suitably privileged user (site admin or other officer of the club).

They will have a tool (command-line script or part of the site’s admin
interface) for minting _N_ invitations and assigning them randomly amongst a
defined subset of users. The subset might be specified by  criteria like the
following:

* users who don’t have an unspent invitation right now;
* users who have never had an invitation issued for them
  (and have been on the site for X days);
* users who have had an invitation that has subsequently been spent
  (at least X days ago).

The recipients get a notification prompting them to invite a friend with their
exciting new invite code.

By limiting _N_ you can control how fast the user-base scales up as you gain
confidence in your ability to scale the server. By choosing particular subsets
you can enact a variety of policies on who gets to invite people. By
scheduling issuance of invitations in waves you can stoke up a little
excitement about the site as people start asking around for chums with
invitations to give on them.

If your sever admin has a command-line tool for issuing invitations and ways
to to statistical analyses of the user-base then they can get creative with
scripts that automatically adjust the rate of issuance of invitations to grow
the server at a set rate, taking in to account the fraction of invitations
that on average don’t end up being spent, and rewarding users for particular
patterns of behaviour. The main thing is that these fancy algorithms don’t
have to be part of the main code-base since they are run outside of the server.


# Summary

Invitation codes are best modelled as entities in their own right, linking the
inviter and invited person. This simplifies working out who can invite
someone, and how many invitations can be expected to be issued.
