#!/usr/bin/perl

use warnings;
use strict;

use open ":std", ":encoding(UTF-8)";

use JSON::Parse 'json_file_to_perl';
use Data::Dumper;

use Getopt::Long;

my $token = "";
GetOptions ("token=s" => \$token) or die "Error in command line args";

# no arg for changes since last release
my $releaseTag = shift @ARGV;

my $tmpDir = "/var/tmp";
my $releasesFile = "$tmpDir/releases-$$.json";
my $doltPullsFile = "$tmpDir/dolt-prs-$$.json";
my $doltIssuesFile = "$tmpDir/dolt-issues-$$.json";
my $gmsPullsFile = "$tmpDir/gms-prs-$$.json";

my $doltReleasesUrl = 'https://api.github.com/repos/dolthub/dolt/releases';
my $curlReleases = "curl -H 'Accept: application/vnd.github.v3+json' '$doltReleasesUrl' > $releasesFile";
print STDERR "$curlReleases\n";
system($curlReleases) and die $!;

my $releasesJson = json_file_to_perl($releasesFile);

my ($fromTime, $fromHash, $toTime, $toHash, $fromTag, $toTag);
foreach my $release (@$releasesJson) {
    $fromTime = $release->{created_at};
    $fromTag = $release->{tag_name};
    last if $toTime;

    if ((! $releaseTag) || ($releaseTag eq $release->{tag_name})) {
        $toTime = $release->{created_at};
        last unless $releaseTag;
    }
}

die "Couldn't find release" unless $toTime;

print STDERR "Looking for PRs and issues from $fromTime to $toTime\n";

my $doltPullRequestsUrl = 'https://api.github.com/repos/dolthub/dolt/pulls?state=closed&per_page=100';
my $mergedDoltPrs = getPRs($doltPullRequestsUrl, $fromTime, $toTime);

my $doltIssuesUrl = "https://api.github.com/repos/dolthub/dolt/issues?state=closed&since=$fromTime&per_page=100";
my $closedIssues = getIssues($doltIssuesUrl, $fromTime, $toTime);

print "# Merged PRs:\n\n";
foreach my $pr (@$mergedDoltPrs) {
    if ($pr->{body}) {
        print "* [$pr->{number}]($pr->{url}): $pr->{title} ($pr->{body})\n";        
    } else {
        print "* [$pr->{number}]($pr->{url}): $pr->{title}\n";
    }
}

print "\n\n# Closed Issues\n\n";
foreach my $pr (@$closedIssues) {
    print "* [$pr->{number}]($pr->{url}): $pr->{title}\n";
}

sub curlCmd {
    my $url = shift;
    my $outFile = shift;
    my $token = shift;
    
    my $baseCmd = "curl -H 'Accept: application/vnd.github.v3+json'";
    $baseCmd .= " -H 'Authorization: token $token'" if $token;
    $baseCmd .= " '$url' > $outFile";

    return $baseCmd;
}

sub getPRs {
    my $baseUrl = shift;
    my $fromTime = shift;
    my $toTime = shift;
    
    my $page = 1;
    my $more = 0;
    
    my @mergedDoltPrs;
    do {
        my $pullsUrl = "$baseUrl&page=$page";
        my $curlDoltPulls = curlCmd($pullsUrl, $doltPullsFile, $token);
        print STDERR "$curlDoltPulls\n";
        system($curlDoltPulls) and die $!;

        $more = 0;
        my $doltPullsJson = json_file_to_perl($doltPullsFile);
        foreach my $pull (@$doltPullsJson) {
            $more = 1;
            next unless $pull->{merged_at};
            return \@mergedDoltPrs if $pull->{merged_at} lt $fromTime;
            my %pr = (
                'url' => $pull->{html_url},
                'number' => $pull->{number},
                'title' => $pull->{title},
                'body' => $pull->{body},
                );

            push (@mergedDoltPrs, \%pr) if $pull->{merged_at} lt $toTime;
        }

        $page++;
    } while $more;
    
    return \@mergedDoltPrs;
}

sub getIssues {
    my $baseUrl = shift;
    my $fromTime = shift;
    my $toTime = shift;
    
    my $page = 1;
    my $more = 0;

    my @closedIssues;
    do {
        my $issuesUrl = "$baseUrl&page=$page";
        my $curlDoltIssues = curlCmd($issuesUrl, $doltIssuesFile, $token);
        print STDERR "$curlDoltIssues\n";
        system($curlDoltIssues) and die $!;

        $more = 0;
        my $doltIssuesJson = json_file_to_perl($doltIssuesFile);
        foreach my $issue (@$doltIssuesJson) {
            $more = 1;
            next unless $issue->{closed_at};
            return \@closedIssues if $issue->{closed_at} lt $fromTime;
            next if $issue->{html_url} =~ m|/pull/|; # the issues API also returns PR results
            my %i = (
                'url' => $issue->{html_url},
                'number' => $issue->{number},
                'title' => $issue->{title},
                'body' => $issue->{body},
                );
            
            push (@closedIssues, \%i) if $issue->{closed_at} lt $toTime; 
        }

        $page++;
    } while $more;
    
    return \@closedIssues;
}
