use v6;

use Test;
use IRC::Utils;

plan 3;

{
    my Str $nick    = '^{soh|cah|toa}^';
    my Str $uc_nick = uc_irc $nick;

    is $uc_nick,  '~[SOH\CAH\TOA]~', 'One arg uc_irc()';
}

{
    my Str $nick     = 'soh_cah_toa';
    my Str $uc_ascii = uc_irc $nick, 'ascii';

    is $uc_ascii, 'SOH_CAH_TOA', 'Two arg uc_irc() with "ascii"';
}

{
    my Str $nick      = '{soh|cah|toa}';
    my Str $uc_strict = uc_irc $nick, 'strict-rfc1459';

    is $uc_strict,  '[SOH\CAH\TOA]', 'One arg uc_irc() with "strict-rfc1459"';
}

done;

# vim: ft=perl6

