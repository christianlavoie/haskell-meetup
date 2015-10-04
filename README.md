# The Haskell Meetup homepage.

Yes, it is written in Perl. One of the Haskell meetup organizers is weird.

## How to install

Make sure you have cpan minus and local::lib installed, on Ubuntu:

    apt-get install cpanminus liblocal-lib-perl

Then install mojolicious in some project directory:

    git checkout git@github.com:christianlavoie/haskell-meetup.git
    cd haskell-meetup
    cpanm -L ext Mojolicious::Lite

## TODO

1. validator.w3.org still complains about a few obsolete tags
1. Should probably remove the dependency on img.shields.io
1. The funky tags still sometimes overlap the avatar images at some specific sizes
1. Figure out why the tweets widget sometimes just doesn't load (so far, on Chris' Win7 desktop, Firefox 41.0.1 -- could be an HSTS issue)
