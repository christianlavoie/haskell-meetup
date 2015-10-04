use strict;
use warnings;

use local::lib 'ext';

use Mojolicious::Lite;
use Mojo::Log;

# Log to STDERR
my $log = Mojo::Log->new(level => 'info');

# Set a secret based on code MD5
my $md5sum = `md5sum ./main.pl`;
$md5sum =~ s/ .*//g;
$log->info("md5sum: $md5sum");
app->secrets([$md5sum]);

# Author helpers
helper badge_link_author_github => sub {
    my ($c, $username) = @_;
    return "<a href=\"https://github.com/$username\"><img alt=\"$username github profile\" src=\"https://img.shields.io/badge/github-$username-76387D.svg\"></a><br>";
};

helper badge_link_author_linkedin => sub {
    my ($c, $username) = @_;
    return "<a href=\"https://ca.linkedin.com/in/$username\"><img alt=\"$username linkedin profile\" src=\"https://img.shields.io/badge/linkedin-$username-76387D.svg\"></a><br>";
};

helper badge_link_author_reddit => sub {
    my ($c, $username) = @_;
    return "<a href=\"https://reddit.com/user/$username\"><img alt=\"$username reddit profile\" src=\"https://img.shields.io/badge/reddit-/u/$username-76387D.svg\"></a><br>";
};

helper badge_link_author_twitter => sub {
    my ($c, $username) = @_;
    return "<a href=\"https://twitter.com/$username\"><img alt=\"$username twitter profile\" src=\"https://img.shields.io/badge/twitter-\@$username-76387D.svg\"></a><br>";
};

helper badge_link_author_website => sub {
    my ($c, $url) = @_;
    return "<a href=\"http://$url\"><img alt=\"website\" src=\"https://img.shields.io/badge/website-$url-76387D.svg\"></a><br>";
};

# Talk helpers
helper badge_link_talk_code => sub {
    my ($c, $url) = @_;
    my $escaped = $url;
    $escaped =~ s/-/--/g;
    return "<a href=\"https://$url\"><img alt=\"talk code\" src=\"https://img.shields.io/badge/code-$escaped-76387D.svg\"></a><br>";
};

helper badge_link_talk_slides => sub {
    my ($c, $url) = @_;
    my $escaped = $url;
    $escaped =~ s/-/--/g;
    return "<a href=\"https://$url\"><img alt=\"talk slides\" src=\"https://img.shields.io/badge/slides-$escaped-76387D.svg\"></a><br>";
};

get '/' => sub {
    my $c = shift;

    my $next_meetup = $c->render_to_string(
        template => 'talk',

        author_name => 'Samuel Gélineau',
        author_avatar => 'https://avatars0.githubusercontent.com/u/49000',

        author_github => 'gelisam',
        author_reddit => 'gelisam',

        talk_level => 'expert',
        talk_title => 'The search for free categories: A higher-kinded quest.');

    my $previous_meetups = '';

    $previous_meetups .= $c->render_to_string(
        template => 'meetup',

        url => 'http://www.meetup.com/Haskellers-Montreal-Meetup/events/223004218/',
        date => 'Wednesday, July 29th @ 18:30',
        addr => 'RPM, 420 rue Guy, Montréal, QC');

    $previous_meetups .= $c->render_to_string(
        template => 'talk',

        author_name => 'Christian Lavoie',
        author_avatar => 'https://avatars3.githubusercontent.com/u/103466?',

        author_github => 'christianlavoie',
        author_linkedin => 'christianlavoie',
        author_reddit => 'moosefish',
        author_twitter => 'christianlav',
        author_website => 'www.sandreckoning.com',

        talk_code => 'github.com/christianlavoie/haskell-midi',
        talk_title => 'Haskell and MIDI Instruments',
        talk_level => 'intermediate',
        talk_slides => 'goo.gl/Fhuh3S',
        talk_text => 'Christian will demonstrate a handful of Haskell libraries like <a href="https://hackage.haskell.org/package/QuickCheck">QuickCheck</a>, <a href="https://hackage.haskell.org/package/hspec">hspec</a>, <a href="https://hackage.haskell.org/package/cereal">cereal</a>, <a href="https://hackage.haskell.org/package/attoparsec">attoparsec</a> and <a href="https://hackage.haskell.org/package/websockets">websockets</a>. But most interestingly, show a way to use Haskell in the browser: the <a href="http://haste-lang.org/">Haste Programming Language</a>.',
    );

    $previous_meetups .= "<hr class=\"small-split\">\n";

    $previous_meetups .= $c->render_to_string(
        template => 'talk',

        author_name => 'Guillaume Massé',
        author_avatar => 'https://avatars2.githubusercontent.com/u/921490?',

        author_github => 'MasseGuillaume',
        author_twitter => 'MasseGuillaume',

        talk_code => 'github.com/MasseGuillaume/Haskell-Mtl-Nix',
        talk_title => 'NixOS and Nix Package Manager',
        talk_level => 'intermediate',
        talk_text => 'Guillaume will demonstrate <a href="https://nixos.org/">NixOS</a> and <a href="https://nixos.org/nix/">Nix</a>, the purely functional package manager.',
    );

    $c->stash(next_meetup => $next_meetup);
    $c->stash(previous_meetups => $previous_meetups);
    $c->render('index', next_meetup => $next_meetup, previous_meetups => $previous_meetups);
};

# Start the Mojolicious command system
app->start;

__DATA__
@@ meetup.html.ep
        <div class="pure-u-1">
            <a href="<%= $url %>"><img class="meetup-logo" alt="meetup.com logo"
                                       src="http://img2.meetupstatic.com/img/8308650022681532654/header/logo-2x.png">
            <span class="date"><%= $date %></span><br>
            <span class="addr"><%= $addr %></span><br></a>
        </div>

@@ talk.html.ep
        <!-- <%= $author_name %>'s talk -->
        <div class="pure-u-lg-1-2 pure-u-1 talk-text">
            <% if (defined stash->{talk_title}) { %>
                <h3 class="title"><%= stash->{talk_title} %></h3>
            <% } %>

            <% if (defined stash->{talk_text}) { %>
                <p><%== stash->{talk_text} %></p>
            <% } %>

            <% if (not defined stash->{talk_level}) { %>
                <img alt="unknown level" src="https://img.shields.io/badge/talk%20level-unknown-lightgrey.svg"><br>
            <% } elsif (stash->{talk_level} eq 'beginner') { %>
                <img alt="beginner level" src="https://img.shields.io/badge/talk%20level-beginner-green.svg"><br>
            <% } elsif (stash->{talk_level} eq 'intermediate') { %>
                <img alt="intermediate level" src="https://img.shields.io/badge/talk%20level-intermediate-yellow.svg"><br>
            <% } elsif (stash->{talk_level} eq 'expert') { %>
                <img alt="expert level" src="https://img.shields.io/badge/talk%20level-expert-red.svg"><br>
            <% } else { %>
                <img alt="unknown level" src="https://img.shields.io/badge/talk%20level-unknown-lightgrey.svg"><br>
            <% } %>

            <% if (defined stash->{talk_code}) { %>
                %== badge_link_talk_code stash->{talk_code}
            <% } %>

            <% if (defined stash->{talk_slides}) { %>
                %== badge_link_talk_slides stash->{talk_slides}
            <% } %>
        </div>

        <div class="pure-u-lg-1-4 pure-u-sm-1-2 pure-u-1">
            <% if (defined stash->{author_avatar}) { %>
                %== sprintf "<img alt=\"avatar\" class=\"avatar\" src=\"" . stash->{author_avatar} . "\">"
            <% } else { %>
                <div class="avatar" style="background-color: grey:"></div>
            <% } %>
        </div>

        <div class="pure-u-lg-1-4 pure-u-sm-1-2 pure-u-1">
            <p class="title"><%= $author_name %></p>

            <% if (defined stash->{author_github}) { %>
                %== badge_link_author_github stash->{author_github}
            <% } %>

            <% if (defined stash->{author_linkedin}) { %>
                %== badge_link_author_linkedin stash->{author_linkedin}
            <% } %>

            <% if (defined stash->{author_reddit}) { %>
                %== badge_link_author_reddit stash->{author_reddit}
            <% } %>

            <% if (defined stash->{author_twitter}) { %>
                %== badge_link_author_twitter stash->{author_twitter}
            <% } %>

            <% if (defined stash->{author_website}) { %>
                %== badge_link_author_website stash->{author_website}
            <% } %>
        </div>

@@ index.html.ep

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="A layout example that shows off a responsive product landing page.">

    <title>Montreal Haskellers Meetup</title>

    <link rel="stylesheet" href="normalize.css">
    <link rel="stylesheet" href="purecss/pure-min.css">
    <link rel="stylesheet" href="purecss/grids-responsive.css">
    <link rel="stylesheet" href="marketing.css">

    <style>
        .addr {
            font-variant: small-caps;
            font-size: smaller;
            padding-left: 10px;
        }

        .date {
            font-variant: small-caps;
            font-size: larger;
            padding-left: 10px;
        }

        .links {
            text-align: center;
        }

        .talk-text {
            padding-bottom: 50px;
        }

        .title {
            font-weight: bolder;
        }

        .twitter-widget {
            text-align: center;
        }

        div.purple-on-white {
            background-color: white;
            color: #342A52;
            padding: 0 3% 3% 3%;
        }

        .purple-on-white a {
            color: #342A52;
        }

        .purple-on-white h1 {
            color: #342A52;
            text-align: center;
        }

        .purple-on-white h2 {
            color: #342A52;
            text-align: center;
        }

        .purple-on-white h3 {
            color: #342A52;
            text-align: center;
        }

        .purple-on-white {
            color: #342A52;
        }

        div.white-on-purple {
            background-color: #342A52;
            color: white;
            padding: 0 3% 3% 3%;
        }

        .white-on-purple a {
            color: white;
        }

        .white-on-purple h1 {
            color: white;
            text-align: center;
        }

        .white-on-purple h2 {
            color: white;
            text-align: center;
        }

        .white-on-purple h3 {
            color: white;
            text-align: center;
        }

        .white-on-purple {
            color: white;
        }

        a {
            font-variant: small-caps;
            font-weight: bolder;
            color: white;
        }

        img.avatar {
            height: 180px;
            margin: 5%;
            width: 180px;
        }

        img.haskell-logo {
            float: left;
            margin: 25px;
        }

        img.meetup-logo {
            float: left;
            width: 68px;
            height: 45px;
        }

        hr.large-split {
            border-style: dashed;
            border-width: 3px 0 0 0;
            color: #342A52;
            margin: 40px auto 40px auto;
            width: 50%;
        }

        hr.small-split {
            border-style: dashed;
            border-width: 1px 0 0 0;
            color: #342A52;
            margin: 20px auto 20px auto;
            width: 35%;
        }

        body {
            margin: 0;
            padding: 0;
        }
    </style>
</head>

<body><div class="pure-g">
    <div class="white-on-purple">
        <div class="pure-u-1">
            <h1>Montreal Haskellers Meetup</h1>
        </div>

        <div class="pure-u-md-1-2 pure-u-1">
            <img src="https://wiki.haskell.org/wikiupload/4/4a/HaskellLogoStyPreview-1.png"
                 class="haskell-logo" alt="Haskell Logo">

            <p>We are the Montreal Haskellers.</p>

            <p>We are a community that meets 6 times a year to discuss functional programming, welcome newcomers to the community and exchange amongst ourselves.</p>

            <p>We are aiming to expand our knowledge, understand our tools better and grow their usage.</p>

            <p>You should be a part of that community.</p>
        </div>

        <div class="pure-u-md-1-2 pure-u-1">
            <div class="twitter-widget"><a class="twitter-timeline" href="https://twitter.com/search?q=%23montreal%20%23haskell" data-widget-id="650461506920800256">Tweets about #montreal #haskell</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script></div>
        </div>

        <div class="pure-u-1 links">
            <a href="#next">Our Next Meetup</a> | <a href="#digs">Our Digs</a> | <a href="#previous">Our Previous Meetups</a> | <a href="#links">Links</a> | <a href="#sponsors">Sponsors</a>
        </div>
    </div>

    <div class="purple-on-white">
        <div class="pure-u-1">
            <h2><a id="next">Our Next Meetup</a></h2>
        </div>

        <div class="pure-u-1">
            <a href="http://www.meetup.com/Haskellers-Montreal-Meetup/events/223004218/"><img
                  class="meetup-logo" alt="meetup.com logo"
                  src="http://img2.meetupstatic.com/img/8308650022681532654/header/logo-2x.png">
                <span class="date">Wednesday, October 7, 2015 @ 18:30</span><br>
                <span class="addr">RPM, 420 rue Guy, Montréal, QC</span></a>
        </div>

        <%== $next_meetup %>

    </div>

    <div class="white-on-purple">
        <div class="pure-u-1">
            <h2><a id="digs">Our digs: RPM, 420 Rue Guy, Montr&eacute;al</a></h2>

            <iframe style="width: 100%; height: 100%; border:0; min-height: 450px;" src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2797.0165586740145!2d-73.56659279999997!3d45.48961130000001!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x4cc91a638a6b442b%3A0xe315ad11de05f102!2sCentre+cloud.ca!5e0!3m2!1sen!2sca!4v1443915930301"></iframe>
        </div>
    </div>

    <div class="purple-on-white">
        <div class="pure-u-1">
            <h2><a id="previous">Our Previous Meetups</a></h2>
        </div>

        <%== $previous_meetups %>
    </div>

    <div class="white-on-purple">
        <div style="padding: 3%" class="pure-u-1 pure-u-sm-1-2 white-on-purple">
            <h2><a id="links">Links</a></h2>

            <p>The <a href="http://www.haskell.org">Haskell Programming Language</a> homepage is the main resource to learn the language.</p>

            <p><a href="http://www.meetup.com/Haskellers-Montreal-Meetup">Our Calendar</a> should provide you with a way to get reminders about our events and you can discuss Haskell topics on <a href="https://groups.google.com/forum/#!forum/haskellers-montreal">Our Google Group</a>.</p>

            <p>For those interested in other languages and technologies in Montreal, the Montreal Haskellers recommend the <a href="http://js-montreal.org/">JavaScript meetup</a>, the <a href="http://www.meetup.com/mtl-rb/">Ruby Meetup</a> and the <a href="http://big-data.meetup.com/cities/ca/qc/montr%C3%A9al/">BigData meetup</a>.</p>
        </div>

        <div style="padding: 3%" class="pure-u-1 pure-u-sm-1-2 white-on-purple">
            <h2><a id="sponsors">Sponsors</a></h2>

            <p><strong><a href="http://www.sandreckoning.com">Sand Reckoning Consulting</a></strong> provides technical due diligence consulting for startup investors and infrastructure development for startups.</p>

            <p><strong><a href="https://cloud.ca">cloud.ca</a></strong>&apos;s platform works as a standalone IaaS and also fits perfectly into CloudOps&apos; hybrid cloud solutions, allowing a mix of private cloud and other public cloud infrastructures such as Amazon Web Services (AWS).</p>

            <!-- <p><strong><a href="http://d3center.ca/">District 3 Innovation Center</a></strong> is an entrepreneurial community within Concordia University at the heart of downtown Montréal, bringing people together to collaborate, create and innovate.</p> -->
        </div>
    </div>
</div>

</body>
</html>
