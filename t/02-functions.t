use v6;

use Test;
use IRC::Utils;

plan 9;

# Test numeric_to_name()
{
    my Int $code      = 332;
    my Str $rpl_topic = numeric_to_name($code);

    is $rpl_topic, 'RPL_TOPIC', 'numeric_to_name()';
}

# Test name_to_numeric()
{
    my Str $rpl_topic = 'RPL_TOPIC';
    my Int $code      = name_to_numeric($rpl_topic);

    is $code, 332, 'name_to_numeric()';
}

# Test uc_irc()
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

# Test lc_irc()
{
    my Str $nick    = '~[SOH\CAH\TOA]~';
    my Str $lc_nick = lc_irc $nick;

    is $lc_nick,  '^{soh|cah|toa}^', 'One arg lc_irc()';
}

{
    my Str $nick     = 'SOH_CAH_TOA';
    my Str $lc_ascii = lc_irc $nick, 'ascii';

    is $lc_ascii, 'soh_cah_toa', 'Two arg lc_irc() with "ascii"';
}

{
    my Str $nick      = '[SOH\CAH\TOA]';
    my Str $lc_strict = lc_irc $nick, 'strict-rfc1459';

    is $lc_strict,  '{soh|cah|toa}', 'One arg lc_irc() with "strict-rfc1459"';
}

# Test eq_irc()
{
    my Str  $uc = '[S0H~C4H~T04]';
    my Str  $lc = '{s0h~c4h~t04}';
    my Bool $eq = eq_irc($uc, $lc);

    ok $eq, 'eq_irc()';
}

done;

# vim: ft=perl6

