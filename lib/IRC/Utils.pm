module IRC::Utils;

our $NORMAL      = "\x0f";
 
# Formatting
our $BOLD        = "\x02";
our $UNDERLINE   = "\x1f";
our $REVERSE     = "\x16";
our $ITALIC      = "\x1d";
our $FIXED       = "\x11";
our $BLINK       = "\x06";
 
# mIRC colors
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
 
# list originally snatched from AnyEvent::IRC::Util
our %NAME2NUMERIC = (
    :RPL_WELCOME(001),           # RFC2812
    :RPL_YOURHOST(002),          # RFC2812
    :RPL_CREATED(003),           # RFC2812
    :RPL_MYINFO(004),            # RFC2812
    :RPL_ISUPPORT(005),          # draft-brocklesby-irc-isupport-03
    :RPL_SNOMASK(008),           # Undernet
    :RPL_STATMEMTOT(009),        # Undernet
    :RPL_STATMEM(010),           # Undernet
    :RPL_CONNECTING(020),        # IRCnet
    :RPL_YOURCOOKIE(014),        # IRCnet
    :RPL_YOURID(042),            # IRCnet
    :RPL_SAVENICK(043),          # IRCnet
    :RPL_ATTEMPTINGJUNC(050),    # aircd
    :RPL_ATTEMPTINGREROUTE(051), # aircd
    :RPL_TRACELINK(200),         # RFC1459
    :RPL_TRACECONNECTING(201),   # RFC1459
    :RPL_TRACEHANDSHAKE(202),    # RFC1459
    :RPL_TRACEUNKNOWN(203),      # RFC1459
    :RPL_TRACEOPERATOR(204),     # RFC1459
    :RPL_TRACEUSER(205),         # RFC1459
    :RPL_TRACESERVER(206),       # RFC1459
    :RPL_TRACESERVICE(207),      # RFC2812
    :RPL_TRACENEWTYPE(208),      # RFC1459
    :RPL_TRACECLASS(209),        # RFC2812
    :RPL_STATS(210),             # aircd
    :RPL_STATSLINKINFO(211),     # RFC1459
    :RPL_STATSCOMMANDS(212),     # RFC1459
    :RPL_STATSCLINE(213),        # RFC1459
    :RPL_STATSNLINE(214),        # RFC1459
    :RPL_STATSILINE(215),        # RFC1459
    :RPL_STATSKLINE(216),        # RFC1459
    :RPL_STATSQLINE(217),        # RFC1459
    :RPL_STATSYLINE(218),        # RFC1459
    :RPL_ENDOFSTATS(219),        # RFC1459
    :RPL_UMODEIS(221),           # RFC1459
    :RPL_SERVICEINFO(231),       # RFC1459
    :RPL_SERVICE(233),           # RFC1459
    :RPL_SERVLIST(234),          # RFC1459
    :RPL_SERVLISTEND(235),       # RFC1459
    :RPL_STATSIAUTH(239),        # IRCnet
    :RPL_STATSLLINE(241),        # RFC1459
    :RPL_STATSUPTIME(242),       # RFC1459
    :RPL_STATSOLINE(243),        # RFC1459
    :RPL_STATSHLINE(244),        # RFC1459
    :RPL_STATSSLINE(245),        # Bahamut, IRCnet, Hybrid
    :RPL_STATSCONN(250),         # ircu, Unreal
    :RPL_LUSERCLIENT(251),       # RFC1459
    :RPL_LUSEROP(252),           # RFC1459
    :RPL_LUSERUNKNOWN(253),      # RFC1459
    :RPL_LUSERCHANNELS(254),     # RFC1459
    :RPL_LUSERME(255),           # RFC1459
    :RPL_ADMINME(256),           # RFC1459
    :RPL_ADMINLOC1(257),         # RFC1459
    :RPL_ADMINLOC2(258),         # RFC1459
    :RPL_ADMINEMAIL(259),        # RFC1459
    :RPL_TRACELOG(261),          # RFC1459
    :RPL_TRACEEND(262),          # RFC2812
    :RPL_TRYAGAIN(263),          # RFC2812
    :RPL_LOCALUSERS(265),        # aircd, Bahamut, Hybrid
    :RPL_GLOBALUSERS(266),       # aircd, Bahamut, Hybrid
    :RPL_START_NETSTAT(267),     # aircd
    :RPL_NETSTAT(268),           # aircd
    :RPL_END_NETSTAT(269),       # aircd
    :RPL_PRIVS(270),             # ircu
    :RPL_SILELIST(271),          # ircu
    :RPL_ENDOFSILELIST(272),     # ircu
    :RPL_NONE(300),              # RFC1459
    :RPL_AWAY(301),              # RFC1459
    :RPL_USERHOST(302),          # RFC1459
    :RPL_ISON(303),              # RFC1459
    :RPL_UNAWAY(305),            # RFC1459
    :RPL_NOWAWAY(306),           # RFC1459
    :RPL_WHOISREGNICK(307),      # Bahamut, Unreal, Plexus
    :RPL_WHOISMODES(310),        # Plexus
    :RPL_WHOISUSER(311),         # RFC1459
    :RPL_WHOISSERVER(312),       # RFC1459
    :RPL_WHOISOPERATOR(313),     # RFC1459
    :RPL_WHOWASUSER(314),        # RFC1459
    :RPL_ENDOFWHO(315),          # RFC1459
    :RPL_WHOISIDLE(317),         # RFC1459
    :RPL_ENDOFWHOIS(318),        # RFC1459
    :RPL_WHOISCHANNELS(319),     # RFC1459
    :RPL_LISTSTART(321),         # RFC1459
    :RPL_LIST(322),              # RFC1459
    :RPL_LISTEND(323),           # RFC1459
    :RPL_CHANNELMODEIS(324),     # RFC1459
    :RPL_UNIQOPIS(325),          # RFC2812
    :RPL_CHANNEL_URL(328),       # Bahamut, AustHex
    :RPL_CREATIONTIME(329),      # Bahamut
    :RPL_WHOISACCOUNT(330),      # ircu
    :RPL_NOTOPIC(331),           # RFC1459
    :RPL_TOPIC(332),             # RFC1459
    :RPL_TOPICWHOTIME(333),      # ircu
    :RPL_WHOISACTUALLY(338),     # Bahamut, ircu
    :RPL_USERIP(340),            # ircu
    :RPL_INVITING(341),          # RFC1459
    :RPL_SUMMONING(342),         # RFC1459
    :RPL_INVITED(345),           # GameSurge
    :RPL_INVITELIST(346),        # RFC2812
    :RPL_ENDOFINVITELIST(347),   # RFC2812
    :RPL_EXCEPTLIST(348),        # RFC2812
    :RPL_ENDOFEXCEPTLIST(349),   # RFC2812
    :RPL_VERSION(351),           # RFC1459
    :RPL_WHOREPLY(352),          # RFC1459
    :RPL_NAMREPLY(353),          # RFC1459
    :RPL_WHOSPCRPL(354),         # ircu
    :RPL_NAMREPLY_(355),         # QuakeNet
    :RPL_KILLDONE(361),          # RFC1459
    :RPL_CLOSING(362),           # RFC1459
    :RPL_CLOSEEND(363),          # RFC1459
    :RPL_LINKS(364),             # RFC1459
    :RPL_ENDOFLINKS(365),        # RFC1459
    :RPL_ENDOFNAMES(366),        # RFC1459
    :RPL_BANLIST(367),           # RFC1459
    :RPL_ENDOFBANLIST(368),      # RFC1459
    :RPL_ENDOFWHOWAS(369),       # RFC1459
    :RPL_INFO(371),              # RFC1459
    :RPL_MOTD(372),              # RFC1459
    :RPL_INFOSTART(373),         # RFC1459
    :RPL_ENDOFINFO(374),         # RFC1459
    :RPL_MOTDSTART(375),         # RFC1459
    :RPL_ENDOFMOTD(376),         # RFC1459
    :RPL_YOUREOPER(381),         # RFC1459
    :RPL_REHASHING(382),         # RFC1459
    :RPL_YOURESERVICE(383),      # RFC2812
    :RPL_MYPORTIS(384),          # RFC1459
    :RPL_NOTOPERANYMORE(385),    # AustHex, Hybrid, Unreal
    :RPL_TIME(391),              # RFC1459
    :RPL_USERSSTART(392),        # RFC1459
    :RPL_USERS(393),             # RFC1459
    :RPL_ENDOFUSERS(394),        # RFC1459
    :RPL_NOUSERS(395),           # RFC1459
    :RPL_HOSTHIDDEN(396),        # Undernet
    :ERR_NOSUCHNICK(401),        # RFC1459
    :ERR_NOSUCHSERVER(402),      # RFC1459
    :ERR_NOSUCHCHANNEL(403),     # RFC1459
    :ERR_CANNOTSENDTOCHAN(404),  # RFC1459
    :ERR_TOOMANYCHANNELS(405),   # RFC1459
    :ERR_WASNOSUCHNICK(406),     # RFC1459
    :ERR_TOOMANYTARGETS(407),    # RFC1459
    :ERR_NOSUCHSERVICE(408),     # RFC2812
    :ERR_NOORIGIN(409),          # RFC1459
    :ERR_NORECIPIENT(411),       # RFC1459
    :ERR_NOTEXTTOSEND(412),      # RFC1459
    :ERR_NOTOPLEVEL(413),        # RFC1459
    :ERR_WILDTOPLEVEL(414),      # RFC1459
    :ERR_BADMASK(415),           # RFC2812
    :ERR_UNKNOWNCOMMAND(421),    # RFC1459
    :ERR_NOMOTD(422),            # RFC1459
    :ERR_NOADMININFO(423),       # RFC1459
    :ERR_FILEERROR(424),         # RFC1459
    :ERR_NOOPERMOTD(425),        # Unreal
    :ERR_TOOMANYAWAY(429),       # Bahamut
    :ERR_EVENTNICKCHANGE(430),   # AustHex
    :ERR_NONICKNAMEGIVEN(431),   # RFC1459
    :ERR_ERRONEUSNICKNAME(432),  # RFC1459
    :ERR_NICKNAMEINUSE(433),     # RFC1459
    :ERR_NICKCOLLISION(436),     # RFC1459
    :ERR_TARGETTOOFAST(439),     # ircu
    :ERR_SERCVICESDOWN(440),     # Bahamut, Unreal
    :ERR_USERNOTINCHANNEL(441),  # RFC1459
    :ERR_NOTONCHANNEL(442),      # RFC1459
    :ERR_USERONCHANNEL(443),     # RFC1459
    :ERR_NOLOGIN(444),           # RFC1459
    :ERR_SUMMONDISABLED(445),    # RFC1459
    :ERR_USERSDISABLED(446),     # RFC1459
    :ERR_NONICKCHANGE(447),      # Unreal
    :ERR_NOTIMPLEMENTED(449),    # Undernet
    :ERR_NOTREGISTERED(451),     # RFC1459
    :ERR_HOSTILENAME(455),       # Unreal
    :ERR_NOHIDING(459),          # Unreal
    :ERR_NOTFORHALFOPS(460),     # Unreal
    :ERR_NEEDMOREPARAMS(461),    # RFC1459
    :ERR_ALREADYREGISTRED(462),  # RFC1459
    :ERR_NOPERMFORHOST(463),     # RFC1459
    :ERR_PASSWDMISMATCH(464),    # RFC1459
    :ERR_YOUREBANNEDCREEP(465),  # RFC1459
    :ERR_YOUWILLBEBANNED(466),   # RFC1459
    :ERR_KEYSET(467),            # RFC1459
    :ERR_LINKSET(469),           # Unreal
    :ERR_CHANNELISFULL(471),     # RFC1459
    :ERR_UNKNOWNMODE(472),       # RFC1459
    :ERR_INVITEONLYCHAN(473),    # RFC1459
    :ERR_BANNEDFROMCHAN(474),    # RFC1459
    :ERR_BADCHANNELKEY(475),     # RFC1459
    :ERR_BADCHANMASK(476),       # RFC2812
    :ERR_NOCHANMODES(477),       # RFC2812
    :ERR_BANLISTFULL(478),       # RFC2812
    :ERR_NOPRIVILEGES(481),      # RFC1459
    :ERR_CHANOPRIVSNEEDED(482),  # RFC1459
    :ERR_CANTKILLSERVER(483),    # RFC1459
    :ERR_RESTRICTED(484),        # RFC2812
    :ERR_UNIQOPPRIVSNEEDED(485), # RFC2812
    :ERR_TSLESSCHAN(488),        # IRCnet
    :ERR_NOOPERHOST(491),        # RFC1459
    :ERR_NOSERVICEHOST(492),     # RFC1459
    :ERR_NOFEATURE(493),         # ircu
    :ERR_BADFEATURE(494),        # ircu
    :ERR_BADLOGTYPE(495),        # ircu
    :ERR_BADLOGSYS(496),         # ircu
    :ERR_BADLOGVALUE(497),       # ircu
    :ERR_ISOPERLCHAN(498),       # ircu
    :ERR_UMODEUNKNOWNFLAG(501),  # RFC1459
    :ERR_USERSDONTMATCH(502),    # RFC1459
    :ERR_GHOSTEDCLIENT(503)      # Hybrid
);

our %NUMERIC2NAME;

for %NAME2NUMERIC.kv -> $key, $val {
    %NUMERIC2NAME<$val> = $key;
}

sub numeric_to_name($code) is export {
    return %NUMERIC2NAME<$code>;
}

sub name_to_numeric($name) is export {
    return %NAME2NUMERIC<$name>;
}

sub uc_irc(Str $value, Str $type = 'rfc1459') is export {
    return if !$value.defined;

    $type.=lc;

    if $type ~~ 'ascii' {
        $value.=trans('a..z' => 'A..Z');
    }
    elsif $type ~~ 'strict-rfc1459' {
        $value.=trans('a..z{}|' => 'A..Z[]\\');
    }
    else {
        $value.=trans('a..z{}|^' => 'A..Z[]\\~');
    }

    return $value;
}

sub lc_irc(Str $value, Str $type = 'rfc1459') is export {
    return if !$value.defined;

    $type.=lc;

    if $type ~~ 'ascii' {
        $value.=trans('A..Z' => 'a..z');
    }
    elsif $type ~~ 'strict-rfc1459' {
        $value.=trans('A..Z[]\\' => 'a..z{}|');
    }
    else {
        $value.=trans('a..z[]\\~' => 'A..Z{}|^');
    }

    return $value;
}

sub eq_irc(Str $first, Str $second, Str $type) is export {
    return if !$first.defined || !$second.defined;

    return Bool::True if lc_irc($first, $type) ~~ lc_irc($second, $type);
    return;
}

# vim: ft=perl6

