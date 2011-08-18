# Copyright (C) 2011, Kevin Polulak <kpolulak@gmail.com>.

=begin Pod

=head1 NAME

IRC::Utils - useful utilities for use in other IRC-related modules

=head1 SYNOPSIS

    use IRC::Utils;

    my Str $nick    = '[foo]^BAR^[baz]';
    my Str $uc_nick = uc_irc($nick);
    my Str $lc_nick = lc_irc($nick);

    # Check equivalence of two nicknames
    if eq_irc($uc_nick, $lc_nick) {
        say "These nicknames are the same!";
    }

    # Check if nickname conforms to RFC1459
    if is_valid_nick_name($nick) {
        say "Nickname is valid!";
    }

=head1 DESCRIPTION

The C<IRC::Utils> module provides a procedural interface for performing many
common IRC-related tasks such as comparing nicknames, changing user modes,
normalizing ban masks, etc. It is meant to be used as a base module for
creating other IRC-related modules.

=head1 SUBROUTINES

=head2 B<uc_irc(Str $value, Str $type)>

Converts a string to uppercase that conforms to the allowable characters as
defined by RFC 1459.

The C<$value> parameter is required and represents the string to convert to
uppercase.

The C<$type> parameter is optional and represents the casemapping. It can be
'rfc1459', 'strict-rfc1459', or 'ascii'. Defaults to 'rfc1459'.

Returns the value of C<$value> converted to uppercase according to C<$type>.

=head2 B<lc_irc(Str $value, Str $type)>

Converts a string to lowercase that conforms to the allowable characters as
defined by RFC 1459.

The C<$value> parameter is required and represents the string to convert to
lowercase.

The C<$type> parameter is optional and represents the casemapping. It can be
'rfc1459', 'strict-rfc1459', or 'ascii'. Defaults to 'rfc1459'.

Returns the value of C<$value> converted to lowercase according to C<$type>.

=head2 B<eq_irc(Str $first, Str $second, Str $type)>

Checks the equivalence of two strings.

The C<$first> parameter is a string representing the first string to
compare.

The C<$second> parameter is a string representing the second string to
compare.

The C<$type> parameter is optional and represents the casemapping. It can be
'rfc1459', 'strict-rfc1459', or 'ascii'. Defaults to 'rfc1459'.

Returns C<Bool::True> if the nicknames are equivalent and C<Bool::False>
otherwise.

=head2 B<normalize_mask(@str)>

Fully qualifies or "normalizes" a host/server mask.

The C<@str> argument is a string representing a host/server mask.

Returns C<@str> as a fully qualified mask.

=head2 B<numeric_to_name(Int $code)>

Converts a numeric code to its string representation. Includes all values
defined by RFC1459 but also includes a few network-specific extensions.

The C<$code> parameter is an integer representing the numerical reply or
error code. For instance, 461 which is C<ERR_NEEDMOREPARAMS>.

Returns the string representation of C<$code>.

=head2 B<name_to_numeric(Str $name)>

Converts a string to its numeric representation. Includes all values
defined by RFC1459 but also includes a few network-specific extensions.

The C<$name> parameter is a string representing the reply or error code. For
instance, C<ERR_NEEDMOREPARAMS> is 461.

Returns the numerical representation of C<$name>.

=head2 B<is_valid_nick_name(Str $nick)>

Checks if a nickname is valid. That is, it conforms to the allowable
characters defined in RFC 1459.

The C<$nick> parameter is a string representing the nickname to check.

Returns C<Bool::True> if C<$nick> is a valid nickname and C<Bool::False>
otherwise.

=head2 B<is_valid_chan_name(Str $chan, Str @types)>

Checks if a channel name is valid. That is, it conforms to the allowable
characters defined in RFC 1459.

The C<$chan> parameter is a string representing the channel name to check.

The C<@types> parameter is optional and is an anonymous list of channel types.
For instance, '#'. Defaults to C<['#', '&']>.

Returns C<Bool::True> if C<$nick> is a valid nickname and C<Bool::False>
otherwise.

=head2 B<parse_user(Str $user)>

Parses a username and splits it into the parts representing the nickname,
username, and hostname.

The C<$user> parameter is a string representing the fully qualified username to
parse. It must be of the form C<nick!user@host>.

Returns a list containing the nickname, username, and hostname parts of
C<$user>.

=head2 B<has_color(Str $string)>

Checks if a string contains any color codes.

The C<$string> parameter is the string to check.

Returns C<Bool::True> if C<$string> contains any color codes and C<Bool::False>
otherwise.

=head2 B<has_formatting(Str $string)>

Checks if a string contains any formatting codes.

The C<$string> parameter is the string to check.

Returns C<Bool::True> is C<$string> contains any formatting codes and
C<Bool::False> otherwise.

=head2 B<strip_color(Str $string)>

Strips a string of all embedded color codes.

The C<$string> parameter is the string to strip.

Returns the string given in C<$string> with all embedded color codes removed.
If the given string does not contain any color codes, the original string is
returned as is.

=head2 B<strip_formatting(Str $string)>

Strips a string of all embedded text format codes.

The C<$string> parameter is the string to strip.

Returns the string given in C<$string> with all embedded text format codes
removed. If the given string does not contain any text formatting codes, the
original string is returned as is.

=end Pod

=cut

module IRC::Utils;

our $NORMAL      = "\x0f";

# Text formats
our $BOLD        = "\x02";
our $UNDERLINE   = "\x1f";
our $REVERSE     = "\x16";
our $ITALIC      = "\x1d";
our $FIXED       = "\x11";
our $BLINK       = "\x06";

# Color formats
our $WHITE       = "\x0300";
our $BLACK       = "\x0301";
our $BLUE        = "\x0302";
our $GREEN       = "\x0303";
our $RED         = "\x0304";
our $BROWN       = "\x0305";
our $PURPLE      = "\x0306";
our $ORANGE      = "\x0307";
our $YELLOW      = "\x0308";
our $LIGHT_GREEN = "\x0309";
our $TEAL        = "\x0310";
our $LIGHT_CYAN  = "\x0311";
our $LIGHT_BLUE  = "\x0312";
our $PINK        = "\x0313";
our $GREY        = "\x0314";
our $LIGHT_GREY  = "\x0315";

# Associates numeric codes with their string representation
our %NUMERIC2NAME =
   001 => 'RPL_WELCOME',           # RFC2812
   002 => 'RPL_YOURHOST',          # RFC2812
   003 => 'RPL_CREATED',           # RFC2812
   004 => 'RPL_MYINFO',            # RFC2812
   005 => 'RPL_ISUPPORT',          # draft-brocklesby-irc-isupport-03
   008 => 'RPL_SNOMASK',           # Undernet
   009 => 'RPL_STATMEMTOT',        # Undernet
   010 => 'RPL_STATMEM',           # Undernet
   020 => 'RPL_CONNECTING',        # IRCnet
   014 => 'RPL_YOURCOOKIE',        # IRCnet
   042 => 'RPL_YOURID',            # IRCnet
   043 => 'RPL_SAVENICK',          # IRCnet
   050 => 'RPL_ATTEMPTINGJUNC',    # aircd
   051 => 'RPL_ATTEMPTINGREROUTE', # aircd
   200 => 'RPL_TRACELINK',         # RFC1459
   201 => 'RPL_TRACECONNECTING',   # RFC1459
   202 => 'RPL_TRACEHANDSHAKE',    # RFC1459
   203 => 'RPL_TRACEUNKNOWN',      # RFC1459
   204 => 'RPL_TRACEOPERATOR',     # RFC1459
   205 => 'RPL_TRACEUSER',         # RFC1459
   206 => 'RPL_TRACESERVER',       # RFC1459
   207 => 'RPL_TRACESERVICE',      # RFC2812
   208 => 'RPL_TRACENEWTYPE',      # RFC1459
   209 => 'RPL_TRACECLASS',        # RFC2812
   210 => 'RPL_STATS',             # aircd
   211 => 'RPL_STATSLINKINFO',     # RFC1459
   212 => 'RPL_STATSCOMMANDS',     # RFC1459
   213 => 'RPL_STATSCLINE',        # RFC1459
   214 => 'RPL_STATSNLINE',        # RFC1459
   215 => 'RPL_STATSILINE',        # RFC1459
   216 => 'RPL_STATSKLINE',        # RFC1459
   217 => 'RPL_STATSQLINE',        # RFC1459
   218 => 'RPL_STATSYLINE',        # RFC1459
   219 => 'RPL_ENDOFSTATS',        # RFC1459
   221 => 'RPL_UMODEIS',           # RFC1459
   231 => 'RPL_SERVICEINFO',       # RFC1459
   233 => 'RPL_SERVICE',           # RFC1459
   234 => 'RPL_SERVLIST',          # RFC1459
   235 => 'RPL_SERVLISTEND',       # RFC1459
   239 => 'RPL_STATSIAUTH',        # IRCnet
   241 => 'RPL_STATSLLINE',        # RFC1459
   242 => 'RPL_STATSUPTIME',       # RFC1459
   243 => 'RPL_STATSOLINE',        # RFC1459
   244 => 'RPL_STATSHLINE',        # RFC1459
   245 => 'RPL_STATSSLINE',        # Bahamut, IRCnet, Hybrid
   250 => 'RPL_STATSCONN',         # ircu, Unreal
   251 => 'RPL_LUSERCLIENT',       # RFC1459
   252 => 'RPL_LUSEROP',           # RFC1459
   253 => 'RPL_LUSERUNKNOWN',      # RFC1459
   254 => 'RPL_LUSERCHANNELS',     # RFC1459
   255 => 'RPL_LUSERME',           # RFC1459
   256 => 'RPL_ADMINME',           # RFC1459
   257 => 'RPL_ADMINLOC1',         # RFC1459
   258 => 'RPL_ADMINLOC2',         # RFC1459
   259 => 'RPL_ADMINEMAIL',        # RFC1459
   261 => 'RPL_TRACELOG',          # RFC1459
   262 => 'RPL_TRACEEND',          # RFC2812
   263 => 'RPL_TRYAGAIN',          # RFC2812
   265 => 'RPL_LOCALUSERS',        # aircd, Bahamut, Hybrid
   266 => 'RPL_GLOBALUSERS',       # aircd, Bahamut, Hybrid
   267 => 'RPL_START_NETSTAT',     # aircd
   268 => 'RPL_NETSTAT',           # aircd
   269 => 'RPL_END_NETSTAT',       # aircd
   270 => 'RPL_PRIVS',             # ircu
   271 => 'RPL_SILELIST',          # ircu
   272 => 'RPL_ENDOFSILELIST',     # ircu
   300 => 'RPL_NONE',              # RFC1459
   301 => 'RPL_AWAY',              # RFC1459
   302 => 'RPL_USERHOST',          # RFC1459
   303 => 'RPL_ISON',              # RFC1459
   305 => 'RPL_UNAWAY',            # RFC1459
   306 => 'RPL_NOWAWAY',           # RFC1459
   307 => 'RPL_WHOISREGNICK',      # Bahamut, Unreal, Plexus
   310 => 'RPL_WHOISMODES',        # Plexus
   311 => 'RPL_WHOISUSER',         # RFC1459
   312 => 'RPL_WHOISSERVER',       # RFC1459
   313 => 'RPL_WHOISOPERATOR',     # RFC1459
   314 => 'RPL_WHOWASUSER',        # RFC1459
   315 => 'RPL_ENDOFWHO',          # RFC1459
   317 => 'RPL_WHOISIDLE',         # RFC1459
   318 => 'RPL_ENDOFWHOIS',        # RFC1459
   319 => 'RPL_WHOISCHANNELS',     # RFC1459
   321 => 'RPL_LISTSTART',         # RFC1459
   322 => 'RPL_LIST',              # RFC1459
   323 => 'RPL_LISTEND',           # RFC1459
   324 => 'RPL_CHANNELMODEIS',     # RFC1459
   325 => 'RPL_UNIQOPIS',          # RFC2812
   328 => 'RPL_CHANNEL_URL',       # Bahamut, AustHex
   329 => 'RPL_CREATIONTIME',      # Bahamut
   330 => 'RPL_WHOISACCOUNT',      # ircu
   331 => 'RPL_NOTOPIC',           # RFC1459
   332 => 'RPL_TOPIC',             # RFC1459
   333 => 'RPL_TOPICWHOTIME',      # ircu
   338 => 'RPL_WHOISACTUALLY',     # Bahamut, ircu
   340 => 'RPL_USERIP',            # ircu
   341 => 'RPL_INVITING',          # RFC1459
   342 => 'RPL_SUMMONING',         # RFC1459
   345 => 'RPL_INVITED',           # GameSurge
   346 => 'RPL_INVITELIST',        # RFC2812
   347 => 'RPL_ENDOFINVITELIST',   # RFC2812
   348 => 'RPL_EXCEPTLIST',        # RFC2812
   349 => 'RPL_ENDOFEXCEPTLIST',   # RFC2812
   351 => 'RPL_VERSION',           # RFC1459
   352 => 'RPL_WHOREPLY',          # RFC1459
   353 => 'RPL_NAMREPLY',          # RFC1459
   354 => 'RPL_WHOSPCRPL',         # ircu
   355 => 'RPL_NAMREPLY_',         # QuakeNet
   361 => 'RPL_KILLDONE',          # RFC1459
   362 => 'RPL_CLOSING',           # RFC1459
   363 => 'RPL_CLOSEEND',          # RFC1459
   364 => 'RPL_LINKS',             # RFC1459
   365 => 'RPL_ENDOFLINKS',        # RFC1459
   366 => 'RPL_ENDOFNAMES',        # RFC1459
   367 => 'RPL_BANLIST',           # RFC1459
   368 => 'RPL_ENDOFBANLIST',      # RFC1459
   369 => 'RPL_ENDOFWHOWAS',       # RFC1459
   371 => 'RPL_INFO',              # RFC1459
   372 => 'RPL_MOTD',              # RFC1459
   373 => 'RPL_INFOSTART',         # RFC1459
   374 => 'RPL_ENDOFINFO',         # RFC1459
   375 => 'RPL_MOTDSTART',         # RFC1459
   376 => 'RPL_ENDOFMOTD',         # RFC1459
   381 => 'RPL_YOUREOPER',         # RFC1459
   382 => 'RPL_REHASHING',         # RFC1459
   383 => 'RPL_YOURESERVICE',      # RFC2812
   384 => 'RPL_MYPORTIS',          # RFC1459
   385 => 'RPL_NOTOPERANYMORE',    # AustHex, Hybrid, Unreal
   391 => 'RPL_TIME',              # RFC1459
   392 => 'RPL_USERSSTART',        # RFC1459
   393 => 'RPL_USERS',             # RFC1459
   394 => 'RPL_ENDOFUSERS',        # RFC1459
   395 => 'RPL_NOUSERS',           # RFC1459
   396 => 'RPL_HOSTHIDDEN',        # Undernet
   401 => 'ERR_NOSUCHNICK',        # RFC1459
   402 => 'ERR_NOSUCHSERVER',      # RFC1459
   403 => 'ERR_NOSUCHCHANNEL',     # RFC1459
   404 => 'ERR_CANNOTSENDTOCHAN',  # RFC1459
   405 => 'ERR_TOOMANYCHANNELS',   # RFC1459
   406 => 'ERR_WASNOSUCHNICK',     # RFC1459
   407 => 'ERR_TOOMANYTARGETS',    # RFC1459
   408 => 'ERR_NOSUCHSERVICE',     # RFC2812
   409 => 'ERR_NOORIGIN',          # RFC1459
   411 => 'ERR_NORECIPIENT',       # RFC1459
   412 => 'ERR_NOTEXTTOSEND',      # RFC1459
   413 => 'ERR_NOTOPLEVEL',        # RFC1459
   414 => 'ERR_WILDTOPLEVEL',      # RFC1459
   415 => 'ERR_BADMASK',           # RFC2812
   421 => 'ERR_UNKNOWNCOMMAND',    # RFC1459
   422 => 'ERR_NOMOTD',            # RFC1459
   423 => 'ERR_NOADMININFO',       # RFC1459
   424 => 'ERR_FILEERROR',         # RFC1459
   425 => 'ERR_NOOPERMOTD',        # Unreal
   429 => 'ERR_TOOMANYAWAY',       # Bahamut
   430 => 'ERR_EVENTNICKCHANGE',   # AustHex
   431 => 'ERR_NONICKNAMEGIVEN',   # RFC1459
   432 => 'ERR_ERRONEUSNICKNAME',  # RFC1459
   433 => 'ERR_NICKNAMEINUSE',     # RFC1459
   436 => 'ERR_NICKCOLLISION',     # RFC1459
   439 => 'ERR_TARGETTOOFAST',     # ircu
   440 => 'ERR_SERCVICESDOWN',     # Bahamut, Unreal
   441 => 'ERR_USERNOTINCHANNEL',  # RFC1459
   442 => 'ERR_NOTONCHANNEL',      # RFC1459
   443 => 'ERR_USERONCHANNEL',     # RFC1459
   444 => 'ERR_NOLOGIN',           # RFC1459
   445 => 'ERR_SUMMONDISABLED',    # RFC1459
   446 => 'ERR_USERSDISABLED',     # RFC1459
   447 => 'ERR_NONICKCHANGE',      # Unreal
   449 => 'ERR_NOTIMPLEMENTED',    # Undernet
   451 => 'ERR_NOTREGISTERED',     # RFC1459
   455 => 'ERR_HOSTILENAME',       # Unreal
   459 => 'ERR_NOHIDING',          # Unreal
   460 => 'ERR_NOTFORHALFOPS',     # Unreal
   461 => 'ERR_NEEDMOREPARAMS',    # RFC1459
   462 => 'ERR_ALREADYREGISTRED',  # RFC1459
   463 => 'ERR_NOPERMFORHOST',     # RFC1459
   464 => 'ERR_PASSWDMISMATCH',    # RFC1459
   465 => 'ERR_YOUREBANNEDCREEP',  # RFC1459
   466 => 'ERR_YOUWILLBEBANNED',   # RFC1459
   467 => 'ERR_KEYSET',            # RFC1459
   469 => 'ERR_LINKSET',           # Unreal
   471 => 'ERR_CHANNELISFULL',     # RFC1459
   472 => 'ERR_UNKNOWNMODE',       # RFC1459
   473 => 'ERR_INVITEONLYCHAN',    # RFC1459
   474 => 'ERR_BANNEDFROMCHAN',    # RFC1459
   475 => 'ERR_BADCHANNELKEY',     # RFC1459
   476 => 'ERR_BADCHANMASK',       # RFC2812
   477 => 'ERR_NOCHANMODES',       # RFC2812
   478 => 'ERR_BANLISTFULL',       # RFC2812
   481 => 'ERR_NOPRIVILEGES',      # RFC1459
   482 => 'ERR_CHANOPRIVSNEEDED',  # RFC1459
   483 => 'ERR_CANTKILLSERVER',    # RFC1459
   484 => 'ERR_RESTRICTED',        # RFC2812
   485 => 'ERR_UNIQOPPRIVSNEEDED', # RFC2812
   488 => 'ERR_TSLESSCHAN',        # IRCnet
   491 => 'ERR_NOOPERHOST',        # RFC1459
   492 => 'ERR_NOSERVICEHOST',     # RFC1459
   493 => 'ERR_NOFEATURE',         # ircu
   494 => 'ERR_BADFEATURE',        # ircu
   495 => 'ERR_BADLOGTYPE',        # ircu
   496 => 'ERR_BADLOGSYS',         # ircu
   497 => 'ERR_BADLOGVALUE',       # ircu
   498 => 'ERR_ISOPERLCHAN',       # ircu
   501 => 'ERR_UMODEUNKNOWNFLAG',  # RFC1459
   502 => 'ERR_USERSDONTMATCH',    # RFC1459
   503 => 'ERR_GHOSTEDCLIENT';     # Hybrid

# Associates string representation with their numeric codes
our %NAME2NUMERIC;

{
    my Int @keys  = %NUMERIC2NAME.keys;
    my Str @vals  = %NUMERIC2NAME.values;

    %NAME2NUMERIC = @vals Z @keys;
}

sub numeric_to_name(Int $code) is export {
    return %NUMERIC2NAME{$code};
}

sub name_to_numeric(Str $name) is export {
    return %NAME2NUMERIC{$name}.Int;
}

sub uc_irc(Str $value is copy, Str $type = 'rfc1459') is export {
    my $t = $type.lc;

    if $t ~~ 'ascii' {
        $value.=trans('a..z' => 'A..Z');
    }
    elsif $t ~~ 'strict-rfc1459' {
        $value.=trans('a..z{}|' => 'A..Z[]\\');
    }
    else {
        $value.=trans('a..z{}|^' => 'A..Z[]\\~');
    }

    return $value;
}

sub lc_irc(Str $value is copy, Str $type = 'rfc1459') is export {
    my $t = $type.lc;

    if $t ~~ 'ascii' {
        $value.=trans('A..Z' => 'a..z');
    }
    elsif $t ~~ 'strict-rfc1459' {
        $value.=trans('A..Z[]\\' => 'a..z{}|');
    }
    else {
        $value.=trans('A..Z[]\\~' => 'a..z{}|^');
    }

    return $value;
}

sub eq_irc(Str $first, Str $second, Str $type = 'rfc1459') is export {
    return Bool::False if !$first.defined || !$second.defined;

    return Bool::True  if lc_irc($first, $type) eq lc_irc($second, $type);
    return Bool::False;
}

# TODO This subroutine doesn't work quite right just yet so once it does,
#      make sure to export it

sub parse_mode_line(@args) {
    my $chan_modes = [<beI k l imnpstaqr>];
    my $stat_modes = 'ohv';
    my %hash       = Nil;
    my $count      = 0;

    #for @args -> $arg
    while my $arg = @args[$count] {
        if $arg.WHAT.perl eq 'Array' {
            $chan_modes = $arg;
            next;
        }
        elsif $arg.WHAT.perl eq 'Hash' {
            $stat_modes = join '', $arg.keys;
            next;
        }
        elsif ($arg ~~ /^<[\- +]>/ or $count == 0) {
            my $action = '+';

            for $arg.split('') -> $c {
                if $c eq '+' | '-' {
                    $action = $c;
                }
                else {
                    %hash<modes> = ();
                    %hash<modes>.push($action ~ $c);
                }

                if $chan_modes[0].chars
                    && $chan_modes[1].chars
                    && $stat_modes.chars
                    && $c ~~ /[{$stat_modes} | {$chan_modes[0]} | {$chan_modes[1]}]/ {
                    #&& $c ~~ /<[{$stat_modes} {$chan_modes[0]} {$chan_modes[1]}]>/

                    %hash<args> = ();
                    %hash<args>.push(@args[$count]);
                    #%hash<args>.push(@args.shift);
                }

                if $chan_modes[2].chars
                    && $action eq '+' {
                    #&& $c ~~ /<[{$chan_modes[2]}]>/

                    %hash<args> = ();
                    %hash<args>.push(@args.shift);
                }
            }
        }
        else {
            %hash<args> = ();
            %hash<args>.push($arg);
        }

        $count++;
    }

    return %hash;
}

sub normalize_mask(*@str is copy) is export {
    my @mask;
    my $remainder;

    @str ~~ s:g/'*'**2..*/*/;

    if @str !~~ /'!'/ and @str ~~ /'@'/ {
        $remainder = @str;
        @mask[0]   = '*';
    }
    else {
        (@mask[0], $remainder) = @str.split('!', 2);
    }

    $remainder  ~~ s:g/'!'// if $remainder.defined;

    @mask[1,2] = $remainder.split('@', 2) if $remainder.defined;
    @mask[2]    ~~ s:g/'@'// if @mask[2].defined;

    for 1..2 -> $i {
        @mask[$i] = '*' if !@mask[$i].defined;
        #@mask[$i] = '*' if !defined @mask[$i];
    }

    return @mask[0] ~ '!' ~ @mask[1] ~ '@' ~ @mask[2];
}

sub is_valid_nick_name(Str $nick) is export {
    #my regex complex {  _ \` \- \^ \| \\ \{\} \[\] };
    #my regex complex { '_' '`' '-' '|' '\\' '{' '}' '[' ']' };

    # TODO Get 'complex' regex to interpolate properly to reduce duplication
    # TODO Add backslash to regex

    return Bool::True if $nick
        ~~ /^ <[A..Z a..z      _ \- ` ^ | \{\} \[\]]>
              <[A..Z a..z 0..9 _ \- ` ^ | \{\} \[\]]>* $/;

    return Bool::False;
}

# TODO Modify this to take just one arg and move #/& check into one regex b/c
#      even though this is how the Perl 5 IRC::Utils works, I don't like it

sub is_valid_chan_name(Str $chan, $types = ['#', '&']) is export {
    return Bool::False if $types.chars == 0;
    return Bool::False if $chan.bytes  >  200;
    return Bool::False if $types ~~ /^ <-['#' '&']> $/;

    for $types -> $t {
        my $c = $t ~ $chan;

        # Channels can't contain whitespace, commas, colons, null, or newlines
        return Bool::False if $c !~~ /^ $t <-[<.ws> \07 \0 \012 \015 , :]>+ $/;
    }

    return Bool::True;
}

sub parse_user(Str $user) is export {
    return $user.split(/<[!@]>/);
}

sub has_color(Str $string) is export {
    return Bool::True if $string ~~ /<[\x03 \x04 \x1b]>/;
    return Bool::False;
}

# TODO Create rule/regex for matching format codes to reduce duplication
#      in has_formatting() and strip_formatting()

sub has_formatting(Str $string) is export {
    return Bool::True if $string ~~ /<[\x02 \x1f \x16 \x1d \x11 \x06]>/;
    return Bool::False;
}

sub strip_color(Str $string is copy) is export {
    # Strip mIRC colors
    $string ~~ s:g/\x03 [\, \d**1..2 | \d**1..2 [\, \d**1..2]?]?//;

    # Strip other colors supported by certain clients
    $string ~~ s:g:i/\x04 <[0..9 a..f A..F]>**0..6//;

    # Strip ANSI escape codes
    $string ~~ s:g/\x1b \[ .*? <[\x00..\x1f \x40..\x7e]>//;

    # Strip terminating \x0f only if there aren't any formatting codes
    $string ~~ s:g/\x0f// if !has_formatting($string);

    return $string;
}

sub strip_formatting(Str $string is copy) is export {
    $string ~~ s:g/<[\017 \02 \037 \026 \035 \021 \06]>//;
    #$string ~~ s:g/<[\x0f \x02 \x1f \x16 \x1d \x11 \x06]>//;

    # Strip terminating \x0f only if there aren't any color codes
    $string ~~ s:g/<[\017]>// if !has_color($string);
    #$string ~~ s:g/\x0f// if !has_color($string);

    return $string;
}

# vim: ft=perl6

