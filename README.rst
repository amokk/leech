
WHAT'S THIS
-----------

It will download torrent files for you if you give it RSS-feeds of your favorite trackers.

How it works::

    RSS -> leech -> torrent files -> directory ------+
                                                     |
    downloaded files <- torrent client <- watchdog <-+

Torrent clients supporting watching over directory:

* transmission
* rtorrent

leech is implemented in sh + curl + xsltproc + grep + sed + curl again. For periodic checks you might want to use cron. E.g.::

    # crontab -l
    */30 * * * * CONFIG_DIR=/etc/leech DOWNLOADS_DIR=/mnt/usb/store/schedule /usr/sbin/leech

Will run leech every 30 minutes, checking feeds and downloading all matched torrent files.


WHY IT'S GOOD
-------------

* No long-running processes - no long-running memory consumption on your NAS.
* No Python/Perl/PHP/Java/Whatever required.
* Still does the job.


USAGE
-----

    ``CONFIG_DIR="/etc/leech" DOWLOADS_DIR="/mnt/downloads/schedule" leech``

leech will download RSS-feeds specified in ``/etc/leech/foods``,
transform them with xsltproc to text, match against expressions in
``/etc/leech/downloads``, and will run cURL to download matched files
to ``/mnt/downloads/schedule``.

DOWNLOADS_DIR might be omitted to download files to current directory.

You might also want to use ``sbin/leech-match-test`` to test if expressions
in config/downloads match filenames you need.


KNOWN ISSUES
------------

* You need to put empty line at the end of configuration files
* OpenWrt's leech only supports Unicode encodings - see TROUBLESHOOTING_ for workaround
* It only support RFC822_ dates in RSS - see TROUBLESHOOTING_ for workaround

.. _RFC822: http://www.ietf.org/rfc/rfc0822.txt
.. _TROUBLESHOOTING:


WHAT'S INSIDE
-------------

* ``sbin/leech`` - main script
* ``sbin/leech-match-test`` - matching tool
* ``sbin/rfc822tounix`` - RFC 822 to Unix-time convertion utility
* ``config/default`` - main configuration file
* ``config/foods`` - feeds file
* ``config/downloads`` - rules for files downloading
* ``share/leech/leech.xsl`` - XSL transformation (preprocessing stuff)


INSTALL AS USER
---------------

It should work out of the box.

* edit ``config/foods`` and add RSS feeds
* edit ``config/downloads`` and add DL rules

Now you should be able to run ``CONFIG_DIR=config ./leech`` and see it
downloading feeds and files (if any, to current directory).

* `crontab -e` and add cron job as described above, with correct paths to CONFIG_DIR, DOWNLOADS_DIR and correct path to main script.


INSTALL AS SUPERUSER
--------------------

Check "Downloads" section, there should be package(s) you need. In case they're
not there, please email me about this problem (aleksey.tulinov@gmail.com).

Install process does everything you need for normal use (except cron and
downloads configuration). If you want to check if it's running correctly:

* ``leech`` will show you error message and usage information
* ``CONFIG_DIR=/etc/leech leech`` will force leech to run

Configuration files are under /etc/leech.

* edit ``/etc/leech/foods`` and add RSS feeds
* edit ``/etc/leech/downloads`` and add DL rules
* ``crontab -e`` and add cron job as described above.
* (optional) don't forget to enable cron (if it's not): ``/etc/init.d/cron enable`` for OpenWRT


TROUBLESHOOTING
---------------

If you think something is wrong, or just want to make sure if everything is OK,
you could always run leech in manual mode and observe its output. See above, how to do so.

leech prints error about parsing of feeds in some outdated encoding, like cp1251
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Try to re-encode your feed with web-service like http://pipes.yahoo.com. Later will give
you UTF-8 encoded feed. If after that you have any troubles with files (filenames)
downloaded by leech, you might use FORCE_SUFFIX option in ``defaults`` to set filenames
in the predictable pattern.

You might also e-mail webmaster of the feed and kindly remind him current date. Here is
a link_ to United States Naval Observatory Time Service Department page with current time
to prove that 1995 is already over.

.. _link: http://tycho.usno.navy.mil/simpletime.html

leech prints timestamp parsing error
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    ``WARNING: RSS timestamp (2012-07-17 04:34:08) can't be parsed correctly``

Your feed is broken and doesn't follow standard. I don't really want to support
broken feeds, but leech will still work if you set $HISTORY value in ``default``
to value greater than oldest record in broken feed.

For instance, oldest record in feed is two weeks old - set $HISTORY to 15 days.

With $HISTORY set correctly, leech won't download torrents twice. You could also
send webmaster this link to RSS specification_. Hope this helps.

.. _specification: http://cyber.law.harvard.edu/rss/rss.html


UNDER THE HOOD
--------------

Script will create temporary file in $TMP ($DOWNLOADS_DIR by default):
``$TMP/leech.lunch`` - contains downloaded feed.

It will also create ``.leech.db`` with list of already downloaded files in
$PERSISTENCE or in $DOWNLOADS_DIR if $PERSISTENCE is not set (by default). This
file contains MD5 sum of downloaded URLs and time when it happened. DB is
periodically cleared, old (not needed) records are deleted.

Files matched ``config/downloads`` rules goes directly to DOWNLOADS_DIR. In
case of incomplete file retrieval, cURL will resume download.
