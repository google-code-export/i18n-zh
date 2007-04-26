#!/usr/bin/env python
# -*- coding: ascii -*-

# MPY SVN STATS - Subversion Repository Statistics Generator 
# Copyright (C) 2004 name of Maciej Pietrzak
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

"""
mpy-svn-stats is a simple statistics generator (log analyser) for
Subversion repositories.

It aims to be easy to use, but still provide some interesting information.

It's possible that the profile of the generated stats will promote
rivalisation in the project area.

Usage::

    mpy-svn-stats [-h] [-o dir] <url>

    -h      --help              - print this help message
    -o      --output-dir        - set output directory
    -i      --input             - input log file, no svn is called, - for stdin
            --svn-binary        - use different svn client instead of ``svn''
    <url>                       - repository url

Authors: Maciej Pietrzak, Joanna Chmiel, Marcin Mankiewicz
MPY SVN STATS is licensed under GPL. See http://www.gnu.org/copyleft/gpl.html
for more details.
Project homepage is http://mpy-svn-stats.berlios.de/
You can contact authors by email at mpietrzak@users.berlios.de
"""

__docformat__ = 'restructuredtext'

import sys,os,time
import getopt
import time, datetime
import xml.dom
import locale
import math
import datetime
from cgi import escape
from xml.dom.minidom import parseString


# conditional imports
try:
    import Image, ImageDraw, ImageFont
    _have_pil = True
except:
    _have_pil = False


# constants
week_seconds = 7 * 24 * 60 * 60
month_seconds = 30 * 24 * 60 * 60
year_seconds = 365.25 * 24 * 60 * 60

def main(argv):
    config = Config(argv)
    if config.is_not_good(): return config.usage()
    if config.want_help(): return config.show_help()

    stats = AllStatistics(config)
    stats.configure(config)
    
    print "getting data"
    xmldata = get_data(config)
    print "done"
    
    run_time_start = time.time()
    
    print "parsing data"
    revision_data = RevisionData(config.get_repository_url(), parseString(xmldata))
    print "done"

    print "calculating stats"
    stats.calculate(revision_data)
    print "done"
    
    run_time_end = time.time()
    
    print "writing data"
    stats.write(run_time=(run_time_end - run_time_start)) 
    print "done"

    print "Have %d stats objects, %d of them are wanted." % (
        stats.count_all(),
        stats.count_wanted())

def get_data(config):
    """Get the analysis source data.
    Data source definition is in config variable.
    Data is obtained either by calling external svn
    binary or by reading from standard input.
    TODO: use python bindings to subversion (although
    it does not increase neither functionality nor
    security of script, so this is not critical).
    """
    if config.input_file:
        xml_data = get_data_from_file(config)
    else:
        xml_data = get_data_from_svn_binary(config)
    return xml_data

def get_data_from_file(config):
    """Read XML data (bytes) from file."""
    fname = config.input_file
    if fname == '-':
        f = sys.stdin
    else:
        f = file(fname)
    return f.read()

def get_data_from_svn_binary(config):
    svn_binary = config.get_svn_binary()
    svn_repository = config.get_repository_url()
    assert(svn_binary)
    assert(svn_repository)
    command = '%s -v --xml log %s' % (svn_binary, svn_repository)
    print 'running command: "%s"' % command
    f = os.popen(command)
    return f.read()

def generate_stats(config, data):
    try:
        dom = parseString(data)
    except Exception, x:
        print "failed to parse:\n%s\n" % data
        raise x
    return Stats(config, dom)

def _create_output_dir(dir):
    """Create output dir."""
    if not os.path.isdir(dir):
        os.mkdir(dir)

class Config:
    """This class contains all data about configuration, environment
    and parameters.
    Statistics' may choose to tune their parameters or even disable
    themselves based on this information.
    """

    def __init__(self, argv):
        """Init based on argv from command line.
        """
        self._argv = argv
        self._broken = False
        self._repository = None
        self._want_help = False
        self._error_message = None
        self._svn_binary = 'svn'
        self.input_file = None
        self._output_dir = 'mpy-svn-stats'

        self._enabled_stats = []
        self._disabled_stats = []

        self.have_pil = _have_pil
        if not self.have_pil:
            self._print_warning_about_pil()
        else:
            print "Will generate PIL graphs."

        try:
            optlist, args = getopt.getopt(
                argv[1:],
                'ho:i:e:',
                [
                    'help', 
                    'output-dir=',
                    'input=',
                    'svn-binary=',
                    'enable='
                ])
        except getopt.GetoptError, e:
            self._broken = True
            self._error_message = str(e)
            return None
        #print "optlist: %s" % str(optlist)
        #print "args: %s" % str(args)

        optdict = {}

        for k,v in optlist:
            optdict[k] = v

        if optdict.has_key('-h') or optdict.has_key('--help'):
            self._want_help = True
            return None
        if optdict.has_key('--with-diff-stats'):
            self._stats_to_generate.update('author_by_diff_size')
        
        for key,value in optlist:
            if key == '-o': self._output_dir = value
            elif key == '--output-dir': self._output_dir = value
            elif key == '--svn-binary': self._svn_binary = value
            elif key == '-i' or key == '--input': self.input_file = value

        if self.input_file is None:
            if len(args) != 1:
                self._broken = True
                self._repository = None
                return None

            self._repository = args[0]
        else:
            self._repository = None


        # by default we will generate stats from the beginning to now
        self.start_date = None
        self.end_date = time.time()

    def is_not_good(self):
        return self._broken

    def usage(self):
        if self._error_message is not None: print >>sys.stderr, 'Error: %s' % self._error_message
        print >>sys.stderr, 'Usage: %s [params] <repository-url>' % (self._argv[0])
        print >>sys.stderr, 'Use %s --help to get help.' % (self._argv[0])
        return -1

    def get_repository_url(self):
        return self._repository

    def get_svn_binary(self):
        if self.input_file:
            return None
        else:
            return self._svn_binary

    def get_output_dir(self):
        return self._output_dir

    def want_statistic(self, statistic_type):
        """Test whether statistic of type statistic_type is wanted.
        """
        if self._generate_all: return True
        else: return type in self._stats_to_generate

    def want_help(self):
        return self._want_help

    def show_help(self):
        print __doc__
        return None

    def _print_warning_about_pil(self):
        """Print a warning."""
        print """Python Imagin Library could not be found - graphs are disabled."""


class Statistic:
    """Abstract class for Stats' elements.
    """

    wanted_by_default = True
    requires_graphics = False
    
    def __init__(self, config, name, title):
        assert isinstance(name, basestring), ValueError("name must be a string, now: %s (%s)" % (
            repr(name),
            repr(type(name))))
        assert isinstance(title, basestring), ValueError("title must be a string")
        self._name = name
        self._title = title
        self._writers = {}
        self._wanted_output_modes = []

    def title(self):
        assert(isinstance(self._title, basestring), 'Title of the statistic must be specified!')
        return self._title

    def name(self):
        assert isinstance(self._name, basestring), ValueError('Name must be a string')
        return self._name

    def is_wanted(self, mode=None):
        """Check if particular output mode is wanted (either by default or
        explicitly requested).
        If mode is Node, return True is there is at least one output mode.
        """
        if mode is not None:
            return mode in self._wanted_output_modes
        else:
            return len(self._wanted_output_modes) > 0

    def _want_output_mode(self, name, setting=True):
        if setting:
            if name not in self._wanted_output_modes:
                self._wanted_output_modes.append(name)
        else:
            if name in self._wanted_output_modes:
                self._wanted_output_modes.remove(name)

    def _set_writer(self, mode, writer):
        """Set writer object for mode.
        """
        assert isinstance(mode, str), ValueError("Mode must be a shor string (identifier)")
        assert isinstance(writer, StatisticWriter), ValueError("Writer must be a Writer instance")
        self._writers[mode] = writer

    def configure(self, config):
        self._configure_writers(config)
        if self.requires_graphics and not config.have_pil:
            print "%s requires graphics - disabling." % str(self)
            self._want_output_mode('html', False)
            
    def _configure_writers(self, config):
        for writer in self._writers.values():
            writer.configure(config)

    def write(self, run_time):
        """Write out stats using all wanted modes."""
        for mode in self._wanted_output_modes:
            writer = self._writers[mode]
            writer.write(run_time=run_time)

    def output(self, mode):
        writer = self._writers[mode]
        return writer.output()

    def __str__(self):
        """Return human-readable representation."""
        return "Statistic(title='%(title)s', name='%(name)s')" % {
            'title': self.title(),
            'name': self.name()
        }


class TableStatistic(Statistic):
    """A statistic that is presented as a table.
    """
    def __init__(self, config, name, title):
        Statistic.__init__(self, config, name, title)

        # we want to be printed with TableHTMLWriter by default
        self._set_writer('html', TableHTMLWriter(self))
        self._want_output_mode('html')
    
    def rows(self):
        return self._data

    def show_numbers(self):
        return True

    def show_th(self):
        return True

class GeneralStatistics(Statistic):
    """General (opening) statistics (like first commit, last commit, total commit count etc).
    Outputted by simple text.
    """
    def __init__(self, config):
        """Initialise."""
        Statistic.__init__(self, config, "general_statistics", "General statistics")
        self._set_writer('html', GeneralStatisticsHTMLWriter(self))
        self._want_output_mode('html')

    def configure(self, config):
        pass

    def calculate(self, revision_data):
        self._first_rev_number = revision_data.get_first_revision().get_number()
        self._last_rev_number = revision_data.get_last_revision().get_number()
        self._revision_count = len(revision_data)
        self._repository_url = revision_data.get_repository_url()
        self._first_rev_date = revision_data.get_first_revision().get_date()
        self._last_rev_date = revision_data.get_last_revision().get_date()

    def get_first_rev_number(self):
        return self._first_rev_number

    def get_last_rev_number(self):
        return self._last_rev_number

    def get_revision_count(self):
        return self._revision_count

    def get_repository_url(self):
        return self._repository_url

    def get_first_rev_date(self):
        return self._first_rev_date

    def get_last_rev_date(self):
        return self._last_rev_date
        

class AuthorsByCommits(TableStatistic):
    """Specific statistic - show table author -> commit count sorted
    by commit count.
    """
    def __init__(self, config, start_date=None, end_date=None, id=None, title=None):
        """Generate statistics out of revision data.
        """
        if id is None:
            id = "authors_by_number_od_commits"
            if start_date:
                id += "_fromdate_" + str(int(start_date))
            if end_date:
                id += "_todate_" + str(int(end_date))
        if title is None:
            title = "Authors by total number of commits"
            if start_date:
                title += " from " + str(start_date)
            if end_date:
                title += " to " + str(end_date)
        TableStatistic.__init__(self, config, id, title)
        self.start_date = start_date
        self.end_date = end_date

    def column_names(self):
        return ('Author', 'Total number of commits', 'Percentage of total commit count')

    def configure(self, config):
        """Handle configuration - decide whether we are wanted/or possible to
        be calculated and output.
        """

    def calculate(self, revision_data):
        """Do calculations based on revision data passed as
        parameter (which must be a RevisionData instance).

        This method sets internal _data member.
        Output writer can then get it by calling rows().
        """
        assert isinstance(revision_data, RevisionData), ValueError(
            "Expected RevisionData instance, got %s", repr(revision_data)
        )

        abc = {}

        for rv in revision_data.get_revisions():
            if self.start_date:
                if rv.get_date() < self.start_date:
                    continue
            if self.end_date:
                if rv.get_date() > self.end_date:
                    continue
            author = rv.get_author()
            if not abc.has_key(author): abc[author] = 1
            else: abc[author] += 1

        data = [(a, abc[a]) for a in abc.keys()]
        data.sort(lambda x,y: cmp(y[1], x[1]))

        rows = []

        for k,v in data:
            rows.append([k,
                    str(v),
                    "%.2f%%" % (float(v) * 100.0 / float(len(revision_data)))])
        
        self._data = rows


#class AuthorsByChangedPaths(TableStatistic):
#    """Authors sorted by total number of changed paths.
#    """
#    def __init__(self, config):
#        """Generate statistics out of revision data.
#        """
#        TableStatistic.__init__(self, config, 'authors_number_of_paths', 'Authors by total number of changed paths')
#
#    def configure(self, config):
#        pass
#
#    def calculate(self, revision_data):
#        """Perform calculations."""
#        assert(isinstance(revision_data, RevisionData))
#
#        abp = {}
#        max = 0
#
#        for rv in revision_data.get_revisions():
#            author = rv.get_author()
#            modified_path_count  = len(rv.get_modified_paths())
#            if not abp.has_key(author): abp[author] = modified_path_count
#            else: abp[author] += modified_path_count
#            max += modified_path_count
#
#        data = [(a, abp[a]) for a in abp.keys()]
#        data.sort(lambda x,y: cmp(y[1], x[1]))
#
#        self._data = data
#
#        rows = []
#
#        for k,v in data:
#            percentage = float(v) * 100.0 / float(max)
#            assert percentage >= 0.0
#            assert percentage <= 100.0
#            rows.append([k,
#                str(v),
#                "%.2f%%" % percentage])
#
#        self._data = rows
#
#    def column_names(self):
#        """Return names of collumns."""
#        return ('Author', 'Total number of changed paths', 'Percentage of all changed paths')



class GraphStatistic(Statistic):
    """This stats are presented as a graph.

    This class holds graph abstract data.
    This is allways f(x) -> y graph, so
    there is a dict of (x,y) pairs.

    GraphStatistic does not do any output,
    GraphImageHTMLWriter and possibly others
    translate logical data info image file.
    """

    requires_graphics = True

    _x_axis_is_time = True
    """Default, since most graphs are time based."""
    
    def __init__(self, config, name, title):
        Statistic.__init__(self, config, name, title)
        self._set_writer('html', GraphImageHTMLWriter(self))
        self._want_output_mode('html')

    def keys(self):
        return self._keys

    def __getitem__(self, key):
        return self._data[key]

    def get_x_range(self):
        return (self._min_x, self._max_x)

    def get_y_range(self):
        return (self._min_y, self._max_y)

    def x_labels(self):
        """Return dictionary of labels for
        horizontal axis of graphs.
        Keys should be values that are not
        less than self._min_x and not
        greater than _max_x.
        Values are strings that should
        be attached to axis.

        Default implementation calls labels_for_time_span
        if self._x_axis_is_time is True, which is default.
            """
        if self._x_axis_is_time:
            return labels_for_time_span(
                datetime.datetime.fromtimestamp(self._min_x),
                datetime.datetime.fromtimestamp(self._max_x))
        else:
            return {}


class CommitsByWeekGraphStatistic(GraphStatistic):
    """Graph showing number of commits by week."""

    def __init__(self, config):
        """Initialise."""
        GraphStatistic.__init__(self, config, "commits_by_week_graph", "Number of commits in week")
    
    def calculate(self, revision_data):
        """Calculate statistic."""
        assert len(self._wanted_output_modes) > 0
        
        week_in_seconds = 7 * 24 * 60 * 60 * 1.0
    
        start_of_week = revision_data.get_first_revision().get_date()
        end_of_week = start_of_week + week_in_seconds

        self._min_x = revision_data.get_first_revision().get_date()
        self._max_x = revision_data.get_last_revision().get_date()
        self._min_y = 0
        self._max_y = 0

        values = {}

        while start_of_week < revision_data.get_last_revision().get_date():
            commits = revision_data.get_revisions_by_date(start_of_week, end_of_week)
            y = len(commits)
            fx = float(start_of_week+(end_of_week - start_of_week)/2)
            fy = float(y) * float(end_of_week - start_of_week) / float(week_in_seconds)
            values[fx] = fy

            if y > self._max_y: self._max_y = y

            start_of_week += week_in_seconds
            end_of_week = start_of_week + week_in_seconds
            if end_of_week > revision_data.get_last_revision().get_date():
                end_of_week = revision_data.get_last_revision().get_date()
        
        self.series_names = ['number_of_commits']
        self._values = {}
        self._values['number_of_commits'] = values
        self.colors = {}
        self.colors['number_of_commits'] = (0, 0, 0)
    
    def horizontal_axis_title(self):
        return "Time"
    
    def vertical_axis_title(self):
        return "Number of commits"


#class CommitsByWeekPerUserGraphStatistic(GraphStatistic):
#    """Show how many commits were made by most active
#    users."""
#
#    def __init__(self, config):
#        """Initialise."""
#        self.number_of_users_to_show = 7
#        GraphStatistic.__init__(self, config,
#            "commits_by_week_per_user_graph",
#            "Number of commits in week made by most active users")
#
#    def _get_users(self, revision_data):
#        """Find users to be included in graph."""
#        return revision_data.get_users_sorted_by_commit_count()[:self.number_of_users_to_show]
#
#    def _make_colors(self, users):
#        """Create different colors for each values."""
#        saturation = 1.0
#        brightness = 0.75
#        self.colors = {}
#        n = 0
#        for user in self.series_names:
#            
#            hue = float(n) / float(len(self.series_names))
#            n += 1
#
#            assert hue >= 0.0 and hue <= 1.0
#
#            i = int(hue * 6.0)
#            f = hue * 6.0 - float(i)
#            p = brightness * (1.0 - saturation)
#            q = brightness * (1.0 - saturation * f)
#            t = brightness * (1.0 - saturation * (1.0 - f))
#
#            o = {
#                0: (brightness, t, p),
#                1: (q, brightness, p),
#                2: (p, brightness, t),
#                3: (p, q, brightness),
#                4: (t, p, brightness),
#                5: (brightness, p, q)
#            }
#
#            (r, g, b) = o[i]
#
#            assert r >= 0.0 and r <= 1.0
#            assert g >= 0.0 and g <= 1.0
#            assert b >= 0.0 and b <= 1.0
#            
#            self.colors[user] = (int(r*256.0), int(g*256.0), int(b*256.0))
#    
#    def calculate(self, revision_data):
#        """Calculate statistic."""
#        assert len(self._wanted_output_modes) > 0
#
#        users = self._get_users(revision_data)
#        self.series_names = users
#        self._make_colors(users)
#        
#        week_in_seconds = 7 * 24 * 60 * 60 * 1.0
#    
#        start_of_week = revision_data.get_first_revision().get_date()
#        end_of_week = start_of_week + week_in_seconds
#
#        self._min_x = revision_data.get_first_revision().get_date()
#        self._max_x = revision_data.get_last_revision().get_date()
#        self._min_y = 0
#        self._max_y = 0
#        self._values = {}
#
#        for user in users:
#            self._values[user] = {}
#
#        i = 1
#        while start_of_week < revision_data.get_last_revision().get_date():
#            for user in users:
#                commits = revision_data.get_revisions_by_date(start_of_week, end_of_week)
#                y = len([rv for rv in revision_data.revisions_by_users[user] if (
#                    (rv.get_date() > start_of_week and rv.get_date() < end_of_week))])
#                fx = float(start_of_week+(end_of_week - start_of_week)/2)
#                fy = float(y) * float(end_of_week - start_of_week) / float(week_in_seconds)
#
#                self._values[user][fx] = fy
#
#                if y > self._max_y: self._max_y = y
#
#            start_of_week += week_in_seconds
#            end_of_week = start_of_week + week_in_seconds
#            if end_of_week > revision_data.get_last_revision().get_date():
#                end_of_week = revision_data.get_last_revision().get_date()
#            i += 1
#    
#    def horizontal_axis_title(self):
#        return "Time"
#    
#    def vertical_axis_title(self):
#        return "Number of commits"


class GroupStatistic(Statistic):
    """Statistic class for grouping other statistics.
    Every object of this one can contain more statistics.
    Rendering this type of statistics means rendering
    all children stats, and putting it in one group
    (for example - in web page section).
    """
    def __init__(self, config, name, title):
        """Initialize internal variables. Must be called.
        """
        Statistic.__init__(self, config, name, title)
        self._child_stats = []

    def __getitem__(self, number):
        """Get a child Statistic object."""
        return self._child_stats[number]

    def append(self, statistic):
        """Append given statistic to child list.
        
        Parameters:
            - statistic - must be an instance of Statistic
        """
        assert isinstance(statistic, Statistic), ValueError(
            "Wrong parameter, expected Statistic instance, got %s" % (
                repr(statistic)))

        self._child_stats.append(statistic)

    def children(self): 
        """Get children."""
        return self._child_stats

    def descendants(self):
        d = []
        for child in self.children():
            if isinstance(child, GroupStatistic):
                d += child.descendants()
            else:
                d.append(child)
        return d

    def configure(self, config):
        Statistic.configure(self, config)
        for child in self._child_stats:
            child.configure(config)

    def count_all(self):
        """Return the total number of leaf statistics in the group/tree.
        That is, group statistics are not included.
        """
        total = 0
        for stat in self._child_stats:
            if isinstance(stat, GroupStatistic):
                total += stat.count_all()
            else:
                total += 1
        return total

    def count_wanted(self):
        return len([descendant for descendant in self.descendants() if descendant.is_wanted()])

    def calculate(self, revision_data):
        """Pass data to children."""

        for child in self._child_stats:
            if child.is_wanted():
                child.calculate(revision_data)


class AllStatistics(GroupStatistic):
    """This is a special type of group statistic - it
    is created at startup. It should create
    whole statistics objects tree.
    
    After that, objects are queried whether they
    are to be calculated, and then written
    out using writers.
    """

    def __init__(self, config):
        """This constructor takes no parameters.
        """
        GroupStatistic.__init__(self, config, "mpy_svn_stats", "MPY SVN Statistics")
        self.append(GeneralStatistics(config))
        self.append(CommitsGroup(config))
        self.append(ChangedPathsGroup(config))
        self.append(LogMessageLengthGroup(config))
#        self.append(AuthorsByChangedPaths(config))
#        self.append(AuthorsByCommitLogSize(config))
#        self.append(CommitsByWeekGraphStatistic(config))
        self._set_writer('html', TopLevelGroupStatisticHTMLWriter(self))
        self._want_output_mode('html')


class SimpleFunctionGroup(GroupStatistic):
    """A statistic for measuring one function of revision for each author
    (for example: commit count, changed paths, log message size etc).
    Includes:
     - authors sorted by value for:
       * total repo life
       * last month
       * last 7 days
     - graph for authors
     - graoh for function's value
    """

    class SimpleTable(TableStatistic):
        """Specific statistic - show table author -> commit count sorted
        by commit count.
        """
        def __init__(self, config, parent, start_date=None, end_date=None, subtitle=None):
            id = parent.id + '_simple_table'
            self.parent = parent
            if start_date:
                id += "_fromdate_" + str(int(start_date))
            if end_date:
                id += "_todate_" + str(int(end_date))

            title = 'Table of authors'
            if subtitle:
                title += ': ' + subtitle

            TableStatistic.__init__(self, config, id, title)
            self.start_date = start_date
            self.end_date = end_date

        def column_names(self):
            return ('Author', 'Number', 'Percentage')

        def configure(self, config):
            """Handle configuration - decide whether we are wanted/or possible to
            be calculated and output.
            """
            pass

        def calculate(self, revision_data):
            """Do calculations based on revision data passed as
            parameter (which must be a RevisionData instance).

            This method sets internal _data member.
            Output writer can then get it by calling rows().
            """
            assert isinstance(revision_data, RevisionData), ValueError(
                "Expected RevisionData instance, got %s", repr(revision_data))

            abc = {}

            for rv in revision_data.get_revisions():
                if self.start_date:
                    if rv.get_date() < self.start_date:
                        continue
                if self.end_date:
                    if rv.get_date() > self.end_date:
                        continue
                # revision_function always returns author -> some_value relation (dict)
                values = self.parent.revision_function(rv)
                for (author, value) in values.iteritems():
                    if not abc.has_key(author): abc[author] = value
                    else: abc[author] += value

            data = [(a, abc[a]) for a in abc.keys()]
            data.sort(lambda x,y: cmp(y[1], x[1]))

            total_sum = sum(abc.values())

            rows = []

            for k,v in data:
                percentage = float(v) * 100.0 / float(total_sum)
                assert percentage >= 0.0
                assert percentage <= 100.0
                rows.append([k,
                        str(v),
                        "%.2f%%" % percentage])
            
            self._data = rows
    

    class SimpleMultiAuthorGraphStatistic(GraphStatistic):

        def __init__(self, config, parent):
            """Initialise."""
            self.parent = parent
            self.id = parent.id + '_multi_author_graph'
            self.number_of_users_to_show = 9
            GraphStatistic.__init__(self, config,
                self.id,
                "Graph for most active commiters")

        def _get_users(self, revision_data):
            """Find users to be included in graph."""
            return revision_data.get_users_sorted_by_commit_count()[:self.number_of_users_to_show]

        def _make_colors(self, users):
            """Create different colors for each values."""
            saturation = 1.0
            brightness = 0.75
            self.colors = {}
            n = 0
            for user in self.series_names:
                
                hue = float(n) / float(len(self.series_names))
                n += 1

                assert hue >= 0.0 and hue <= 1.0

                i = int(hue * 6.0)
                f = hue * 6.0 - float(i)
                p = brightness * (1.0 - saturation)
                q = brightness * (1.0 - saturation * f)
                t = brightness * (1.0 - saturation * (1.0 - f))

                o = {
                    0: (brightness, t, p),
                    1: (q, brightness, p),
                    2: (p, brightness, t),
                    3: (p, q, brightness),
                    4: (t, p, brightness),
                    5: (brightness, p, q)
                }

                (r, g, b) = o[i]

                assert r >= 0.0 and r <= 1.0
                assert g >= 0.0 and g <= 1.0
                assert b >= 0.0 and b <= 1.0
                
                self.colors[user] = (int(r*256.0), int(g*256.0), int(b*256.0))
        
        def calculate(self, revision_data):
            """Calculate statistic."""
            assert len(self._wanted_output_modes) > 0

            users = self._get_users(revision_data)
            self.series_names = users
            self._make_colors(users)

            
            week_in_seconds = 7 * 24 * 60 * 60 * 1.0
        
            start_of_week = revision_data.get_first_revision().get_date()
            end_of_week = start_of_week + week_in_seconds

            self._min_x = revision_data.get_first_revision().get_date()
            self._max_x = revision_data.get_last_revision().get_date()
            self._min_y = 0
            self._max_y = 0
            self._values = {}

            for user in users:
                self._values[user] = {}

            i = 1
            while start_of_week < revision_data.get_last_revision().get_date():
                for user in users:
                    fx = float(start_of_week+(end_of_week - start_of_week)/2)
                    this_week_revisions = revision_data.get_revisions_by_date(start_of_week, end_of_week)
                    users_revisions = [revision for revision in this_week_revisions if revision.get_author() == user]

                    y = 0.0

                    for revision in users_revisions:
                        values = self.parent.revision_function(revision)
                        for (author, value) in values.iteritems():
                            assert(author == user)
                            y += value


                    fy = float(y) * float(end_of_week - start_of_week) / float(week_in_seconds)
                    self._values[user][fx] = fy
                    if y > self._max_y: self._max_y = y
                    
                start_of_week += week_in_seconds
                end_of_week = start_of_week + week_in_seconds
                if end_of_week > revision_data.get_last_revision().get_date():
                    end_of_week = revision_data.get_last_revision().get_date()
                i += 1
        
        def horizontal_axis_title(self):
            return "Time"
        
        def vertical_axis_title(self):
            return self.parent.value_description
    
    
    def __init__(self, config, id, name):
        self.id = id
        self.name = name
        self.value_description = name
        GroupStatistic.__init__(self, config, id, name)

        self.append(self.SimpleTable(config, self))
        self.append(self.SimpleTable(config, self,
            config.end_date - month_seconds, config.end_date,
            'Last month'))
        self.append(self.SimpleTable(config, self,
            config.end_date - week_seconds, config.end_date,
            'Last week'))
        self.append(self.SimpleMultiAuthorGraphStatistic(config, self))

        self._set_writer('html', GroupStatisticHTMLWriter(self))
        self._want_output_mode('html')


#class CommitsGroup(GroupStatistic):
#    """This class defines group of statistic that shows authors with
#    their commit counts."""
#
#    def __init__(self, config):
#        """Create group contents."""
#        GroupStatistic.__init__(self, config, "authors_by_commits_group", "Number of commits")
#        self.append(AuthorsByCommits(config))
#        self.append(AuthorsByCommits(config,
#            config.end_date - month_seconds, config.end_date,
#            title='Authors by commits - last month'))
#        self.append(AuthorsByCommits(config,
#            config.end_date - week_seconds, config.end_date,
#            title='Authors by commits - last week'))
#        self.append(CommitsByWeekPerUserGraphStatistic(config))
#        self._set_writer('html', GroupStatisticHTMLWriter(self))
#        self._want_output_mode('html')


class CommitsGroup(SimpleFunctionGroup):
    """This class defines group of statistic that shows authors with
    their commit counts.
    """
    def __init__(self, config):
        SimpleFunctionGroup.__init__(self, config, 'commits_group', 'Number of commits')
    
    def revision_function(self, revision):
        """Return a dictionary of values derived from revision."""
        return {revision.get_author(): 1}


class ChangedPathsGroup(SimpleFunctionGroup):
    """Implementation of SimpleFunctionGroup, gives info about changed paths."""

    def __init__(self, config):
        SimpleFunctionGroup.__init__(self, config, 'changed_paths', 'Number of changed paths')
    
    def revision_function(self, revision):
        return {revision.get_author(): len(revision.get_modified_paths())}


class LogMessageLengthGroup(SimpleFunctionGroup):
    """Log message length."""

    def __init__(self, config):
        SimpleFunctionGroup.__init__(self, config, 'log_message_length_group', 'Log message length')

    def revision_function(self, revision):
        return {
            revision.author: len(revision.log_message)
        }
    

class StatisticWriter:
    """Abstract class for all output generators.
    """
    pass


class HTMLWriter(StatisticWriter):
    """An abstract class for HTML writing."""
    
    def _standard_statistic_header(self):
        """Make all statistic header look the same."""
        r = ''

        h2 = "<h2><a name=\"%s\"></a>%s</h2>\n" % (
            escape(self._statistic.name()),
            escape(self._statistic.title())
        )

        goToTopLink = "<a class=\"topLink\" href=\"#top\">top</a>\n"


        r = "<table class=\"statisticHeader\"><tr><td>%s</td><td class=\"topLink\">%s</td></table>\n\n" % (
            h2, goToTopLink)

        return r

    def _standard_statistic_footer(self):
        """Make all statistic header look the same."""
        return "<hr class=\"statisticDelimiter\"/>"

    def configure(self, config):
        self.is_configured = True


class GroupStatisticHTMLWriter(HTMLWriter):
    """Class for writing group statistics (abstract)."""
    def __init__(self, group_statistic=None):
        self._statistic = group_statistic

    def set_statistic(self, statistic):
        self._statistic = statistic
        

class TopLevelGroupStatisticHTMLWriter(GroupStatisticHTMLWriter):
    """Class for writing one, top level
    GroupStatistic.
    """

    output_mode = 'html'
    
    def __init__(self, statistic=None):
        GroupStatisticHTMLWriter.__init__(self, statistic)

    def configure(self, config):
        """Configure - generally - get the output directory."""
        self._output_dir = config.get_output_dir()

    def write(self, run_time):
        """Write out generated statistics."""
        _create_output_dir(self._output_dir)
        filename = self._output_dir + '/index.html'
        output_file = file(filename, "w")
        output_file.write(
            self._page_head()
            + self._page_body()
            + self._page_foot(run_time=run_time)
        );
        output_file.close()

    def _page_head(self):
        """Return HTML page head."""
        return """\
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
    <head>
        <meta name="Generator" content="mpy-svn-stats v. 0.1"/>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>mpy-svn-stats</title>
        <style type="text/css">
            body, td, li {
                font-size: 12px;
            }
        
            table.statistic {
                width: 80%;
                float: center;
            }

            table.statistic tr td {
                border-style: solid;
                border-width: 1px;
                border-color: black;
                text-align: center;
            }

            table.statistic tr th {
                border-style: solid;
                border-width: 2px;
                border-color: black;
                background-color: lightgray;
            }

            p.foot {
                font-size: 75%;
                text-align: center;
            }

            h1,h2,th,caption {
                font-family: Arial;
            }

            h1,h2 {
                text-align: center;
                background-color: lightgray;
                font-style: italic;
            }

            table.statisticHeader {
                margin-left: 0;
                margin-right: 0;
                clear: both;
                width: 100%;
            }

            table.statisticHeader td {
                background-color: lightgray;
                border-spacing: 0px;
                margin: 0px;
                padding: 0px;
            }

            table.statisticHeader tr td.topLink {
                text-align: center;
                width: 3em;
            }

            table.statisticHeader td h2 {
                margin-top: 1px;
                margin-bottom: 1px;
            }

            td.menu_column {
                padding-left: 1em;
                padding-right: 1em;
                vertical-align: top;
            }

            td.statistics_column {
                vertical-align: top;
            }

            .topLink a:link, .topLink a:active, .topLink a:visited {
                color: black;
            }

            .topLink a:hover {
                color: black;
            }

            a.menuLink:link, a.menuLink:active, a.menuLink:visited {
                color: blue;
            }

            hr.statisticDelimiter {
                border-spacing: 0px;
                border-width: 2px 0px 0px 0px;
                border-style: solid;
                margin-bottom: 40pt;
                border-color: lightgray;
            }

            table.legend tr {
            }

            table.legend td.name {
                border-width: 1px 0px 1px 1px;
                border-style: solid;
                border-color: black;
                padding: 0.2em 1em;
            }

            table.legend td.color {
                border-width: 1px 1px 1px 0px;
                border-style: solid;
                border-color: black;
                width: 4em;
            }

            ul.menu {
                padding-left: 0px;
            }
            
        </style>
    </head>
    <body>
        <h1><a name="top"></a>mpy-svn-stats</h1>
    """

    def _page_foot(self, run_time):
        """Return HTML page foot."""
        return """
        <hr/>
        <p class="foot">
        Stats generated by <a href="http://mpy-svn-stats.berlios.de">mpy-svn-stats</a> in %(run_time).2f seconds.
        </body></html>
        """ % {
            'run_time': run_time
        }

    def _page_body(self):
        return "<table><tr><td class=\"menu_column\">%(menu_column)s</td><td>%(body_column)s</td></tr></table>" % {
            'menu_column': self._page_menu(),
            'body_column': self._page_main()
            }

    def _page_menu(self):
        return "<ul class=\"menu\">" + self._recursive_menu(self._statistic) + "</ul>\n"

    def _recursive_menu(self, statistic):
        """Return statistic as li tag.
        """

        if not statistic.is_wanted(self.output_mode):
            return ''

        r = ""
        if isinstance(statistic, GroupStatistic):

            # count wanted children
            wanted_children = len([child for child in statistic.children() if child.is_wanted(self.output_mode)])
            if wanted_children == 0:
                return ''

            r += "<li>%s:\n<ul>\n" % statistic.title()
            for child in statistic.children():
                r += self._recursive_menu(child)

            r += "</ul>\n</li>\n"
        else:
            r += "<li><a class=\"menuLink\" href=\"#%s\">%s</a></li>\n" % (
                statistic.name(),
                statistic.title())
        return r

    def _page_main(self):
        flat = [] 
        stack = [self._statistic]

        while len(stack) > 0:
            stat = stack.pop()
            if not isinstance(stat, GroupStatistic):
                flat.append(stat)
            else:
                children = stat.children()
                children.reverse()
                stack.extend(children)

        r = ''

        for stat in flat:
            if stat.is_wanted('html'):
                r += stat.output('html')

        return r


class TableHTMLWriter(HTMLWriter):
    """Output table."""

    def __init__(self, stat):
        assert isinstance(stat, TableStatistic), ValueError()
        self._statistic = stat

    def output(self):
        r = '\n'
        r += self._standard_statistic_header()
        r += "<table class=\"statistic\">\n%s\n%s\n</table>\n\n" % (
            self._table_header(),
            self._table_body())
        r += self._standard_statistic_footer()
        return r

    def _table_header(self):
        r = "<tr>\n"
        r += "  <th>No</th>\n"
        for column_name in self._statistic.column_names():
            r += "  <th>" + escape(column_name) + "</th>\n"
        r += "</tr>\n"
        return r
        

    def _table_body(self):
        r = ''
        i = 1
        for row in self._statistic.rows():
            r += "<tr>\n"
            r += "  <td>%d</td>\n" % i
            for cell in row:
                r += "  <td>" + escape(cell) + "</td>\n"
            i += 1
            r += "</tr>\n"
        return r


class GeneralStatisticsHTMLWriter(HTMLWriter):
    """Specialised GeneralStatistics HTML Writer class."""

    def __init__(self, stat):
        self._statistic = stat

    def output(self):
        statistic = self._statistic
        return """
            <h2><a name=\"%(statistic_name)s\"></a>%(statistic_title)s</h2>

            <p>
                Statistics for repository at: <b>%(repository_url)s</b>.<br/>
                Smallest revision number: %(first_rev_number)s.<br/>
                Biggest revision number: %(last_rev_number)s.<br/>
                Revision count: %(revision_count)s.<br/>
                First revision date: %(first_rev_date)s.<br/>
                Last revision date: %(last_rev_date)s.<br/>
                Age of the repository (from first to last revision): %(age_of_repository)s.<br/>
                Commits per year: %(commits_per_year)s.<br/>
                Commits per month: %(commits_per_month)s.<br/>
                Commits per day: %(commits_per_day)s.
            </p>
        """ % {
            'repository_url': escape(statistic.get_repository_url()),
            'statistic_name': escape(statistic.name()),
            'statistic_title': escape(statistic.title()),
            'revision_count': str(statistic.get_revision_count()),
            'first_rev_number': str(statistic.get_first_rev_number()),
            'last_rev_number': str(statistic.get_last_rev_number()),
            'first_rev_date': time.strftime('%c', time.gmtime(statistic.get_first_rev_date())),
            'last_rev_date': time.strftime('%c', time.gmtime(statistic.get_last_rev_date())),
            'age_of_repository': self._format_time_span(
                                            statistic.get_first_rev_date(),
                                            statistic.get_last_rev_date()
                                        ),
            'commits_per_year': ("%.2f" % (statistic.get_revision_count() * 365.25 * 24 * 60 * 60
                    / (statistic.get_last_rev_date() - statistic.get_first_rev_date()))
                ),
            'commits_per_month': ("%.2f" % (statistic.get_revision_count() * 30 * 24 * 60 * 60
                    / (statistic.get_last_rev_date() - statistic.get_first_rev_date()))
                ),
            'commits_per_day': ("%.2f" % (statistic.get_revision_count() * 24 * 60 * 60
                    / (statistic.get_last_rev_date() - statistic.get_first_rev_date()))
                ),
        }

    def _format_time_span(self, from_time, to_time):
        """Format time span as a string."""
        seconds = to_time - from_time
        reminder = seconds
        s = ''

        steps = [
            ('years', 365.25 * 24 * 60 * 60),
            ('months', 30 * 24 * 60 * 60),
            ('days', 24 * 60 * 60),
            ('hours', 60 * 60),
            ('minutes', 60),
        ]

        have_nonzero_step = False

        for step in steps:
            n = reminder / step[1]
            if int(n) > 0:
                have_nonzero_step = True
                reminder -= int(n) * step[1]
                s += '%d %s' % (int(n), step[0])
                if have_nonzero_step:
                    if step is steps[len(steps)-1]:
                        s += ' and '
                    else:
                        s += ' '

        s += '%d seconds' % int(reminder)
        
        return s

    
class GraphImageHTMLWriter(HTMLWriter):
    """A class that writes graphs to image files.
    Basically, a GraphStatistic contains data that
    makes it possible to draw a graph.
    That is: axis max, axis min, axis label,
    argument -> value pairs that define function.
    Also it may contain type in future releases.

    Fields include:
     - _statistic - parent statistic (the one data
       comes from)
    """

    def __init__(self, statistic):
        """Initialise instance. Name will be used for
        image filename."""
        assert isinstance(statistic, GraphStatistic)
        self._statistic = statistic
        self.font = ImageFont.load_default()

    def configure(self, config):
        """Configure Graph Image HTML Writer."""
        self._image_width = 600
        self._image_height = 400
        self._margin_bottom = 125
        self._margin_top = 20
        self._margin_left = 50
        self._margin_right = 20
        self._image_dir = config.get_output_dir()

    def get_image_fname(self):
        return self._image_dir + '/' + self._statistic.name() + '.png'

    def get_image_html_src(self):
        return self._statistic.name() + '.png'

    def _write_image(self):
        """Write image files."""
        image_size = (self._image_width, self._image_height)
        im = Image.new("RGB", image_size, 'white')
        draw = ImageDraw.Draw(im)

        self._draw_axes(im, draw)
        self._draw_axes_labels(im, draw)
        self._paint_content(im, draw)

        del draw
        self._save(im)

    def _save(self, im):
        im.save(self.get_image_fname())

    def _paint_content(self, im, draw):
        for k,values in self._statistic._values.iteritems():
            keys = values.keys()
            keys.sort()
            color = self._statistic.colors[k]

            last_pair = (None, None)
            for key in keys:
                value = values[key]
                last_pair = self._plot(draw, last_pair, (key, value), color)

    def _plot(self, draw, from_tuple, to_tuple, color='black'):
        if from_tuple != (None, None):
            (imx1, imy1) = self._graph_to_image(from_tuple)
            (imx2, imy2) = self._graph_to_image(to_tuple)
            draw.line((imx1, imy1, imx2, imy2), color)
        return to_tuple

    def _graph_to_image(self, point):
        """Convert position from
        theoretical (data) coordinates to
        image coordinates.
        Points are tuples of doubles.
        TODO: rewrite, it's too long.
        """
        gx = float(point[0])
        gy = float(point[1])
        point = (gx, gy)

        assert gx >= self._statistic._min_x
        assert gx <= self._statistic._max_x, AssertionError("bad gx: %f (should be smaller than %f)" % (gx, self._statistic._max_x))
        assert gy >= self._statistic._min_y
        assert gy <= self._statistic._max_y

        margin_left = self._margin_left
        margin_right = self._margin_right
        margin_top = self._margin_top
        margin_bottom = self._margin_bottom

        image_width = self._image_width
        image_height = self._image_height

        range_x = float(self._statistic._max_x - self._statistic._min_x)
        range_y = float(self._statistic._max_y - self._statistic._min_y)

        assert range_x >= 0
        assert range_y >= 0

        min_x = float(self._statistic._min_x)
        min_y = float(self._statistic._min_y)

        x = margin_left + (gx - min_x) * (image_width - margin_left - margin_right) / range_x

        pcy = (gy - min_y) / range_y
        graph_height = image_height - margin_top - margin_bottom
        pxy = pcy * graph_height
        y = margin_top + graph_height - pxy

        return (x, y)

    def _draw_axes(self, image, draw):
        self._draw_horizontal_axis(image, draw)
        self._draw_vertical_axis(image, draw)
        self._draw_horizontal_axis_title(image, draw)
        self._draw_vertical_axis_title(image, draw)


    def _draw_horizontal_axis(self, image, draw):
        start_x = self._margin_left
        start_y = self._image_height - self._margin_bottom
        end_x = self._image_width - self._margin_right
        end_y = start_y

        length = self._image_width - self._margin_left - self._margin_right

        draw.line((start_x, start_y, end_x, end_y), '#999')
        draw.line((end_x, end_y, end_x - 5, end_y - 3), '#999')
        draw.line((end_x, end_y, end_x - 5, end_y + 3), '#999')

    def _draw_vertical_axis(self, image, draw):
        start_x = self._margin_left
        start_y = self._image_height - self._margin_bottom
        end_x = start_x
        end_y = self._margin_top

        draw.line((start_x, start_y, end_x, end_y), '#999')
        draw.line((end_x, end_y, end_x + 3, end_y + 5), '#999')
        draw.line((end_x, end_y, end_x - 3, end_y + 5), '#999')

    def _draw_horizontal_axis_title(self, image, draw):
        text = self._statistic.horizontal_axis_title()
        (text_width, text_height) = draw.textsize(text, font=self.font)

        corner_x = self._image_width - self._margin_right
        corner_y = self._image_height - self._margin_bottom

        pos_x = corner_x - text_width
        pos_y = corner_y - 15
        
        draw.text((pos_x, pos_y), text, fill='black', font=self.font)

    def _draw_vertical_axis_title(self, image, draw):
        text_im_width = 300
        text_im_height = 200

        textim = Image.new('RGBA',
            (text_im_width, text_im_height), 'white')
        textdraw = ImageDraw.Draw(textim)
    
        text = self._statistic.vertical_axis_title()
        (text_width, text_height) = textdraw.textsize(text, font=self.font)

        textdraw.text((0,0), text, fill='black', font=self.font)

        del textdraw

        textim = textim.crop((0, 0, text_width, text_height))
        textim = textim.rotate(90)

        corner_x = self._margin_left
        corner_y = self._margin_top

        pos_x = corner_x - text_height - 10
        pos_y = corner_y + 10

        image.paste(textim,
            (
                pos_x, pos_y, 
                pos_x + text_height,
                pos_y + text_width
            )
        )
        
        del textim

    def _draw_axes_labels(self, image, draw):
        labels = self._statistic.x_labels()
        if len(labels) == 0: return
        #print "%s: have %d labels" % (self, len(labels))
        for label_datetime, label in labels.iteritems():
            label_position = time.mktime(label_datetime.timetuple())
            label_text = label.text
            position = self._graph_to_image( (label_position, 0) )
            
            #print " putting '%s' at %s" % (label_text, position)
            self._draw_text(image, draw, (position[0], position[1] + 4), label_text,
                angle=90)
            draw.line(
                (int(position[0]), int(position[1] - 4), int(position[0]), int(position[1] + 2)),
                'black')

    def _draw_text(self, im, draw, position, text, fill='black', angle=0):
        """Create rotated text. This must be done
        by creating temp image, drawing text on it,
        rotating it and then copying it to the original
        image.
        """
        textsize = draw.textsize(text)
        tim = Image.new('RGBA', textsize, (0,0,0,0))
        tdraw = ImageDraw.Draw(tim)

        tdraw.text( (0,0), text, fill=fill, font=self.font)
        del tdraw

        tim = tim.rotate(-90)

        #print position
        im.paste(tim, (int(position[0] - textsize[1] / 2), int(position[1])), tim)

        del tim
        
    def output(self):
        """Outputting."""
        r = ''
        self._write_image()

        r += self._standard_statistic_header()
        r += """
            <p>
                <img border="1" src="%(image_src)s"/>
            </p>
        """ % {
            'image_src': self.get_image_html_src()
        }

        if len(self._statistic.colors.keys()) > 1:
            r += self._legend()
        
        r += self._standard_statistic_footer()

        return r

    def _legend(self):
        o = ''
        i = 0
        cols = 3
        colors = self._statistic.colors
        names = self._statistic.series_names

        o += "<table class=\"legend\">\n"

        while True:
            o += "  <tr>\n"
            for col_num in range(0, cols):

                if i < len(colors.keys()):
                    
                    name = names[i]
                    (r,g,b) = colors[name]


                    color = '#%s%s%s' % (
                        hex(r)[2:].zfill(2),
                        hex(g)[2:].zfill(2),
                        hex(b)[2:].zfill(2))
                
                    o += "    <td class=\"name\">%s</td>\n<td class=\"color\" style=\"background-color: %s\">&nbsp;</td>\n" % (
                        name,
                        color)

                else:
                    o += "    <td></td>\n<td>\n</td>"

                i += 1

            o += "  </tr>\n"

            if i >= len(colors.keys()):
                break
            
        o += "</table>"
        return o
            

class RevisionData:
    """Data about all revisions."""
    def __init__(self, url, dom):
        """Create revision data from xml.dom.Document."""

        self._repository_url = url

        log = dom.childNodes[0]
        revisions = []

        for logentry in log.childNodes:
            if logentry.nodeType != logentry.ELEMENT_NODE: continue
            if logentry.nodeType == logentry.ELEMENT_NODE and logentry.nodeName != 'logentry':
                raise '%s found, logentry expected' % str(logentry)

            revisions.append(RevisionInfo(logentry))
        self._revisions = revisions
        self._revisions_by_keys = {}
        for rv in self._revisions:
            self._revisions_by_keys[rv.get_revision_number()] = rv

        self._revisions.sort(lambda r1,r2: cmp(r1.get_revision_number(), r2.get_revision_number()))

        self._generate_user_data()

    def _generate_user_data(self):
        self.users = []
        self.revisions_by_users = {}

        for rv in self._revisions:
            user = rv.get_author()
            if not user in self.users:
                self.users.append(user)
                self.revisions_by_users[user] = []
            self.revisions_by_users[user].append(rv)

        self.users_sorted_by_revision_count = self.users
        self.users_sorted_by_revision_count.sort(lambda u1, u2: cmp(len(self.revisions_by_users[u2]), len(self.revisions_by_users[u1])))

    def get_users_sorted_by_commit_count(self):
        return self.users_sorted_by_revision_count

    def get_revision(self, number):
        return self._revisions_by_keys[number]

    def get_first_revision(self):
        return self._revisions[0]

    def get_last_revision(self):
        return self._revisions[len(self._revisions)-1]

    def get_repository_url(self):
        if self._repository_url:
            return self._repository_url
        else:
            return "unknown"

    def __len__(self):
        return len(self._revisions)

    def __getitem__(self, index):
        return self._revisions_by_keys(index)

    def keys(self):
        return self._revisions_keys

    def get_revisions(self):
        return self._revisions

    def values(self):
        return self.get_revisions()

    def get_revisions_by_date(self, start_date, end_date):
        revisions = []
        for rv in self.get_revisions():
            if start_date <= rv.get_date() < end_date:
                revisions.append(rv)
        return revisions
                

class RevisionInfo:
    """All known data about single revision."""
    def __init__(self, message): 
        self._modified_paths = []
        self._parse_message(message)
        self._have_diffs = False
        self._diffs = []

    def get_author(self):
        return self.author

    def get_revision_number(self):
        return self._revision_number

    def get_number(self):
        """Same as get_revision_number."""
        return self._revision_number

    def get_modified_paths(self):
        return self._modified_paths
    
    def get_date(self):
        return self._date

    def _parse_message(self, message):
        assert(isinstance(message, xml.dom.Node))
        self.author = self._parse_author(message)
        self._revision_number = self._parse_revision_number(message)
        self._modified_paths = self._parse_paths(message)
        self._date = self._parse_date(message)
        self.log_message = self._parse_commit_log_message(message)

    def _parse_author(self, message):
        """Get author out of logentry.
        Suprisingly, not all logentries have authors.
        In that case, author is set to '' (empty string).
        cvs2svn does that.
        """
        a = message.getElementsByTagName('author')
        assert len(a) <= 1, AssertionError(
                'There should be at most one author in revision.\nXML is:\n%s' % (
                    message.toprettyxml())
                )
        if len(a) == 1:
            a[0].normalize()
            assert(len(a[0].childNodes) == 1)
            return a[0].childNodes[0].data
        else:
            return ''

    def _parse_commit_log_message(self, message):
        l = message.getElementsByTagName('msg')
        l[0].normalize()
        try:
            return l[0].childNodes[0].data
        except:
            return ''

    def _parse_revision_number(self, message):
        return int(message.getAttribute('revision'))

    def _parse_paths(self, message):
        path_nodes = message.getElementsByTagName('path')
        modified_paths = []
        for path_node in path_nodes:
            path_node.normalize()
            action = path_node.getAttribute('action')
            path = self._get_element_contents(path_node)
            modified_paths.append(ModifiedPath(action, path))
        return modified_paths

    def _parse_date(self, message):
        date_element = message.getElementsByTagName('date')[0]
        isodate = self._get_element_contents(date_element)
        return time.mktime(time.strptime(isodate[:19], '%Y-%m-%dT%H:%M:%S'))

    def _get_element_contents(self, node):
        assert(isinstance(node, xml.dom.Node))
        children = node.childNodes
        contents = ''
        for child in children:
            if child.nodeType == child.TEXT_NODE:
                contents += child.data
        return contents

    def get_revision_number(self):
        return self._revision_number


class ModifiedPath:
    def __init__(self, action, path):
        assert(isinstance(action, str) and len(action) == 1,
            'should be one-letter string, is: %s' % str(action))
        assert(isinstance(path, basestring), 'should be modified path, is: %s' % path)
        self._action = action
        self._path = path

    def get_action(self):
        return self._action

    def get_path(self):
        return self._path


#class AuthorsByCommitLogSize(TableStatistic):
#    """Specific statistic - show table author -> commit log, sorted
#    by commit log size.
#    """
#    def __init__(self, config):
#        """Generate statistics out of revision data.
#        """
#        TableStatistic.__init__(self, config, 'authors_by_log_size', """Authors by total size of commit log messages""")
#
#    def configure(self, config):
#        """Handle configuration."""
#        pass
#
#    def column_names(self):
#        return ('Author',
#            'Total numer od characters in all log messages',
#            'Percentage of all log messages')
#
#    def calculate(self, revision_data):
#        """Do calculations."""
#        assert(isinstance(revision_data, RevisionData))
#
#        abc = {}
#        sum = 0
#        
#        for rv in revision_data.get_revisions():
#            author = rv.get_author()
#            log = rv.get_commit_log()
#            size = len(log)
#            if not abc.has_key(author): abc[author] = size
#            else: abc[author] += size
#            sum += size
#
#        data = [(a, abc[a]) for a in abc.keys()]
#        data.sort(lambda x,y: cmp(y[1], x[1]))
#
#        rows = []
#
#        for k,v in data:
#            rows.append([k,
#                str(v),
#                "%2.2f%%" % (float(v) * 100.0 / float(sum))])
#
#        self._data = rows


#class AuthorsByDiffSize(TableStatistic):
#    """Specific statistic - shows table author -> diffs size, sorted by
#    size
#    """
#
#    wanted_by_default = False
#    
#    def __init__(self, config, revision_data):
#        """Generate statistics out of revision data and `svn diff`.
#        """
#        TableStatistic.__init__(self, 'author_by_diff_size', 'Authors by total size of diffs')
#        assert(isinstance(revision_data, RevisionData))
#
#        abc = {}
#
#        for rv in revision_data.get_revisions():
#            author = rv.get_author()
#            rev_number = rv.get_revision_number()
#            command = "%s -r %d:%d diff %s" % (config.get_svn_binary(),
#                rev_number-1, rev_number,
#                config.get_repository_url())
#            f = os.popen(command)
#            result = f.read()
#            f.close()
#            if not abc.has_key(author): 
#                abc[author] = (len(result), len(result.split()))
#            else:
#                abc[author] = (abc[author][0] + len(result), abc[author][1] + len(result.split()))
#
#        data = [(a, abc[a][0], abc[a][1]) for a in abc.keys()]
#        data.sort(lambda x,y: cmp(y[1], x[1]))
#
#        self._data = data
#
#    def column_names(self):
#        return ('Author', 'Size of diffs', 'Number of lines in diffs')


labels_for_time_span_cache = {}

def labels_for_time_span(start_time, end_time, max_labels=20):

    if labels_for_time_span_cache.has_key((start_time, end_time, max_labels)):
        return labels_for_time_span_cache[(start_time, end_time, max_labels)]

    labels = {}
    for unit in RoundedTimeIterator.units:

        units_labels = {}
        for t in RoundedTimeIterator(start_time, end_time, unit):
            units_labels[t] = GraphTimeLabel(t, unit)

        labels_candidate = {}
        labels_candidate.update(units_labels)
        labels_candidate.update(labels)

        if len(labels_candidate) > max_labels:
            break
        else:
            labels = labels_candidate

    labels_for_time_span_cache[(start_time, end_time, max_labels)] = labels
    return labels

class GraphTimeLabel(object):
    """Handle graph's time labels.
    Used as a value in labels dict.
    Actually, created to have "weight" or
    "importance" attached to label - so
    we can draw bigger strokes with years,
    and smaller with days.
    """
    def __init__(self, label_datetime, unit, weight=None):
    	"""Initialise instance.
	Weight means "importance" of the label, for example
	year is more important than month and gets bigger
	"stroke" or "tick" on graphs axis.

	If weight is not specified as parameter it is taken from
	units index from RoundedTimeIterator.
	"""
        self.datetime = label_datetime
        tt = label_datetime.timetuple()

        if tt[3] == 0 and tt[4] == 0 and tt[5] == 0:
            # only y-m-d
            self.text = '%04d-%02d-%02d' % (tt[0], tt[1], tt[2])
        else:
            # full
            self.text = '%04d-%02d-%02d %02d:%02d:%02d' % tuple(tt[0:6])

        if weight:
            self.weight = weight
        else:
            self.weight = list(RoundedTimeIterator.units).index(unit)

        self.unit = unit

    def __str__(self):
        return self.text()
    

class RoundedTimeIterator(object):
    """Provide object, that iterates over time period by some fuzzy "round"
    time intervals like months, weeks etc.

    TODO: Write doctest or unit test for this to define behaviour strictly.
    Then, rewrite again. Problem with this is that I'm not sure what results it
    should give in first place.
    """

    _unit_settings = {
        'decade': (10, 0),
        'fiveyears': (5, 0),
        'twoyears': (2, 0),
        'year': (1, 0),
        'sixmonths': (6, 1),
        'quarter': (3, 1),
        'month': (1, 1),
        'day': (1, 2),
        'hour': (1, 3),
        'minute': (1, 4),
        'second': (1, 5),
    }

    
    units = (
        'decade',
        'fiveyears',
        'twoyears',
        'year',
        'sixmonths',
        'quarter',
        'month',
        'day',
        'hour',
        'minute',
        'second'
    )

    def __init__(self, start_datetime, end_datetime, unit):
        """Create object.
        unit is a string - name of unit.
        start_datetime and end_datetime are datetime.datetime objects.
        """
        if unit not in self.units:
            raise Exception('illegal unit value: %s' % repr(unit))
        assert isinstance(start_datetime, datetime.datetime)
        assert isinstance(end_datetime, datetime.datetime)
        self.unit = unit
        self.start_datetime = start_datetime
        self.end_datetime = end_datetime
        self.first = True
        self.current_datetime = start_datetime
        

    def _find_next(self, current_datetime):
        return self._increase_date(self._reset_date(current_datetime))

    def _increase_date(self, date):
        tl = list(date.timetuple())
        ch = self._unit_settings[self.unit]
        tl[ch[1]] += ch[0]
        nts = time.mktime(tuple(tl))
        return datetime.datetime.fromtimestamp(nts, date.tzinfo)

    def _reset_date(self, date):
        tl = list(date.timetuple())
        ch = self._unit_settings[self.unit]
        default_values = (0, 1, 1, 0, 0, 0)
        for i in range(ch[1] + 1, len(default_values)):
            tl[i] = default_values[i]
        
        return datetime.datetime.fromtimestamp(
            time.mktime(tuple(tl)), date.tzinfo)
    
    def next(self):
    	"""Please don't read this ;)
        """
        if self.first and self.current_datetime == self._reset_date(self.current_datetime):
            # dont increase
            pass
        else:
            self.current_datetime = self._find_next(self.current_datetime)

        self.first = False
        
        if self.current_datetime >= self.start_datetime and self.current_datetime < self.end_datetime:
            return self.current_datetime
        else:
            raise StopIteration()
    
    def __iter__(self):
        return self

if __name__ == '__main__':
    locale.setlocale(locale.LC_ALL)
    main(sys.argv) 

