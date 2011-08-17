use v6;

use Test;
use IRC::Utils;

plan *;
#plan 18;

# Test numeric_to_name()
{
    my Int $code      = 332;
    my Str $rpl_topic = numeric_to_name($code);

    is $rpl_topic, 'RPL_TOPIC', 'Check numeric_to_name()';
}

# Test name_to_numeric()
{
    my Str $rpl_topic = 'RPL_TOPIC';
    my Int $code      = name_to_numeric($rpl_topic);

    is $code, 332, 'Check name_to_numeric()';
}

# Test uc_irc()
{
    my Str $nick    = '^{soh|cah|toa}^';
    my Str $uc_nick = uc_irc $nick;

    is $uc_nick,  '~[SOH\CAH\TOA]~', 'Check one arg uc_irc()';
}

{
    my Str $nick     = 'soh_cah_toa';
    my Str $uc_ascii = uc_irc $nick, 'ascii';

    is $uc_ascii, 'SOH_CAH_TOA', 'Check two arg uc_irc() with "ascii"';
}

{
    my Str $nick      = '{soh|cah|toa}';
    my Str $uc_strict = uc_irc $nick, 'strict-rfc1459';

    is $uc_strict,  '[SOH\CAH\TOA]', 'Check one arg uc_irc() with "strict-rfc1459"';
}

# Test lc_irc()
{
    my Str $nick    = '~[SOH\CAH\TOA]~';
    my Str $lc_nick = lc_irc $nick;

    is $lc_nick,  '^{soh|cah|toa}^', 'Check one arg lc_irc()';
}

{
    my Str $nick     = 'SOH_CAH_TOA';
    my Str $lc_ascii = lc_irc $nick, 'ascii';

    is $lc_ascii, 'soh_cah_toa', 'Check two arg lc_irc() with "ascii"';
}

{
    my Str $nick      = '[SOH\CAH\TOA]';
    my Str $lc_strict = lc_irc $nick, 'strict-rfc1459';

    is $lc_strict,  '{soh|cah|toa}', 'Check one arg lc_irc() with "strict-rfc1459"';
}

# Test eq_irc()
{
    my Str  $uc = '[S0H~C4H~T04]';
    my Str  $lc = '{s0h~c4h~t04}';
    my Bool $eq = eq_irc($uc, $lc);

    ok $eq, 'Check eq_irc()';
}

# Test is_valid_nick_name()
{
    my Str  $nick  = '{soh_cah_toa}';
    my Bool $valid = is_valid_nick_name($nick);

    ok $valid, 'Check is_valid_nick_name() with valid nickname';
}

{
    my Str  $nick  = '{soh=cah=toa}';
    my Bool $valid = is_valid_nick_name($nick);

    nok $valid, 'Check is_valid_nick_name() with invalid nickname';
}

# Test is_valid_chan_name()
{
    my Str  $chan  = '#foobar';
    my Bool $valid = is_valid_chan_name($chan);

    ok $valid, 'Check one arg is_valid_chan_name() with valid channel';
}

{
    my Str  $chan  = '#foo:bar';
    my Bool $valid = is_valid_chan_name($chan);

    nok $valid, 'Check one arg is_valid_chan_name() with invalid channel';
}

{
    my Str  $chan  = 'foobar';
    my Bool $valid = is_valid_chan_name($chan, ['&']);

    ok $valid, 'Check two arg is_valid_chan_name() with valid channel';
}

{
    my Str  $chan  = '#foo:bar';
    my Bool $valid = is_valid_chan_name($chan, ['#', '%']);

    nok $valid, 'Check two arg is_valid_chan_name() with invalid channel';
}

# Test parse_user()
{
    my Str $fqn                  = 'foo!bar@baz.net';
    my Str ($nick, $user, $host) = parse_user($fqn);

    is $nick, 'foo',     'Check parse_user() nickname';
    is $user, 'bar',     'Check parse_user() username';
    is $host, 'baz.net', 'Check parse_user() hostname';
}

# Test has_color()
{
    my Str  $color_msg = "\x0304,05This is a colored message\x03";
    my Bool $has_color = has_color($color_msg);

    ok $has_color, 'Check has_color() with colored message';
}

{
    my Str  $normal_msg = 'This is a normal message';
    my Bool $has_color  = has_color($normal_msg);

    nok $has_color, 'Check has_color() with normal message';
}

# Test has_formatting()
{
    my $fmt_msg = "This message has \x1funderlined\x0f text";
    my $has_fmt = has_formatting($fmt_msg);

    ok $has_fmt, 'Check has_formatting() with formatted text';
}

{
    my $normal_msg = 'This message has no formatted text';
    my $has_fmt    = has_formatting($normal_msg);

    ok $has_fmt, 'Check has_formatting() with normal text';
}

done;

# vim: ft=perl6

